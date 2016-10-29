function [data info] = mrs_readRDA( fileName )
% MRS_READRDA reads data and header information from a Siemens MR spectroscopy file (.rda) 
%
% [data info] = mrs_readRDA( fileName ) 
%
% ARGS :
% fileName = name of data file 
%
% RETURNS:
% data = averaged FIDs  
% info =header information 
%
% EXAMPLE: 
% >> [data info] = mrs_readRDA('sub1.rda');
% >> size(fid)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Imaging Centre (SPMIC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.

    [~,~,ext]=fileparts(fileName);  
    
    if isempty(ext)==1
        fileName=[fileName,'.rda'];
    end
    
    fid = fopen(fileName);
    
     ln= fgets(fid);
     while (isempty(strfind(ln,'>>> End of header <<<')))
         ln=fgets(fid);
         
         if ~isempty(strfind(ln,'TE:'))  
            st = textscan(ln, '%s', 'delimiter', ':');
            info.TE= str2double(st{1}{end});
            
         elseif ~isempty(strfind(ln,'TR:'))  
            st = textscan(ln, '%s', 'delimiter', ':');
            info.TR= str2double(st{1}{end});
            
         elseif ~isempty(strfind(ln,'DwellTime:'))  
            st = textscan(ln, '%s', 'delimiter', ':');
            info.BW= 10^6/str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'NumberOfAverages:')) 
             st = textscan(ln, '%s', 'delimiter', ':');
             info.averages= str2double(st{1}{end});
            
         elseif ~isempty(strfind(ln,'MRFrequency:'))  
             st = textscan(ln, '%s', 'delimiter', ':');
             info.transmit_frequency= str2double(st{1}{end})*10^6;
             
         elseif ~isempty(strfind(ln,'VectorSize:'))
             st = textscan(ln, '%s', 'delimiter', ':');
             info.samples= str2double(st{1}{end});
         
         elseif ~isempty(strfind(ln,'PositionVector[0]'))  %LR         
             st = textscan(ln, '%s', 'delimiter', ':');
             info.offcentre(1)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'PositionVector[1]'))   % AP 
             st = textscan(ln, '%s', 'delimiter', ':');
             info.offcentre(2)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'PositionVector[2]'))  % FH 
              st = textscan(ln, '%s', 'delimiter', ':');
             info.offcentre(3)= str2double(st{1}{end});        
         
         elseif ~isempty(strfind(ln,'VOIPositionSag'))  %LR         
             st = textscan(ln, '%s', 'delimiter', ':');
             info.angulation(1)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'VOIPositionCor'))   % AP 
             st = textscan(ln, '%s', 'delimiter', ':');
             info.angulation(2)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'VOIPositionTra'))  % FH 
              st = textscan(ln, '%s', 'delimiter', ':');
             info.angulation(3)= str2double(st{1}{end});  
             
         elseif ~isempty(strfind(ln,'FoVHeight:'))  %LR         
             st = textscan(ln, '%s', 'delimiter', ':');
             info.FOV(1)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'FoVWidth:'))   % AP 
             st = textscan(ln, '%s', 'delimiter', ':');
             info.FOV (2)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'FoV3D:'))  % FH 
              st = textscan(ln, '%s', 'delimiter', ':');
             info.FOV(3)= str2double(st{1}{end});        
             
         elseif ~isempty(strfind(ln,'NumberOfRows:'))  %LR         
             st = textscan(ln, '%s', 'delimiter', ':');
             info.dim(1)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'NumberOfColumns:'))   % AP 
             st = textscan(ln, '%s', 'delimiter', ':');
             info.dim(2)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'NumberOf3DParts:'))  % FH 
              st = textscan(ln, '%s', 'delimiter', ':');
             info.dim(3)= str2double(st{1}{end});    
         
         elseif ~isempty(strfind(ln,'PixelSpacingRow:'))  %LR         
             st = textscan(ln, '%s', 'delimiter', ':');
             info.size(1)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'PixelSpacingCol:'))   % AP 
             st = textscan(ln, '%s', 'delimiter', ':');
             info.size(2)= str2double(st{1}{end});
             
         elseif ~isempty(strfind(ln,'PixelSpacing3D:'))  % FH 
             st = textscan(ln, '%s', 'delimiter', ':');
             info.size(3)= str2double(st{1}{end});                
         end
     end
   
     if (sum(info.size==info.FOV)==3)
         info.csi=0; % single voxel spectroscopy
     else
         info.csi=1;
     end
    
    info.dynamics = 0; % ???   

    data = fread(fid , info.dim(1) * info.dim(2) *info.dim(3) *info.samples * 2 , 'double');  
    fclose(fid);

    data = reshape(data, 2, info.samples, info.dim(1), info.dim(2), info.dim(3));

    data  = complex(data(1,:,:,:,:),data(2,:,:,:,:));

    data = reshape(data, info.samples, info.dim(1), info.dim(2), info.dim(3));
end