function  mrs_plotBASISspectrum( spectrum, ishift, unit, BW, transmit_freq, ref_ppm, marker)
% MRS_PLOTBASISSPECTRUM displays model spectra from a basisset  
% 
% mrs_plotBASISspectrum( spectrum, unit, BW, ishift, transmit_freq, ref_ppm, marker)
% 
% ARGS :
% spectrum = a spectrum from a BASIS set for display 
% ishift = points needs to be shifted 
% unit (optional) = unit of x-axis for display
% BW (optional)  = spectral bandwidth, Hz
% transmit_freq (optional) = synthesizer frequency, Hz/T
% ref_ppm (optional) = real chemical shift (ppm) of the reference frequency(0ppm)
% marker(optional) = choice of marker for plotting
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    samples = size(spectrum,1);
    x_ticks = 1:samples;

    if nargin >2  
        switch unit
            case 'ppm'
                x_ticks = fliplr(mrs_points2ppm(x_ticks, samples, BW, transmit_freq));
                               
       	        if nargin >=6
                    x_ticks=ref_ppm+x_ticks;
                end
            case 'Hz'
                x_ticks = fliplr(mrs_points2Hz(x_ticks, samples, BW));
        end
    end
    
    if nargin <7
        plot(x_ticks, fliplr(real(fftshift(circshift(spectrum,-ishift)))));
    else
        plot(x_ticks, fliplr(real(fftshift(circshift(spectrum,-ishift)))),marker);
    end
    set(gca,'XDir','reverse');

end
