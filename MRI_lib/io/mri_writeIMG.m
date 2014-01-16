function status = mri_writeIMG( fileName, data )
% MRI_WRITEIMG stores data in Analyze 7.5 format (.img)
% 
% status = mri_writeIMG( fileName, data )
%
% ARGS :
% fileName = name of the file to write data into 
% data = MRI data to be stored
%
% RETURNS:
% status = 0 when the close operation is successful;
%          Otherwise, it returns -1.
%
% 
% REQUIREMENT: MATLAB image processing toolbox
%
% EXAMPLE: 
% >> mri_writeIMG( 'sub1_new.img', data );
% 
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
    
    fid = fopen(fileName,'w',m);
    fwrite(fid,reshape(data,1,[]),b);
    status=fclose(fid);

end

