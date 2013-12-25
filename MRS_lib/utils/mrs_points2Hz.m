function shifts_Hz = mrs_points2Hz( shifts_point, samples, BW )
% MRS_POINTS2HZ converts unit of chemical shift from points to Hz    
% 
% shifts_Hz = mrs_points2Hz( shifts_point, samples, BW )
% 
% ARGS :
% shifts_points = an array of chemical shifts in points 
% samples = number of points sampled for each spetrum
% BW = spectral bandwidth
%
% 
% RETURNS:
% shifts_Hz  = an array of chemical shifts in Hz 
%
% EXAMPLE: 
% >> shifts_Hz = mrs_points2Hz(shifts_points, info.samples, info.BW)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    shifts_Hz = (shifts_point -1)./(samples -1) .* BW - BW/2;
end

