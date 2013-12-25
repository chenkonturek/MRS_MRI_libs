function shifts_ppm = mrs_points2ppm( shifts_points, samples, BW, transmit_freq)
% MRS_POINTS2PPM converts unit of chemical shift from points to ppm    
% 
% shifts_ppm = mrs_points2ppm(shifts_points, samples, BW, transmit_freq)
% 
% ARGS :
% shifts_points = an array of chemical shifts in points 
% samples = number of points sampled for each spetrum
% BW = spectral bandwidth
% transmit_freq = synthesizer frequency
% 
% RETURNS:
% shifts_ppm  = an array of chemical shifts in ppm 
%
% EXAMPLE: 
% >> shifts_ppm = mrs_points2ppm(shifts_points, info.samples, info.BW, info.transmit_frequency)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    shifts_ppm =  mrs_points2Hz(shifts_points, samples, BW)./transmit_freq.*10^6;
end

