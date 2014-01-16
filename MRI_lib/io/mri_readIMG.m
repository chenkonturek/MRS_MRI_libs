function data = mri_readIMG( fileName )
% MRI_READIMG reads data in Analyze 7.5 format(.img)
% 
% data = mri_readIMG( fileName )
%
% ARGS :
% fileName = name of data file in Analyze 7.5 format
%
% RETURNS:
% data = MRI data
% 
% REQUIREMENT: MATLAB image processing toolbox
%
% EXAMPLE: 
% >> data = mri_readIMG('sub1.img');
% >> size(data)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [~, name ext]=fileparts(fileName);    
    if isempty(ext)==1
        fileName=[fileName,'.img'];
    end
    
    info=mri_readHDR( [name,'.hdr'] );
    % read in
    if all(info.ByteOrder == 'ieee-be')
        m='b';
    else
        m='l';
    end
    
    if info.BitDepth==16
        b = 'int16';
    elseif info.BitDepth==32 
        b = 'float';
    end
    
    fid = fopen(fileName,'r',m);
	data=fread(fid, b);
	fclose(fid);
        
    data=reshape(data,info.Dimensions(1),info.Dimensions(2),info.Dimensions(3),[]);
    
end

