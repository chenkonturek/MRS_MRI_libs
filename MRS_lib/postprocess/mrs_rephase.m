function spectra_ph = mrs_rephase( spectra, ph )
% MRS_REPHASE rephases each spectrum.     
% 
% spectra_ph = mrs_rephase( spectra, ph )
%
% ARGS :
% spectra = spectra before rephasing    (dim=[samples,avgs,dyns])
% ph = phase correction vector, (range : [-pi, pi])
%
% RETURNS:
% spectra_ph = spectra after rephasing  (dim=[samples,avgs,dyns])
%
% EXAMPLE: 
% >> spectrum_ph = mrs_rephase( spectrum, pi/4 );
% >> figure; plot(real(spectrum));
% >> hold on; plot(real(spectrum_ph),'r');
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


    re=real(spectra);
    im=imag(spectra);

    re_new=re.*cos(ph)-im.*sin(ph);
    im_new=re.*sin(ph)+im.*cos(ph);
    spectra_ph=re_new+1i*im_new;

end

