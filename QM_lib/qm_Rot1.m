function R = qm_Rot1( beta, phi )
% QM_ROT1 returns rotation operator   
% 
% ARGS :
% beta = flip angle (rad)
% phi = phase: when phi=0, rotate about x-axis; when phi=pi/2, rotate about
% y-axis
%
% RETURNS:
% R = rotation matrix
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
    
    R=[cos(beta/2), -1i*sin(beta/2)*exp(-1i*phi); -1i*sin(beta/2)*exp(1i*phi), cos(beta/2)];

end

