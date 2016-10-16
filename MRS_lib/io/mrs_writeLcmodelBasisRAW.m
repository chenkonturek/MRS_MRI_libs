function mrs_writeLcmodelBasisRAW(inputFile, outputFile, spectrum)
% MRS_WRITELCMODELBASISRAW copies the format of a input .RAW file for making
% basis set, then writes the basis spectrum into this file as an outpufile.
% 
% mrs_writeLcmodelBasisRAW( inputFile, outputFile, spectrum )
%
% ARGS :
% inputFile = a basis example file (.RAW) 
% outputFile = a basis file created (.RAW) 
% spectrum = a basis spectrum to write into outputFile 
%
% 
% EXAMPLE: 
% >> mrs_writeLcmodelBasisRAW('Ala.RAW','MM.RAW', MM_spectrum);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.
    
    FID=ifft(spectrum);
    
    [~,~,ext1]=fileparts(inputFile);  
    [~,name,ext2]=fileparts(outputFile);  
    
    if isempty(ext1)==1
        inputFile=[inputFile,'.RAW'];
    end
    
    if isempty(ext2)==1
        outputFile=[outputFile,'.RAW'];
    end
    
    copyfile(inputFile,outputFile);    
    
    % find data section, which is from ln+1 to no_lines  
    fid=fopen(inputFile,'r');
    content=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    no_lines=size(content{1});
    for i=1:no_lines
        line=content{1}{i};    
       
        if ~isempty(strfind(line, '$NMID'))
            nmid_ln=i;
        end
        
        if ~isempty(strfind(line, '$END'))
            ln=i; 
            break;
        end       
    end
       
    % read in contents    
    fid=fopen(outputFile,'r');
    i=1;
    tline= fgetl(fid);
    A{i}=tline;
    while ischar(tline)
        i=i+1;
        tline=fgetl(fid);
        A{i}=tline;
    end        
    fclose(fid);
    
    % modify contents
    for i=1:length(FID)
        if real(FID(i))<0 && imag(FID(i))<0
            A{ln+i}=sprintf('   %0.6E   %0.6E',real(FID(i)),imag(FID(i)));
        elseif real(FID(i))<0
            A{ln+i}=sprintf('   %0.6E    %0.6E',real(FID(i)),imag(FID(i)));
        elseif imag(FID(i))<0
            A{ln+i}=sprintf('    %0.6E   %0.6E',real(FID(i)),imag(FID(i)));
        else
             A{ln+i}=sprintf('    %0.6E    %0.6E',real(FID(i)),imag(FID(i)));   
        end
    end
    
    A{nmid_ln} = [' $NMID ID=',name];
    
    % write to file 
    fid=fopen(outputFile,'w');
    for i=1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s',A{i});
            break
        else
            fprintf(fid,'%s\n',A{i});
        end
    end
    fclose(fid);
end

