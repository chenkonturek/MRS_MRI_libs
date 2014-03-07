function  mrs_plotSpectra( spectra, unit, BW, transmit_freq, ref_ppm, marker)
% MRS_PLOTSPECTRA displays spectra  
% 
% mrs_plotSpectra(spectra, unit, BW, transmit_freq)
% 
% ARGS :
% spectra = spectra for display 
% unit (optional) = unit of x-axis for display
% BW (optional) = spectral bandwidth, Hz
% transmit_freq (optional) = synthesizer frequency, Hz/T
% ref_ppm (optional) = real chemical shift (ppm) of the reference frequency(0ppm)
% marker(optional) = choice of marker for plotting
% 
% EXAMPLE: 
% >> info = mrs_readSPAR('sub1.SPAR'); 
% >> mrs_plotSpectra( spectra, 'ppm', info.BW, info.transmit_frequency)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [samples, ~, dyns] = size(spectra);
    x_ticks = 1:samples;

    if nargin > 1   
        switch unit
            case 'ppm'
                x_ticks = mrs_points2ppm(x_ticks, samples, BW, transmit_freq);
       	        if nargin >=5
                    x_ticks=ref_ppm+x_ticks;
                end
            case 'Hz'
                x_ticks = mrs_points2Hz(x_ticks, samples, BW);
        end
    end

    for d=1:dyns
        if dyns> 1
            figure
        end
        if nargin <6
            plot(x_ticks,real(spectra(:,:,d)))
        else
            plot(x_ticks,real(spectra(:,:,d)),marker)
        end
        set(gca,'XDir','reverse');
        
        if dyns>1
            title(['dynamic ',num2str(d)]);
        end
    end

end
