function [FID, info]= mrs_readLcmodelBasisRAW( fileName )
% MRS_READLCMODELBASISRAW reads .RAW file for generating LCmodel .basis. which contains  
% time domain data of a metabolite spectrum. 
% 
% FID = mrs_readLcmodelBasisRAW( fileName )
%
% ARGS :
% fileName = name of LCModel output .RAW file 
% info = header information 
%
% RETURNS:
% FID =  time domain data
% 
% EXAMPLE: 
% >> [FID, info]= mrs_readLcmodelBasisRAW( fileName );
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
    content=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    no_lines=size(content{1});
    ln=no_lines+1;
    for i=1:no_lines
        line=content{1}{i};    
       
        if ~isempty(strfind(line, '$END'))
              ln=i;
        end
        
        if ~isempty(strfind(line, 'Sweep'))
              st1 = textscan(line, '%s', 'delimiter', ' ');
              info.SW = str2double(st1{1}{end-1});
        end
        
        if ~isempty(strfind(line, 'Vector'))
              st2 = textscan(line, '%s', 'delimiter', ' ');
              info.samples = str2double(st2{1}{end-1});
        end
        
        if ~isempty(strfind(line, 'Field'))
              st3 = textscan(line, '%s', 'delimiter', ' ');
              info.B0 = str2double(st3{1}{end-1});
        end
        
        if i>ln 
            str_temp = textscan(line, '%s', 'delimiter', ' ');
            FID(i-ln)=str2double(str_temp{1}{1})+1i.*str2double(str_temp{1}{end});    
        end
    end
   
    
end

