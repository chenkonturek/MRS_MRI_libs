function S_corr = mrs_gaba_corr(S)
% MRS_GABA_CORR corrects GABA signal(3ppm) in DIFF spectrum acquired from 
% sepectral-editing sequence for for the J-evolution fully-refocused signal 
% of C4-GABA.  
% 
% S_corr = mrs_gaba_corr(S) 
% 
% ARGS :
% S = C4-GABA signal in DIFF (Edit_ON-Edit_OFF) spectrum 
% 
% RESULTS :
% S_corr = corrected for the J-evolution fully-refocused signal of C4-GABA 
%          , S*(2*S_ON/S_DIFF)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
   
   S_corr = 2*S*1.0443;
end

