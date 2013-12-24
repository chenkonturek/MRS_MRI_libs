function status = mrs_writeSDAT( fileName , spectra)
% MRS_WRITESDAT write MRS data file in Philips .SDAT format 
%
% status = mrs_writeSDAT( fileName , spectra)
%
% ARGS :
% fileName = name of data file   
% spectra = the data (dim=[sample, avgerage, dynamics]) to be written into the file
% 
% RETURNS:
% status =  1, when the operation is successful; otherwise, 0.  
%
% EXAMPLE: 
% >> mrs_writeSDAT('sub1_processed.SDAT', sub1_spect_processed);
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
    
    [~,~,ext]=fileparts(fileName);    
    if isempty(ext)==1
        fileName=[fileName,'.SDAT'];
    end
    
    fid_spectra= mrs_ifft(spectra);
    reshape_spectra=reshape( fid_spectra, 1,[]);
    data=[real(reshape_spectra);imag(reshape_spectra)];
    
    fid = fopen(fileName,'w','ieee-le');
    status=fwriteVAXG(fid,data,'float32');
    fclose(fid);                  
end
