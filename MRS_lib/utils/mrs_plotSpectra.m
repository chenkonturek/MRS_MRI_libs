function  mrs_plotSpectra( spectra, unit, BW, transmit_freq)
% MRS_PLOTSPECTRA displays spectra  
% 
% mrs_plotSpectra(spectra, unit, BW, transmit_freq)
% 
% ARGS :
% spectra = spectra for display 
% unit (optional) = unit of x-axis for display
% BW (optional) = spectral bandwidth
% transmit_freq (optional) = synthesizer frequency
% 
% RETURNS:
%
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

            case 'Hz'
                x_ticks = mrs_points2Hz(x_ticks, samples, BW);
        end
    end

    for d=1:dyns
        if dyns> 1
            figure
        end
        plot(x_ticks,real(spectra(:,:,d)))
        set(gca,'XDir','reverse');
        
        if dyns>1
            title(['dynamic ',num2str(d)]);
        end
    end

end
