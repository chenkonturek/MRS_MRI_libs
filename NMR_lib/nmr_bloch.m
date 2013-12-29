function dMdt = nmr_bloch(t, M, t_b0, B0, t_b1, B1, t_w, w_rf, t_phi, phi, gamma, M0, T1, T2)
% NMR_BLOCH simulates magnetisation change according to Bloch equation    
% 
% dMdt = nmr_bloch(t, M, t_b0, B0, t_b1, B1, t_w, w_rf, t_phi, phi, gamma,M0, T1, T2)
%
% ARGS :
% t = time span(s)
% M = magnetisation, ([Mx, My, Mz])
% t_b0 = time span for static field, B0
% B0 = B0 field over time (T)
% t_b1 = time span for RF field, B1
% B1 = B1 field over time (T)
% t_w: time span for RF frequency
% w_rf: RF frequency (rad/s)   
% t_phi: time span for RF pulse phase
% phi: RF pulse phase (rad)
% gamma: gyromagnetic ratio (kHz/T)
% M0: fully relaxed magnetisation magnitude
% T1: longditudinal relaxation time (ms)
% T2: relaxation relaxation time (ms)
% 
% RETURNS:
% dMdt = change of magnetisation ([dMxdt, dMydt, dMzdt])
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    dMdt = zeros(3,1);
    
    gamma = gamma*1000*2*pi;
    T2 = T2/1000;
    T1 = T1/1000;
    
    B0 = interp1(t_b0,B0,t); 
    B1 = interp1(t_b1,B1,t); 
    w_rf = interp1(t_w,w_rf,t); 
    phi = interp1(t_phi,phi,t); 
    
    delta_w = gamma*B0-w_rf; % rad/s
    w1 = gamma*B1; % rad/s
    
    dMdt(1) = delta_w.*M(2)-w1.*sin(phi).*M(3)-M(1)/T2;
    dMdt(2) = -delta_w.*M(1)+w1.*cos(phi).*M(3)-M(2)/T2;
    dMdt(3) = w1.*sin(phi).*M(1)-w1.*cos(phi).*M(2)-(M(3)-M0)/T1;
end

