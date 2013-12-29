function Mz = mri_IRcurve(M0, T1, TIs)
% MRI_IRCURVE simulates the absolute value of inversion recovery (IR)
% curve.   
% 
% Mz = mri_IRcurve(M0, T1, TIs)
% 
% ARGS :
% M0 = fully relaxed magnetisation 
% T1 = longitudinal relaxation time (ms)
% TIs = a vector of inversion times(TIs) (ms). 
%       TI is the time period between the 180 degree inversion pulse 
%       and the 90 degree excitation pulse in an IR pulse sequence.  
% 
% RETURNS:
% Mz = a vector of absolute values of longitudinal magentisation after TIs
%
% EXAMPLE: 
% 
% >> TIs = [100 200 400 500 800 1200];
% >> Mz = mri_IRcurve(1, 1200, TIs);
% >> plot(TIs, Mz); 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    Mz = M0.*(1-2.*exp(-TIs./T1));
end