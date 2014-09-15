function S_corr = mrs_T1corr(S, T1, TR)
% MRS_T1CORR corrects for T2 relaxation effect 
% 
% S_corr = mrs_T1corr(S)
% 
% ARGS :
% S = signal before correction
% 
% RESULTS :
% S_corr = corrected signal
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
   
   S_corr = S*(1-exp(-TR/T1));
end

