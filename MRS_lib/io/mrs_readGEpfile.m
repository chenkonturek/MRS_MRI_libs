function [data_recon, water_recon, info] = mrs_readGEpfile( fileName )
% MRS_READGEPFILE reads data and header information from a GE MR spectroscopy raw file (Pxxx.7).  
%
% [data_recon, water_recon, info] = mrs_readGEpfile( fileName ) 
%
% ARGS :
% fileName = name of raw GE MRS data file 
%
% RETURNS:
% data_recon = reconstructed water-suppressed spectra [samples, averages,dynamics]
% water_recon = reconstructed water-unsuppressed spectra   [samples, averages,dynamics]
% info = header information 
% 
%
% EXAMPLE: 
% >> [data, water, info] = mrs_readRDA('P0000.7');
% >> figure; plot(real(data));
%
% AUTHOR : Chen Chen, Felix Raschk 
% PLACE  : Sir Peter Mansfield Imaging Centre (SPMIC)
%
% Copyright (c) 2017, University of Nottingham. All rights reserved.


    [~,~,ext]=fileparts(fileName);  
    
    if isempty(ext)==1
        fileName=[fileName,'.7'];
    end

    fid = fopen(fileName,'r', 'ieee-le');
    fseek(fid, 1468, 'bof');
    pfile_header_size = fread(fid,1,'integer*4');
    fclose(fid);

    % read data 
    fid = fopen(fileName,'r', 'ieee-le');
    fseek(fid, pfile_header_size, 'bof');
    data=fread(fid,'int32');
   
    % read in header information  
    fseek(fid, 0, 'bof');
    hdr_value = fread(fid, 52, 'integer*2');
    info.averages(2) = hdr_value(37); % number of averages of un-suppressed water reference data
    info.dynamics = hdr_value(36); % if MEGA-PRESS, 1st dyn: Edit_ON, 2nd dyn: Edit_OFF
    tot_averages = hdr_value(38);
    info.samples = hdr_value(52);
    fclose(fid);
    
    info.averages(1)=tot_averages-info.averages(2);% number of averages of water-suppressed data
    data=reshape(data,2,info.samples,[]);
    
    data=squeeze(complex(data(1,:,:),data(2,:,:)));
    data(:,1:tot_averages+1:end)=[]; % remove empty space 
    
    info.channels=size(data,2)/tot_averages/info.dynamics;    
    data=reshape(data,info.samples,tot_averages,info.dynamics,info.channels);
    
  
    water=data(:,1:info.averages(2),:,:);
    data=data(:,info.averages(2)+1:tot_averages,:,:);
    
    %% phase correction 
    water=mrs_fft(water);
    data=mrs_fft(data);

    % there is a phase alternation between even and odd scans, so correct
    % them separately 
    mwater1 = mean(water(:,1:2:end,:,:),2); 
    mwater2 = mean(water(:,2:2:end,:,:),2);
    
      
    for c=1:info.channels
        for d=1:info.dynamics
           [~, pc1]=mrs_zeroPHC(mwater1(:,1,d,c));
           for a=1:2:info.averages(2)
               water(:,a,d,c)=mrs_rephase(water(:,a,d,c),pc1);
           end
           for a=1:2:info.averages(1)
               data(:,a,d,c)=mrs_rephase(data(:,a,d,c),pc1);
           end
           
           [~, pc2]=mrs_zeroPHC(mwater2(:,1,d,c));
           for a=2:2:info.averages(2)
               water(:,a,d,c)=mrs_rephase(water(:,a,d,c),pc2);
           end
           for a=2:2:info.averages(1)
               data(:,a,d,c)=mrs_rephase(data(:,a,d,c),pc2);
           end
        end
    end
    
    %% weighted reconstruction 
    weights=sum(real((water(:,1,1,:))));
    noise=var(real((data((size(data,1)-round(0.047*size(data,1))):size(data,1),1,1,:))));  
    
    weights=weights./noise;
    weights=weights./sqrt(sum(weights.^2));  

    g2=repmat(weights,[size(data,1) info.averages(1) info.dynamics 1]);
    data_recon=g2.*data;  


    g2=repmat(weights,[size(data,1) info.averages(2) info.dynamics 1]);
    water_recon=g2.*water;  


    data_recon=squeeze(mean(data_recon,4));
    water_recon=squeeze(mean(water_recon,4));

    
    
    
    
    
    
