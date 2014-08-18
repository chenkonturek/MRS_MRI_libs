function M = qm_getM( P , B)
% QM_GETM returns magnetisation vector 
%
% ARGS :
% P= rho, spin density operator
% B = Boltzmann Factor
%
% RETURNS:
% M = magnetisation vector, [Mx My Mz] 
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
   
    Mx=4*real(P(2,1))/B;
    My=4*imag(P(2,1))/B;
    Mz=2*real(P(1,1)-P(2,2))/B;
    
    M=[Mx My Mz];
   
end

