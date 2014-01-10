function S = mrs_PRESS (S0, T1, T2, TR, TE1, TE2)
% MRS_PRESS simulates the signal acquired using 
% Position Resolved Spectroscopy (PRESS) sequence.    
% 
% S = mrs_PRESS (S0, T1, T2, TR, TE1, TE2)
%
% ARGS :
% S0 = signal when fully relaxed
% T1 = longditudinal relaxation constant (ms)
% T2 = relaxation relaxation constant  (ms)
% TR = repetition time (ms)
% TE1 = TE-TE2, where TE is echo time (ms)
% TE2 = TE-TE1, where TE is echo time (ms)
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

    TE = TE1+TE2;
    S = S0*(1-exp(-TR/T1)-2*exp(-(TR-TE1-TE2/2)/T1)+2*exp(-(TR-TE1/2)/T1)).*exp(-TE/T2);
    
end