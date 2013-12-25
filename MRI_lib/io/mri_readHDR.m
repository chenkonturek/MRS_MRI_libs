function  info = mri_readHDR( fileName )
% MRI_READHDR reads header information for data in Analyze 7.5 format(.hdr)
% 
% info = mri_readHDR(fileName)
%
% ARGS :
% fileName = name of header file 
%
% RETURNS:
% info = header file information
% 
% REQUIREMENT: MATLAB image processing toolbox
%
% EXAMPLE: 
% >> info = mri_readHDR('sub1.hdr');
% >> disp(info)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [~, ~, ext]=fileparts(fileName);    
	if isempty(ext)==1
        fileName=[fileName,'.hdr'];
	end
     
    info = analyze75info(fileName);

end

