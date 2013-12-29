function [T1 M0 exitflag]= mri_absIRcurveFit(data, TIs, par_initials)
% MRI_ABSIRCURVEFIT fits the data collected from Inversion Recovery(IR) experiments
% with varying inversion times (TIs) to the absolute IR curve, for esimating  
% the value of longitudinal relaxation time (T1) and fully relaxed magnetisation (M0). 
% 
% [T1 M0 exitflag]= mri_absIRcurveFit(data, TIs, par_initials)
% 
% ARGS :
% data = the measured absolute values of longitudinal magentisation after varying TIs
% TIs = a vector of inversion times(TIs) (ms). 
%       TI is the time period between the 180 degree inversion pulse 
%       and the 90 degree excitation pulse in an IR pulse sequence.  
% par_initials = initial values of parameters to be estimated, [T1, M0].
% 
% RETURNS:
% M0 = fitted fully relaxed magnetisation 
% T1 = fitted longitudinal relaxation time (ms)
% exitflag = a flag that describes the exit condition of fminsearch
%
% EXAMPLE: 
% >> data = mrs_readIMG('sub1_T1maps.hdr');
% >> TIs = [100 200 400 500 800 1200];
% >> [T1_fitted M0_fitted exitflag]= mri_absIRcurveFit(data(1,1,1,:), TIs, [500 1e04]);
% >> disp(T1_fitted);
% >> disp(M0_fitted);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
   
    % The fitting algorithm used is to minimise the squared error.  
    options = optimset('Display','off');
    [pars_fitted, ~, exitflag]=fminsearch(@(pars) sefun(pars, data, TIs), par_initials, options);
    
    T1 = pars_fitted(1);  
    M0 = pars_fitted(2); 
    
end

function fit_se = sefun(pars, data, TIs)
% SEFUN calculates the squared errors

    T1 = pars(1);
    M0 = pars(2);
    
    if T1<0 || T1>5000 || M0<0
        fit_se = 2^2000;
    else  
        Mz = abs(mri_IRcurve(M0, T1, TIs)); % absolute IR curve
        fit_se = sum((Mz-data).^2); 
    end
    
end



