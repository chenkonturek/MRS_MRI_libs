function [data_recon, water_recon] = mrs_recon(data, water, w)
% MRS_RECON combines data collected from all channels with a weighting factor  
% 
% [data_recon, water_recon] = mrs_recon(data, water, eqw)
%
% ARGS :
% data = water-suppressed FIDs from each channel for each average and dynamic       
% water = [], if water supression is not enabled;
%         otherwise, contains all FIDs without water suppression.  
% w = if 0 means with equal weighting, otherwise means with weighter factor of S/(N^2)
% 
% RETURNS:
% data_recon = water-suppressed spectra for each average and dynamic after data reconstruction, during which process that data from each channel were conbimed   
% water_recon = [], if water supression is not enabled;
%               otherwise, contains all spectra without water suppression after reconstruction.                  
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.

    data_spects = mrs_fft(data);   
    if ~isempty(water)
        water_spects = mrs_fft(water);     
        [data_recon water_recon] = mrs_calweightedSpects(data_spects, water_spects, w);
    else
        water_recon=[];
        data_recon=mrs_calweightedData(data_spects, w);
    end
end

function [data water]= mrs_calweightedSpects(data_spects, water_spects, w)
    disp('********** Start calculating averaged spectra across channels **********')  
    [no_points,no_channels,no_averages1,no_dynamics]=size(data_spects);
     no_averages2=size(water_spects,3);
     
    water_amp = zeros(no_channels,no_dynamics);
    noise = zeros(no_channels,no_dynamics);
    
    for c=1:no_channels
        for d=1:no_dynamics
            [water_spect,ph]=mrs_zeroPHC(squeeze(mean(water_spects(:,c,:,d),3)));
            water_amp(c,d)=max(real(water_spect));
            noise(c,d)=std(real(water_spect(no_points-296:no_points))); % note: 296 is a good choice for sample=4096
            
            for a=1:no_averages1                              
                data_spects(:,c,a,d)=mrs_rephase(data_spects(:,c,a,d),ph); % phase corrected data spectra
            end            
            
            for a=1:no_averages2               
                water_spects(:,c,a,d)=mrs_rephase(water_spects(:,c,a,d),ph); % phase corrected water spectra
            end
        end
        %disp(['***** finished for channel=',num2str(c)]);
    end
    
    if w == 0 
        weighting=ones(no_channels,no_dynamics);
    else
        R=water_amp./(noise.^2); % weighting factor is S/N^2
        weighting=R./sqrt(sum(R.^2));
    end

    % calculating weighted average data and water reference 
    data=zeros(no_points,no_averages1,no_dynamics);
    water=zeros(no_points,no_averages2,no_dynamics);
    
    for d=1:no_dynamics 
        for a=1:no_averages1            
            for c=1:no_channels
                data(:,a,d)=data(:,a,d)+weighting(c,d)*data_spects(:,c,a,d);
            end
        end
        
        for a=1:no_averages2            
            for c=1:no_channels
                water(:,a,d)=water(:,a,d)+weighting(c,d)*water_spects(:,c,a,d);
            end
        end
    end
                       
end

function  data = mrs_calweightedData(data_spects, w)
   disp('********** Start calculating averaged spectra across channels **********')
   [no_points,no_channels,no_averages1,no_dynamics]=size(data_spects);
   water_amp = zeros(no_channels,no_dynamics);
   noise = zeros(no_channels,no_dynamics);
   
    for c=1:no_channels
        for d=1:no_dynamics
            [data_spect,~]=mrs_zeroPHC(squeeze(mean(data_spects(:,c,:,d),3)));
            water_amp(c,d)=max(real(data_spect));
            noise(c,d)=std(real(data_spect(no_points-296:no_points))); % note: 296 is a good choice for sample=4096
        end
       % disp(['***** finished for channel=',num2str(c)]);
    end

    if w == 0 
        weighting=ones(no_channels,no_dynamics);
    else
        R=water_amp./(noise.^2); % weighting factor is S/N^2
        weighting=R./sqrt(sum(R.^2));
    end
    
    % calculating weighted average data 
    data=zeros(no_points,no_averages1,no_dynamics);
    
    for d=1:no_dynamics 
        for a=1:no_averages1            
            for c=1:no_channels
                [data_spects(:,c,a,d),~]=mrs_zeroPHC(data_spects(:,c,a,d));
                data(:,a,d)=data(:,a,d)+weighting(c,d)*data_spects(:,c,a,d);
            end
        end
    end
end


