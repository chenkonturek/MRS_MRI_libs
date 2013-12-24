function info = mrs_readLIST( fileName )
% MRS_READLIST reads Philips MRS header file (.list) 
%
% info = mrs_readLIST(fileName)
%
% ARGS :
% fileName = name of header file 
%
% RETURNS:
% info = header file information 
%
% EXAMPLE: 
% >> info = mrs_readLIST('sub1.list');
% >> disp(info)
%	noise_avgs: 32     % no. of noise spectra  
%	dynamics: [2 2]    % no. of dynamics 
%	averages: [272 2]  % no. of data spectra & water spectra in a dynamic
%   samples: [4096 4096] % no. of points in the data & water spectrum 
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

	[~,~,ext]=fileparts(fileName);    
	if isempty(ext)==1
        fileName=[fileName,'.list'];
	end
    
    fid=fopen(fileName,'r');
	header_info=textscan(fid,'%s','delimiter','\n');
	fclose(fid);
    
	no_lines=size(header_info{1});
            
    s_count=0;
	a_count=0;
    d_count=0;
	info.noise_avgs=0; 
 	is_data_index=0;   % not reach the data vector index part          
    
	for i=1:no_lines % for each line 
        line=header_info{1}{i};   

        if is_data_index==0    
            avg_ind = strfind(line, 'number_of_signal_averages');
            dyn_ind=strfind(line, 'number_of_extra_attribute_1');
            s_ind = strfind(line,'t_range');
            data_ind=strfind(line,'START OF DATA VECTOR INDEX ');

            if ~isempty(s_ind)
                s_count=s_count+1;
                str_temp = textscan(line, '%s', 'delimiter', ' '); 
                n=length(str_temp{1});
                info.samples(s_count)= str2double(str_temp{1}{n})+1;      

            elseif ~isempty(dyn_ind) 
                d_count=d_count+1;
                str_temp = textscan(line, '%s', 'delimiter', ' ');
                n=length(str_temp{1});
                info.dynamics(d_count) = str2double(str_temp{1}{n});

            elseif ~isempty(avg_ind) 
                a_count=a_count+1;
                str_temp = textscan(line, '%s', 'delimiter', ' ');
                n=length(str_temp{1});
              
                info.averages(a_count) = str2double(str_temp{1}{n}); 
                        
            elseif ~isempty(data_ind)                        
                is_data_index=1;   
            end           
                    
        else % if reaches the data vector index part
            noi_ind=strfind(line,'NOI');
                   
            if ~isempty(noi_ind) 
                info.noise_avgs=info.noise_avgs+1;% no. of noise spectra             
            end
        end
                
	end  
    
end

