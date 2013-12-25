function shift_Hz = mrs_ppm2Hz( shift_ppm , transmit_freq )
% MRS_PPM2HZ converts unit of a chemical shift from ppm to Hz    
% 
% shift_Hz = mrs_ppm2Hz(shift_ppm , transmit_freq)
% 
% ARGS :
% shift_ppm = the chemical shift between two peaks in ppm 
% transmit_freq = synthesizer frequency
% 
% RETURNS:
% shift_Hz  = the chemical shift between two peaks in Hz 
%
% EXAMPLE: 
% >> shift_ppm = 1.2; % ppm
% >> shift_Hz = mrs_ppm2Hz(shift_ppm,info.transmit_frequency)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    shift_Hz = shift_ppm*10^(-6)*transmit_freq+transmit_freq;
end

