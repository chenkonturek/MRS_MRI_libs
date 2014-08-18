function [Ix Iy Iz Ip Im Ia Ib] = qm_iniOpt1()
%QM_INIOPT1 returns operators  
%
% RETURNS:
% Ix, Iy, Iz : angular momentum operators
% Ip, Im : shift operators 
% Ia, Ib : projection operators 
% Peq: spin density operator at thermal equilibrium 
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.

    Ix=[0 1; 1 0]/2;
    Iy=[0 1; -1 0]/2/1i;
    Iz=[1 0; 0 -1]/2;

    Ip=[0 1; 0 0];
    Im=[0 0; 1 0];
    
    Ia=[1 0; 0 0];
    Ib=[0 0; 0 1];     
    
end

