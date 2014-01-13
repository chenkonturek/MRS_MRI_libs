function dMdt = nmr_bloch(t, M, t1, w1, t0, w0, T1, T2, M0)
% NMR_BLOCH simulates magnetisation change in rotating frame 
% according to Bloch equations     
% 
% dMdt = nmr_bloch(t, M, t1, w1, t0, w0, T1, T2, M0)
%
% ARGS :
% t = time span(s)
% M = magnetisation, ([Mx, My, Mz])
% t1 = time span for RF field, B1 (s)
% w1 = RF frequency in rotating frame (B1_eff*gamma) over time (rad/s)
% t0 = time span for static field, B0 (s)
% w0 = resonance frequency in rotating frame (B0_eff*gamma) over time (rad/s)
% M0: fully relaxed magnetisation magnitude 
% T1: longitudinal relaxation time (s)
% T2: transverse relaxation time (s)
% 
% RETURNS:
% dMdt = change of magnetisation ([dMxdt, dMydt, dMzdt])
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


    dMdt=zeros(3,1);
    
    w1 = interp1(t1,w1,t); 
    w0 = interp1(t0,w0,t);  

    dMdt(1) = w0.*M(2)-M(1)/T2;
    dMdt(2) = -w0.*M(1)+w1.*M(3)-M(2)/T2;
    dMdt(3) = -w1.*M(2)-(M(3)-M0)/T1;    
end

