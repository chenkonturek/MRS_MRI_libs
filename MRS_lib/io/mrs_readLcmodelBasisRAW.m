function FID = mrs_readLcmodelBasisRAW( fileName )
% MRS_READLCMODELBASISRAW reads .RAW file for generating LCmodel .basis. which contains  
% time domain data of a metabolite spectrum. 
% 
% FID = mrs_readLcmodelBasisRAW( fileName )
%
% ARGS :
% fileName = name of LCModel output .RAW file 
%
% RETURNS:
% FID =  time domain data
% 
% EXAMPLE: 
% >> FID = mrs_readLcmodelBasisRAW( fileName );
% >> figure; plot(real(fft(FID)));
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.

    [~,~,ext]=fileparts(fileName);  
    
    if isempty(ext)==1
        fileName=[fileName,'.RAW'];
    end
    
    
    fid=fopen(fileName,'r');
    header_info=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    no_lines=size(header_info{1});
    ln=no_lines+1;
    for i=1:no_lines
        line=header_info{1}{i};    
       
        if ~isempty(strfind(line, '$END'))
              ln=i;
        end
        
        if i>ln 
            str_temp = textscan(line, '%s', 'delimiter', ' ');
            FID(i-ln)=str2double(str_temp{1}{1})+1i.*str2double(str_temp{1}{end});    
        end
    end
   
    
end

