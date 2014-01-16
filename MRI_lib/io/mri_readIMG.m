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
    switch info.ByteOrder 
        case 'ieee-be'
            m='b';
        case 'ieee-le'
            m='l';
    end
    
    switch info.ImgDataType
        case 'DT_BINARY'
            b = 'ubit1';
        case 'DT_UNSIGNED_CHAR'
            b ='uint8'; 
        case 'DT_SIGNED_SHORT'
            b = 'int16';
        case 'DT_SIGNED_INT'
            b = 'int32';
        case 'DT_FLOAT'
            b = 'float32';
        case 'DT_DOUBLE'
            b = 'double';
    end  
    
    fid = fopen(fileName,'r',m);
	data=fread(fid, b);
	fclose(fid);
        
    data=reshape(data,info.Dimensions(1),info.Dimensions(2),info.Dimensions(3),[]);
    
end

