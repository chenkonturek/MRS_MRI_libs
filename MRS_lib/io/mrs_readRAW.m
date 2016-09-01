function [data_recon, water_recon] = mrs_readRAW(fileName) 
% MRS_READRAW reads Philips raw data (.RAW). 
% If water suppression is enabled, .data file contains water-unsuppressed spectra (water)  
% and water-suppressed spectra (data). 
% 
% [data_recon water_recon] = mrs_readRAW_MEGA(fileName)
%
% ARGS :
% fileName = name of raw data file 
%
% RETURNS:
% data =  water-suppressed FIDs without averaging 
% water =  water-unsuppressed FIDs without averaging     
%
% EXAMPLE: 
% >> [data_recon water_recon] = mrs_readRAW_MEGA('sub4.RAW');
%
% AUTHOR : Chen Chen, Emma Hall
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.

    %% Select .raw file to read in
    [~,file_name,ext]=fileparts(fileName); 
    
    info=mrs_readSIN([file_name,'.sin']);
    no_acq_per_dyn=info.no_averages(1)+info.no_averages(2);
    
    if isempty(ext)==1
        fileName=[fileName,'.raw'];
    end
   
    %% Read in data and find starting point of recording
    fid=fopen(fileName,'r','l');  %data is little endian

    fseek(fid,1000,'bof');
    data=fread(fid,inf,'int16=>int16');
    g=find(abs(data)>15,1,'first');

    plot(data(g-10:g+10));hold on;plot(11,data(g),'r*');
    f=input('What value should g be shifted by?');
    g=g+f;
    close all;plot(data(g-10:g+10));hold on;plot(11,data(g),'r*');
    close all;
    g=g-1;
    %clear firstpoints
    B = uint8(info.no_acq_points/info.no_points(1));
    A = isinteger(B);
    %keyboard
    %% reshaping data in a less memory intesive way
    disp('Reshaping data')
    datatemp = int16(zeros(1,2*info.no_acq_points*info.no_channels*no_acq_per_dyn*info.no_dynamics));
    chunk = length(datatemp)/no_acq_per_dyn/info.no_channels;
    for dti = 0:(no_acq_per_dyn*info.no_channels)-1
        ind = chunk*dti+1;
        datatemp(ind:ind+chunk-1) = data(ind+g:ind+chunk-1+g);
    end

    data = reshape(datatemp,2,info.no_acq_points, info.no_channels,no_acq_per_dyn, info.no_dynamics);
    clear datatemp

    %% Separate data into water/spectra and combine real and imaginary
    water = data(:,:,:,1:info.no_averages(2),:);
    water = complex(water(1,:,:,:,:),water(2,:,:,:,:));

    data = data(:,:,:,info.no_averages(2)+1:no_acq_per_dyn,:);
    data = complex(data(1,:,:,:,:),data(2,:,:,:,:));

    disp('Processing Data, please wait ....')

    %% Downsample to required bandwidth
    water = reshape(water,info.no_acq_points/info.no_points(1),info.no_points(1),info.no_channels,info.no_averages(2),info.no_dynamics);
    data = reshape(data,info.no_acq_points/info.no_points(1),info.no_points(1),info.no_channels,info.no_averages(1),info.no_dynamics);

    water_spects=mrs_fft(squeeze(mean(water,1)));
    data_spects=mrs_fft(squeeze(mean(data,1))); 

    clear data water

    %% Apply phase correction to water & data spectra  
    pc_all=zeros(1,info.no_channels);
    water_pc=zeros(size(water_spects));
    data_pc=zeros(size(data_spects));
    for c=1:info.no_channels
         [~, pc_all(c)]=mrs_zeroPHC(mean(mean(water_spects(:,c,:,:),3),4));
        for d=1:info.no_dynamics
            for a=1:info.no_averages(2)         
                water_pc(:,c,a,d) = mrs_rephase(water_spects(:,c,a,d),pc_all(c));
            end
        end
    end

    for d = 1:info.no_dynamics
        for a = 1:info.no_averages(1);
            for c = 1:info.no_channels;
                data_pc(:,c,a,d) = mrs_rephase(data_spects(:,c,a,d),pc_all(c));
            end
        end
    end

    %% Weighted combination of 32-channel data  
    weights=sum(real(water_pc(:,:,1,1)));
    noise=var(real(data_pc(3800:4096,:,1,1)));  
    
    weights=weights./noise;
    weights=weights./sqrt(sum(weights.^2));  

    g2=repmat(weights,[4096 1 info.no_averages(1) info.no_dynamics]);
    data_recon=g2.*data_pc;  


    g2=repmat(weights,[4096 1 info.no_averages(2) info.no_dynamics]);
    water_recon=g2.*water_pc;  

    %% Average over the channels
    data_recon=squeeze(mean(data_recon,2));
    water_recon=squeeze(mean(water_recon,2));

