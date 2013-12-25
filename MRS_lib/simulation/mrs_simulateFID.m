function FID = mrs_simulateFID(S_0, w, phi, T2_star, t, n)
% MRS_SIMULATEFID simulates Free Induction Decay (FID).    
% 
% FID = mrs_simulateFID(S_0, w, phi, T2_star, t, n)
%
% ARGS :
% S_0 = signal intensity at t=0
% w = resonance frequency in rotating frame (rad/s)
% phi = phase offset at t=0 (rad)
% T2_star = real transverse relaxation constant (s)
% t = time length (s)
% n = sample size (points)
%
% RETURNS:
% FID = simulated FID (signal in time domain)
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    ts=linspace(0,t,n)';
    FID=S_0.*exp(1i.*(w.*ts+phi)-ts./T2_star);
    
end

