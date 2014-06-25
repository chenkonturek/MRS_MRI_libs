function Rz = nmr_Rz( angle )
% NMR_RZ returns the roation matrix to perform rotation about z-axis anti-clockwise. 
% 
% Rz = nmr_Rz( angle )
%
% ARGS :
% angle = rotation angle
% 
% RETURNS:
% Rz = rotation matrix 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    b=angle/2;
    Rz=[exp(-1i*b) 0; 0 exp(1i*b)];
    
end

