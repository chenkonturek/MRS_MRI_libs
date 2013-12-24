function fids = mrs_ifft( spectra )
% MRS_IFFT returns the inversed discrete Fourier transform (DFT) of spectra, 
% computed with a fast Fourier transform (FFT) algorithm.    
% 
% fids = mrs_ifft( spectra )
%
% ARGS :
% spectra = data before inversed Fourier transform 
%
% RETURNS:
% fids = data after inversed Fourier transform 
%
% EXAMPLE: 
% >> FIDs = mrs_ifft(spectra); 
% >> plot(FIDs)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    fids= ifft(ifftshift(spectra));
end

