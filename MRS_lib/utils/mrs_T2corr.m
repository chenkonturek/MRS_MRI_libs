function S_corr = mrs_T2corr(S, T2, TE)
% MRS_T2CORR corrects for T2 relaxation effect 
% 
% S_corr = mrs_T2corr(S)
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
   
   S_corr = S*exp(-TE/T2);
end

