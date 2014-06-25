function Ry = nmr_Ry( angle )
% NMR_RY returns the roation matrix to perform rotation about y-axis anti-clockwise. 
% 
% Ry = nmr_Ry( angle )
%
% ARGS :
% angle = rotation angle
% 
% RETURNS:
% Ry = rotation matrix 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    b=angle/2;
    Ry=[cos(b) -sin(b); sin(b) cos(b)];
    
end

