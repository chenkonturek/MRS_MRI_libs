function T2_star = mrs_calT2star( T2, delta_f )
% MRS_CALT2STAR calculates T2*.     
% 
% T2_star = mrs_calT2star( T2, delta_f )
%
% ARGS :
% T2 = relaxation relaxation constant  (ms)
% delta_f: difference in local resonance frequency (kHz)
%
% RETURNS:
% T2_star: real transverse relaxation time (ms)
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    T2_star = 1/(1/T2 + delta_f); 

end

