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
    hdr_info=readGEinfo(fid); 
    
    info.samples=hdr_info.user1;
    info.BW=hdr_info.spectral_width;
    info.transmit_frequency=hdr_info.ps_mps_freq;
    
    info.dynamics = hdr_info.nechoes; 
    info.pc = hdr_info.navs;
    info.averages(1) = hdr_info.user4; %number of data spectra (water-suppressed)
    
    if hdr_info.user41 %  data was not saved after averaging over phase cycle  
        info.averages(2) = hdr_info.nframes - info.averages(1); % number of water spectra            
        nsa=info.averages;
    else                % data was aved after averaging over phase cyle
        info.averages(2) = hdr_info.nframes*info.pc - info.averages(1); % number of water spectra             
        nsa=info.averages/info.pc;   
    end
        
    tot_nsa = sum(nsa);
 
    info.size = [hdr_info.roilenx, hdr_info.roileny, hdr_info.roilenz] ;
    info.offcentre = [hdr_info.roilocx, hdr_info.roilocy, hdr_info.roilocz] ;
    %info.angulation ??;
    
    info.TE= hdr_info.te/1000; % ms
    info.TR=hdr_info.tr/1000; % ms   
    
    fclose(fid);
    
    %% reshape raw data 
    data=reshape(data,2,info.samples,[]);    
    data=squeeze(complex(data(1,:,:),data(2,:,:)));   
    data(:,1:hdr_info.nframes+1:end)=[]; % remove empty space 
      
    info.channels=size(data,2)/tot_nsa/info.dynamics;        
    data=reshape(data,info.samples,tot_nsa,info.dynamics,info.channels);
    
    water=data(:,1:nsa(2),:,:);
    data=data(:,nsa(2)+1:tot_nsa,:,:);
    
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
           for a=1:2:nsa(2)
               water(:,a,d,c)=mrs_rephase(water(:,a,d,c),pc1);
           end
           for a=1:2:nsa(1)
               data(:,a,d,c)=mrs_rephase(data(:,a,d,c),pc1);
           end
           
           [~, pc2]=mrs_zeroPHC(mwater2(:,1,d,c));
           for a=2:2:nsa(2)
               water(:,a,d,c)=mrs_rephase(water(:,a,d,c),pc2);
           end
           for a=2:2:nsa(1)
               data(:,a,d,c)=mrs_rephase(data(:,a,d,c),pc2);
           end
        end
    end
    
    %% weighted reconstruction 
    weights=sum(real((water(:,1,1,:))));
    noise=var(real((data((size(data,1)-round(0.047*size(data,1))):size(data,1),1,1,:))));  
    
    weights=weights./noise;
    weights=weights./sqrt(sum(weights.^2));  

    g2=repmat(weights,[size(data,1) nsa(1) info.dynamics 1]);
    data_recon=g2.*data;  


    g2=repmat(weights,[size(data,1) nsa(2) info.dynamics 1]);
    water_recon=g2.*water;  


    data_recon=squeeze(mean(data_recon,4));
    water_recon=squeeze(mean(water_recon,4));

end
    
function a = readGEinfo(file_id)

  fseek(file_id,70,'bof');
  a.nechoes = fread(file_id, 1, 'int16');
  a.navs = fread(file_id, 1, 'int16');
  a.nframes = fread(file_id, 1, 'int16');%

  fseek(file_id,220,'bof');
  a.user1 = fread(file_id, 1, 'float32');

  fseek(file_id,232,'bof');
  a.user4 = fread(file_id, 1, 'float32');

  fseek(file_id,368,'bof');
  a.spectral_width = fread(file_id, 1, 'float32');

  fseek(file_id,380,'bof');
  a.roilenx = fread(file_id, 1, 'float32');
  a.roileny = fread(file_id, 1, 'float32');
  a.roilenz = fread(file_id, 1, 'float32');
  a.roilocx = fread(file_id, 1, 'float32');
  a.roilocy = fread(file_id, 1, 'float32');
  a.roilocz = fread(file_id, 1, 'float32');
  
  fseek(file_id,424,'bof');
  a.ps_mps_freq = fread(file_id, 1, 'uint32');
  
  fseek(file_id,1084,'bof');
  a.user41 = fread(file_id, 1, 'float32');
  
  fseek(file_id,1212,'bof');
  a.te = fread(file_id, 1, 'int32');  
  
  fseek(file_id, 148036, 'bof');
  a.ctr_R = fread(file_id, 1, 'float32');
  a.ctr_A = fread(file_id, 1, 'float32');
  a.ctr_S = fread(file_id, 1, 'float32');
  a.norm_R = fread(file_id, 1, 'float32');
  a.norm_A = fread(file_id, 1, 'float32');
  a.norm_S = fread(file_id, 1, 'float32');
  a.tlhc_R = fread(file_id, 1, 'float32');
  a.tlhc_A = fread(file_id, 1, 'float32');
  a.tlhc_S = fread(file_id, 1, 'float32');
  a.trhc_R = fread(file_id, 1, 'float32');
  a.trhc_A = fread(file_id, 1, 'float32');
  a.trhc_S = fread(file_id, 1, 'float32');
  a.brhc_R = fread(file_id, 1, 'float32');
  a.brhc_A = fread(file_id, 1, 'float32');
  a.brhc_S = fread(file_id, 1, 'float32');
  
  fseek(file_id, 148396, 'bof');
  a.tr = fread(file_id, 1, 'int32');
 
end
    