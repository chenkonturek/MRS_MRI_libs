function info = mri_readPAR( fileName ) 
% MRI_READHDR reads Philips MRI header file (.PAR)
% 
% info = mri_readPAR( fileName ) 
%
% ARGS :
% fileName = name of header file 
%
% RETURNS:
% info = header file information
% 
%
% EXAMPLE: 
% >> info = mri_readHDR('sub1.PAR');
% >> disp(info)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

	[~, ~, ext]=fileparts(fileName);    
	if isempty(ext)==1
        fileName=[fileName,'.PAR'];
	end
     
    fid=fopen(fileName,'r');
	header_info=textscan(fid,'%s','delimiter','\n');
	fclose(fid);
       
	no_lines=size(header_info{1});
    maxDyn = 0;        
	for i=1:no_lines % 
        line=header_info{1}{i};
        maxslice_ind = strfind(line,'Max. number of slices');
        dyn_ind = strfind(line, 'Max. number of dynamics');
        angulation_ind = strfind(line,'Angulation midslice'); 
        offCentre_ind = strfind(line, 'Off Centre midslice');    
        dir_ind = strfind(line,'Preparation direction');
        fov_ind = strfind(line, 'FOV');
                                
        if ~isempty(maxslice_ind) %
            str_temp = textscan(line, '%s', 'delimiter', ':');  
            maxSlice= str2double(str_temp{1}{2}); 
        elseif ~isempty(dyn_ind) % 
            str_temp = textscan(line, '%s', 'delimiter', ':');  
            maxDyn= str2double(str_temp{1}{2});  
        elseif ~isempty(dir_ind) %    
            str_temp = textscan(line, '%s', 'delimiter', ':');
            if str_temp{1}{2}(1)=='R'
                info.direction = 'rl';
            else
                info.direction = 'ap';
            end
        elseif ~isempty(angulation_ind) % 
            str_temp = textscan(line, '%s', 'delimiter', ':');
            str_temp=textscan(str_temp{1}{2}, '%s', 'delimiter', ' ');
            info.angulations = [str2double(str_temp{1}{1}), str2double(str_temp{1}{3}), str2double(str_temp{1}{5})];                   
                    
        elseif ~isempty(offCentre_ind) %
            str_temp = textscan(line, '%s', 'delimiter', ':');
            str_temp=textscan(str_temp{1}{2}, '%s', 'delimiter', ' ');
            info.offCentre = [str2double(str_temp{1}{1}), str2double(str_temp{1}{3}), str2double(str_temp{1}{5})];                   
                    
        elseif ~isempty(fov_ind) % ap,fh,rl
            str_temp = textscan(line, '%s', 'delimiter', ':');
            str_temp=textscan(str_temp{1}{2}, '%s', 'delimiter', ' ');
            info.FOV = [str2double(str_temp{1}{1}), str2double(str_temp{1}{3}), str2double(str_temp{1}{5})];                    
            
        end                             
	end 
    
    [slice_index(:,1) slice_index(:,2) slice_index(:,3) slice_index(:,4) slice_index(:,5) slice_index(:,6) slice_index(:,7) slice_index(:,8) slice_index(:,9) slice_index(:,10) ...
    slice_index(:,11) slice_index(:,12) slice_index(:,13) slice_index(:,14) slice_index(:,15) slice_index(:,16) slice_index(:,17) slice_index(:,18) slice_index(:,19) ...
    slice_index(:,20) slice_index(:,21) slice_index(:,22) slice_index(:,23) slice_index(:,24) slice_index(:,25) slice_index(:,26) slice_index(:,27) ...
    slice_index(:,28) slice_index(:,29) slice_index(:,30)] = textread (fileName,'%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%*[^\n]','delimiter',' ','headerlines',90,'commentstyle','shell');

    info.vox(1)=slice_index(1,29);
    info.vox(2)=slice_index(1,30);
    info.vox(3)=info.FOV(2)/maxSlice;
   
    % get data about the first slice
    lineplus = 1;
    ln = 97+2*lineplus;
    parameter = textread (fileName,'%s',41, 'headerlines',ln);    
    
    info.dim =[str2double(parameter{10}) str2double(parameter{11}) maxSlice maxDyn];
end

