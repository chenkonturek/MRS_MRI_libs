function y = mrs_lorentzFun( x, y0, x0, fwhm, A  )
% MRS_LORENTZFUN defines the lorentzian function.  
% 
% y = mrs_lorentzFun( x, y0, x0, fwhm, A  )
%
% ARGS :
% x = input vectors 
% y0 = baseline amplitude
% x0 = location of the peak 
% fwhm = full width at half maximum
% A = height of the peak 
% 
% RETURNS:
% y = output vectors
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

     m=(x-x0)*2./fwhm;
     y= y0 + A.*(1./(1+m.^2));
     
end

