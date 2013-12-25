function S = mrs_STEAM (S0, T1, T2, TR, TE, TM)
% MRS_STEAM simulates the signal acquired using 
% Stimulated Echo Acquisition Mode (STEAM) sequence.    
% 
% S = mrs_STEAM (S0, T1, T2, TR, TE, TM)
%
% ARGS :
% S0 = signal when fully relaxed
% T1 = longditudinal relaxation constant (ms)
% T2 = relaxation relaxation constant  (ms)
% TR = repetition time (ms)
% TE = echo time (ms)
% TM = mixing time (ms)
%
% RETURNS:
% S = acquired signal  
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    S = 1/2*S0.*exp(-TM/T1-TE/T2).*(1-exp((TE/2+TM-TR)/T1));

end