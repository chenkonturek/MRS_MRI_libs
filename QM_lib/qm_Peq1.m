function Peq = qm_Peq1( B )
% QM_PEQ1 returns Spin density operator at thermal equilibrium  
%
% ARGS :
% B = Boltzmann Factor
%
% RETURNS:
% Peq = spin density matrix at thermal equilibrium 
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
    
    Iz=[1 0; 0 -1]/2;
    Peq=qm_One(2)/2+B/2*Iz;

end

