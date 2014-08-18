function  Pt = qm_Trelax( P, omega, T2, t )
% QM_TRELAX returns transverse relaxation spin density operator   
%
% ARGS :
% P= rho, spin density operator
% omega = offset frequency (rad-1)
% T2 = transverse relaxation time  (s)
% t= time (s)
%
% RETURNS:
% Pt = spin density operator after transverse relaxation
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
   
    Pt(1,1)=P(1,1);
    Pt(2,2)=P(2,2);
    
    Pt(2,1)=P(2,1)*exp((1i*omega-1/T2)*t);
    Pt(1,2)=P(1,2)*exp((-1i*omega-1/T2)*t);
    
end

