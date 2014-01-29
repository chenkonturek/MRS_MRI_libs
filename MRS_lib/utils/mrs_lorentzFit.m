function  [y_fitted, pars_fitted]= mrs_lorentzFit(pars0, data, x)
% MRS_LORENTZFIT fits data with a lorenztian function by minimising the squared error
% 
% [y_fitted, pars_fitted]= mrs_lorentzFit(pars0,data, x)
%
% ARGS :
% pars0 = initial values of parameters to be estimated ([y0 x0 fwhm A])
% data = data to be fitted with a lorentzian function
% x = input vectors
% 
% RETURNS:
% y_fitted = the fitted lorentzian function
% pars_fitted = fitted values of parameters  ([y0 x0 fwhm A])
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    %options = optimset('TolX',1e-8,'MaxFunEvals',1e8, 'MaxIter',1e8);
    options = optimset('TolX',1e-8,'MaxFunEvals',1e8, 'MaxIter',10000);
    [pars_fitted, ~] = fminsearch(@(pars) se_fun(pars, data, x), pars0,options);
    y_fitted = mrs_lorentzFun( x, pars_fitted(1), pars_fitted(2), pars_fitted(3), pars_fitted(4));
end

function se = se_fun(pars,data, x)
% SE_FUN defines the objective function to be minimised 
% ARGS :
% pars = parameters to be estimated ([y0 x0 fwhm A])
% data = data to be fitted with a lorentzian function
% x = input vectors
%
% RETURNS :
% se = squared error
 
    y0=pars(1);   % height of baseline 
    x0=pars(2);   % location of the peak 
    fwhm=pars(3); % full width at half maximum
    A=pars(4);    % height of the peak 
    
    % lorentzian model
    est_peak= mrs_lorentzFun( x, y0, x0, fwhm, A );
    
    % squared error
    se = sum((est_peak-data).^2);
end