function [gamma_kHzpT gamma_radpspT] = nmr_getGamma()
% NMR_GAMMA returns Gyromagnetic ratio of common nuclei.    
% 
% [gamma_kHzpT gamma_radpspT] = nmr_getGamma()
%
% ARGS :
% 
% RETURNS:
% gamma_kHzpT = gyromagnetic ratios in kHz/T
% gamma_radpspT = gyromagnetic ratios in rad/s/T
%
% EXAMPLE: 
% >> [g1 g2] = nmr_getGamma();
% >> disp(g1);
% >> disp(g2);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    gamma_kHzpT.H1 = 42576;
    gamma_kHzpT.H2 = 6536;
    gamma_kHzpT.He3 = -32434;
    gamma_kHzpT.Li7 = 16546;
    gamma_kHzpT.C13 = 10705;
    gamma_kHzpT.N14 = 3077;
    gamma_kHzpT.N15 = -4316;
    gamma_kHzpT.O17 = -5772;
    gamma_kHzpT.F19 = 40053;
    gamma_kHzpT.Na23 = 11262;
    gamma_kHzpT.P31 = 17235;
    gamma_kHzpT.Xe129 = -11777;
    
    gamma_radpspT.H1 = gamma_kHzpT.H1 *1000*2*pi;
    gamma_radpspT.H2 = gamma_kHzpT.H2 *1000*2*pi;
    gamma_radpspT.He3 = gamma_kHzpT.He3 *1000*2*pi;
    gamma_radpspT.Li7 = gamma_kHzpT.Li7 *1000*2*pi;
    gamma_radpspT.C13 = gamma_kHzpT.C13 *1000*2*pi;
    gamma_radpspT.N14 = gamma_kHzpT.N14 *1000*2*pi;
    gamma_radpspT.N15 = gamma_kHzpT.N15 *1000*2*pi;
    gamma_radpspT.O17 = gamma_kHzpT.O17 *1000*2*pi;
    gamma_radpspT.F19 = gamma_kHzpT.F19 *1000*2*pi;
    gamma_radpspT.Na23 = gamma_kHzpT.Na23 *1000*2*pi;
    gamma_radpspT.P31 = gamma_kHzpT.P31 *1000*2*pi;
    gamma_radpspT.Xe129 = gamma_kHzpT.Xe129 *1000*2*pi;
    
end

