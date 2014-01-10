%%% File: blochEquation.m                                             %%%
%%% Package: RFpulse_Simulation                                       %%%
%%%                                                                   %%%
%%% Description:                                                      %%%
%%% A function for bloch equation simulation                          %%%                                            
%%%                                                                   %%%
%%% Author: Chen Chen                                                 %%%
%%% Organisation: SPMMPC, University of Nottingham                    %%%
%%% Date: March 2012                                                  %%%

function dMdt = nmr_bloch(t,M,t1,w1, t0, delta_w,tp,phi)
% t: time span, s
% M: magnetisation, column vector [Mx, My, Mz] 
% t1: time vector for effective B1 (B1_eff, align with x), s
% t0: time vector for effective B0 (B0_eff, align with z), s
% w1: B1_eff*gamma, rad/s
% delta_w: B0_eff*gamma = w_0-w_rf, rad/s

    dMdt=zeros(3,1);
    
    w1 = interp1(t1,w1,t); 
    delta_w = interp1(t0,delta_w,t); 
    phi=interp1(tp,phi,t);     

    
    dMdt(1)=delta_w.*M(2)+w1.*sin(phi).*M(3);
    dMdt(2)=-delta_w.*M(1)+w1.*cos(phi).*M(3);
    dMdt(3)=-w1.*sin(phi).*M(1)-w1.*cos(phi).*M(2);
end

