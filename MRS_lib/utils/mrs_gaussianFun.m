function y = mrs_gaussianFun( x, y0, x0, fwhm, A  )
% MRS_GAUSSIANFUN defines the gaussian function.  
% 
% y = mrs_gaussianFun( x, y0, x0, fwhm, A  )
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

    s=fwhm/2.3548; 
    y=A./s./sqrt(2*pi).*exp(-(x-x0).^2/2/s.^2)+y0;
     
end

