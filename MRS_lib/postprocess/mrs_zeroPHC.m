function [corrected_spectrum, pc_ph]= mrs_zeroPHC(spectrum)
% MRS_ZEROPHC applies automatic zero-order phase correction of a spectrum.     
% 
% [corrected_spectrum, pc_ph]= mrs_zeroPHC(spectrum, range)
%
% ARGS :
% spectrum = a spectrum after automatic zero-order phase correction 
%
% RETURNS:
% corrected_spectrum = a spectrum after automatic zero-order phase correction 
% pc_ph = the phase corrected
%
% EXAMPLE: 
% >> [spectrum_pc, ph]= mrs_zeroPHC(spectrum)
% >> figure; plot(real(spectrum_pc));
% >> disp(ph);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved. 


    n = size(spectrum,1);
    
    phs = (-180:0.1:180)/180*pi;
    phs_len = length(phs);
    
    for p = 1:phs_len
        ph = phs(p);
        pc(p) = sum(real(mrs_rephase(spectrum,ph)));
    end
            
	[~,I] = max(pc);
	pc_ph = phs(I); 
    
	corrected_spectrum = mrs_rephase(spectrum, pc_ph);
 end

