function Peq = qm_Peq2( B )
% QM_PEQ2 returns Spin density operator at thermal equilibrium  
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
    
    Peq = [1+B 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1-B]/4; % == eye(4)/4+B/4*I1z+B/4*I2z
end

