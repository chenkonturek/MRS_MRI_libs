function [data, water] = mrs_readRAW( fileName )
% MRS_READRAW reads Philips MRS raw data file (.data). 
% If water suppression is enabled, .data file contains water-unsuppressed spectra (water)  
% and water-suppressed spectra (data). 
% 
% [data water] = mrs_readRAW(fileName)
%
% ARGS :
% fileName = name of raw data file 
%
% RETURNS:
% data = all water-suppressed FIDs without averaging, if water supression is not enabled;
%        otherwise, contains all target FIDs collected without averaging 
% water = [], if water supression is not enabled;
%         otherwise, contains all FIDs without water suppression  
%
% EXAMPLE: 
% >> [data water] = mrs_readRAW('sub4.RAW');
% >> size(data)
% >> size(water)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


    [~,file_name,ext]=fileparts(fileName); 
    
    info=mrs_readSIN([file_name,'.sin']);
    
    if isempty(ext)==1
        fileName=[fileName,'.raw'];
    end
    
    preData_length=info.no_points(end)+64; % in int16
    noise_length=2*info.no_channels*info.no_acq_points; % in int16
    
    data_offset=(preData_length+noise_length)*2; % in Bytes
     
    no_acq_per_dyn=sum(info.no_averages); % number of acquisitions for data + water
    
    blob=memmapfile(fileName,'Format',{'int16' [2,info.no_acq_points,info.no_channels,no_acq_per_dyn,info.no_dynamics] 'x'},'Offset', data_offset);  
   
    
    % downsampling 
    [data_spects water_spects] = mrs_downsample(blob, info);
    
    % calculating weighted data spectra based on water reference (phase corrected)
    
    if length(info.no_averages)==1
        with_water=0;
    else
        with_water=1;
    end
    
    if with_water
        [data water] = mrs_calweightedSpects(data_spects, water_spects, info);
    else
        water=[];
        data=mrs_calweightedData(data_spects, info);
    end
    
end

function [data_spects water_spects] = mrs_downsample(blob, info)

    disp('********** Start downsampling **********')
    if length(info.no_averages)==1
        with_water=0;
    else
        with_water=1;
    end
    no_acq_per_dyn=sum(info.no_averages); % number of acquisitions for data + water
    
    data_spects=zeros(info.no_points(1),info.no_channels,info.no_averages(1),info.no_dynamics);
    if with_water
        water_spects=zeros(info.no_points(1),info.no_channels,info.no_averages(2),info.no_dynamics);
    else
        info.no_averages(2)=0;
    end

    for d=1:info.no_dynamics
        for c=1:info.no_channels
            if with_water
                for a=1:info.no_averages(2)
                    water_spects(:,c,a,d) = mrs_fft(resample(double(blob.Data.x(1,:,c,a,d)'),info.no_points(1),info.no_acq_points) + 1i*resample(double(blob.Data.x(2,:,c,a,d)'),info.no_points(1),info.no_acq_points));
                end
            end
            for a=info.no_averages(2)+1:no_acq_per_dyn
                data_spects(:,c,a-info.no_averages(2),d) = mrs_fft(resample(double(blob.Data.x(1,:,c,a,d)'),info.no_points(1),info.no_acq_points) + 1i*resample(double(blob.Data.x(2,:,c,a,d)'),info.no_points(1),info.no_acq_points));
            end
            disp(['***** finished for channel=',num2str(c)]);
        end
        disp(['***** finished for dynamic =',num2str(d),' *****']);
    end

end


function [data water]= mrs_calweightedSpects(data_spects, water_spects, info)
    disp('********** Start calculating averaged spectra across channels **********')
    water_amp = zeros(info.no_channels,info.no_dynamics);
    
    for c=1:info.no_channels
        for d=1:info.no_dynamics
            [water_spect,ph]=mrs_zeroPHC(squeeze(mean(water_spects(:,c,:,d),3)));
            water_amp(c,d)=max(real(water_spect));
            
            for a=1:info.no_averages(1)                              
                data_spects(:,c,a,d)=mrs_rephase(data_spects(:,c,a,d),ph); % phase corrected data spectra
            end            
            
            for a=1:info.no_averages(2)               
                water_spects(:,c,a,d)=mrs_rephase(water_spects(:,c,a,d),ph); % phase corrected water spectra
            end
        end
        disp(['***** finished for channel=',num2str(c)]);
    end

    weighting=water_amp./repmat(sum(water_amp),info.no_channels,1);
    
    % calculating weighted average data and water reference 
    data=zeros(info.no_points(1),info.no_averages(1),info.no_dynamics);
    water=zeros(info.no_points(1),info.no_averages(2),info.no_dynamics);
    
    for d=1:info.no_dynamics 
        for a=1:info.no_averages(1)            
            for c=1:info.no_channels
                data(:,a,d)=data(:,a,d)+weighting(c,d)*data_spects(:,c,a,d);
            end
        end
        
        for a=1:info.no_averages(2)            
            for c=1:info.no_channels
                water(:,a,d)=water(:,a,d)+weighting(c,d)*water_spects(:,c,a,d);
            end
        end
    end
                       
end

function  data=mrs_calweightedData(data_spects, info)
   disp('********** Start calculating averaged spectra across channels **********')
   water_amp = zeros(info.no_channels,info.no_dynamics);
    
    for c=1:info.no_channels
        for d=1:info.no_dynamics
            [data_spect,~]=mrs_zeroPHC(squeeze(mean(data_spects(:,c,:,d),3)));
            water_amp(c,d)=max(real(data_spect));
        end
        disp(['***** finished for channel=',num2str(c)]);
    end

    weighting=water_amp./repmat(sum(water_amp),info.no_channels,1);
    
    % calculating weighted average data 
    data=zeros(info.no_points(1),info.no_averages(1),info.no_dynamics);
    
    for d=1:info.no_dynamics 
        for a=1:info.no_averages(1)            
            for c=1:info.no_channels
                [data_spects(:,c,a,d),~]=mrs_zeroPHC(data_spects(:,c,a,d));
                data(:,a,d)=data(:,a,d)+weighting(c,d)*data_spects(:,c,a,d);
            end
        end
    end
end

