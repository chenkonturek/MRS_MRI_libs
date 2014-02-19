function [fids spects] = mrs_readJmruiTXT( fileName )
% MRS_READJMRUITXT reads jMRUI output MRS data file in .txt format 
%
% [fids spects] = mrs_readJmruiTxt( fileName )
%
% ARGS :
% fileName = name of data file 
%
% RETURNS:
% fids = FIDs 
% spects = spectra 
%
% EXAMPLE: 
% >> [fids spects] = mrs_readJmruiTXT('sub1.txt');
%
% REFERENCE: 
% jMRUI software : http://www.mrui.uab.es/mrui/mrui_Overview.shtml
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

	[~,~,ext]=fileparts(fileName);    
	if isempty(ext)==1
        fileName=[fileName,'.txt'];
	end
    
    fid=fopen(fileName,'r');
	content=textscan(fid,'%s','delimiter','\n');   
	fclose(fid);
    
	no_lines=size(content{1});
    sig_c = 0;        
	for i=1:no_lines 
        
        line=content{1}{i};    
        sample_ind = strfind(line,'PointsInDataset');
        num_ind = strfind(line,'DatasetsInFile');
        sig_ind = strfind(line,'Signal'); 
        
        if ~isempty(sample_ind) 
            str_temp = textscan(line, '%s', 'delimiter', ':');  
            sample= str2double(str_temp{1}{2});   
        end
        
        if ~isempty(num_ind) 
            str_temp = textscan(line, '%s', 'delimiter', ':');  
            num= str2double(str_temp{1}{2});   
            
            fids = zeros(sample,num);
            spects = zeros(sample,num);

        end
        
                         
        if ~isempty(sig_ind) 
            sig_c = sig_c+1; 
            p=0;
        end  
        
        if sig_c > 1 && isempty(sig_ind) 
            p = p+1;
            str_temp = textscan(line, '%s', 'delimiter', '\t');                     
            fids(p,sig_c-1)= str2double(str_temp{1}{1}) + 1i*str2double(str_temp{1}{2});
            spects(p,sig_c-1)= str2double(str_temp{1}{3}) + 1i*str2double(str_temp{1}{4});
        end
                              
	end 
end

