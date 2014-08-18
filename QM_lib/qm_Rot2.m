function R = qm_Rot2( beta, phi )
% QM_ROT2 returns rotation operator for 2-coupled spin system 
% R_phi(beta)=R_1,phi(beta) (x) R_2,phi(beta)
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
    
    c=cos(beta/2);
    s=sin(beta/2);
    ep=exp(1i*phi);
    em=exp(-1i*phi);
    
    M=[c, -1i*s*em; -1i*s*ep, c];
    R=qm_Dprod(M,M);
    
    
%     R=[c^2, -1i*s*c*em, -1i*s*c*em, -s^2*em^2; ...
%        -1i*s*c*ep, c^2, -s^2, -1i*s*c*em;...
%        -1i*s*c*ep, -s^2, c^2, -1i*s*c*em;...
%        -s^2*ep^2, -1i*s*c*ep, -1i*s*c*ep, c^2];

end

