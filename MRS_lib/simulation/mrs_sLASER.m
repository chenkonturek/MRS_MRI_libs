function S = mrs_sLASER (S0, T1, T2, TR, TE)
% MRS_SLASER simulates the signal acquired using semiLASER sequence (two
% pairs of slice selective adiabatic refocusing pulses).    
% 
% S = mrs_sLASER (S0, T1, T2, TR, TE)
%
% ARGS :
% S0 = signal when fully relaxed
% T1 = longditudinal relaxation constant (ms)
% T2 = relaxation relaxation constant  (ms)
% TR = repetition time (ms)
% TE = echo time (ms)
%
% RETURNS:
% S = intial signal intensity of the acquired half-echo    
%
% REFERENCE: 
% S.K. KANG, B.Y. Choe, T.S. Suh and H.K. Lee, Journal of the Korean
% Physical Society. 40, 516-519(2000).
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    t1=TE/8;
    t2=TE/4;
    t3=TE/4;
    t4=TE/4;
    
    S = S0*(1-exp(-TR/T1)-2*exp(-(TR-(t1+t2))/T1)+2*exp(-(TR-t1)/T1)-2*exp(-(TR-(t1+t2+t3+t4))/T1)+2*exp(-(TR-(t1+t2+t3))/T1)).*exp(-TE/T2);
    
end