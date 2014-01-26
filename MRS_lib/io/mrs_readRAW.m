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
    disp('********** Data loaded **********');
    
    disp('********** Start downsampling **********')    
    if length(info.no_averages)==1
        with_water=0;
    else
        with_water=1;
    end
    
    data_fft=zeros(info.no_points(1),info.no_channels,info.no_averages(1),info.no_dynamics); 
    if with_water
        water_fft=zeros(info.no_points(1),info.no_channels,info.no_averages(2),info.no_dynamics);
    else
        info.no_averages(2)=0;
    end
    
    for d=1:info.no_dynamics
        for c=1:info.no_channels
            if with_water
                for a=1:info.no_averages(2)
                    water_fft(:,c,a,d) = mrs_fft(resample(double(blob.Data.x(1,:,c,a,d)'),info.BW,info.acq_BW) + 1i*resample(double(blob.Data.x(2,:,c,a,d)'),info.BW,info.acq_BW));                
                end
            end
            for a=info.no_averages(2)+1:no_acq_per_dyn
                data_fft(:,c,a-info.no_averages(2),d) = mrs_fft(resample(double(blob.Data.x(1,:,c,a,d)'),info.BW,info.acq_BW) + 1i*resample(double(blob.Data.x(2,:,c,a,d)'),info.BW,info.acq_BW));
            end
            disp(['***** finished for channel=',num2str(c)]);
        end
            disp(['***** finished for dynamic =',num2str(d),' *****']);
    end
    
%     figure     
%     for c=1:info.no_channels
%         subplot(4,8,c);
%         plot(real(squeeze(data_fft(:,c,1,1))));
%         axis([0 4096 -2500 10000]);
%         title(['channel ',num2str(c)]);
%     end

%     figure     
%     for c=1:info.no_channels
%         subplot(4,8,c);
%         plot(real(squeeze(water_fft(:,c,1,1))));
%         axis([0 4096 -1e05 1.5e05]);
%         title(['channel ',num2str(c)]);
%     end
    
    disp('********** phase correction **********')
    if with_water
       S_w =zeros(1,info.no_channels,info.no_averages(2),info.no_dynamics);
       for c=1:info.no_channels
            for d=1:info.no_dynamics
                for a=1:info.no_averages(2)
                     w_spect=squeeze(water_fft(:,c,a,d));
                     water_fft(:,c,a,d)=mrs_ACME(w_spect,[0 0]);
                     S_w(:,c,a,d)=max(real(water_fft(:,c,a,d)));
                     %N(:,c,a,d) = std(real(water_fft(round(noise_peak_range(1)):round(noise_peak_range(2)),c,a,d)));                
                end
            end
            disp(['***** finished for channel=',num2str(c)]);
       end   
        
       weights_w=S_w./repmat(sum(S_w,2),1,32);
       clear S_w
    end         
   
	S_d =zeros(1,info.no_channels,info.no_averages(1),info.no_dynamics);   
	for c=1:info.no_channels
        for d=1:info.no_dynamics
            for a=1:info.no_averages(1)
                d_spect=squeeze(data_fft(:,c,a,d));
                data_fft(:,c,a,d)=mrs_ACME(d_spect,[0 0]);
                S_d(:,c,a,d)=max(real(data_fft(:,c,a,d)));
                %N(:,c,a,d) = std(real(water_fft(round(noise_peak_range(1)):round(noise_peak_range(2)),c,a,d))); 
                %disp(['***** finished for averages=',num2str(a)]);
            end
        end
        disp(['***** finished for channel=',num2str(c)]);
	end 

    
%     figure     
%     for c=1:info.no_channels
%         subplot(4,8,c);
%         plot(real(squeeze(data_fft(:,c,1,1))));
%         axis([0 4096 -2500 10000]);
%         title(['channel ',num2str(c)]);
%     end
%     
    
%    weights=S./N; 

    weights_d=S_d./repmat(sum(S_d,2),1,32);
    clear S_d
    
    samples=info.no_points(1);
    water_peak_range = [1500,2500];
    if with_water
        % weighted average across 32 channels for water reference spectra        
        water_fft=repmat(weights_w,samples,1).*water_fft;
        water_fft= mrs_realign(reshape(water_fft, samples,[]), water_peak_range); 
        water = squeeze(sum(reshape(water_fft,samples,info.no_channels,info.no_averages(2),info.no_dynamics),2));      
    end
    
    %  weighted average across 32 channels for data spectra
    data_fft=repmat(weights_d,samples,1).*data_fft;
    if ~with_water
        data_fft= mrs_realign(reshape(data_fft, samples,[]), water_peak_range); 
    end
    data = squeeze(sum(reshape(data_fft,samples,info.no_channels,info.no_averages(1),info.no_dynamics),2));  
    
%     data = squeeze(sum(data_fft,2));
%     for c=1:info.no_channels
%         for d=1:info.no_dynamics
%             for a=1:info.no_averages(1)
%                 d_spect=squeeze(data_fft(:,c,a,d));
%                 data_fft(:,c,a,d) = mean(weights_d(:,c,:,d),3).*mrs_rephase( d_spect, ph_ch(:,c,1,d) );                  
%             end          
%         end
%         disp(['***** finished for channel=',num2str(c)]); 
%      end
    
   
end

