function data = mri_readREC( fileName )
% MRS_READREC read Philips MRI data file (.REC)
%
% data = mri_readREC( fileName )
%
% ARGS :
% fileName = name of data file   
% 
% RETURNS:
% data = MRI data 
%
% EXAMPLE: 
% >> data = mri_readREC('sub1.REC');
% >> size(data)
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [~, name, ext]=fileparts(fileName);    
    if isempty(ext)==1
        fileName=[fileName,'.REC'];
    end    
    
    info=mri_readPAR( [name,'.PAR'] );
    
    fid = fopen(fileName,'r');
	data=fread(fid,'uint16');
	fclose(fid);
        
    data=reshape(data,info.dim(1),info.dim(2),info.dim(3),[]);
  
end

