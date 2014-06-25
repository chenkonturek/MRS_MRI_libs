function Rx = nmr_Rx( angle )
% NMR_RX returns the roation matrix to perform rotation about x-axis anti-clockwise. 
% 
% Rx = nmr_Rx( angle )
%
% ARGS :
% angle = rotation angle
% 
% RETURNS:
% Rx = rotation matrix 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    b=angle/2;
    Rx=[cos(b) -1i*sin(b); -1i*sin(b) cos(b)];
    
end

