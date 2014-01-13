function T2_star = nmr_calT2star( T2, delta_w )
% NMR_CALT2STAR calculates the     
% 
% T2_star = nmr_calT2star( T2, delta_w )
%
% ARGS :
% T2 = transverse relaxation time (ms)
% delta_w = difference in local resonance frequency (kHz)
% 
% RETURNS:
% T2_star = real transverse relaxation time (ms)
%
% EXAMPLE: 
% >> T2_star = nmr_calT2star( 120, 28 )
% >> disp(T2_star);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    T2_star = 1/(1/T2 + delta_w); 

end

