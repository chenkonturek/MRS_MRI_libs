function [A_peak, I_peak, peak_fitted, pars_fitted] = mrs_fitPeak( spectrum, peak_range )    
% MRS_FINDFITTEDPEAK fits a peak in the given range of a spectrum with a lorenztian 
% function by minimising the squared error
% 
% [A_peak, I_peak, peak_fitted, pars_fitted] = mrs_findFittedPeak( spectrum, peak_range )    
%
% ARGS :
% spectrum = MR spectrum
% peak_range = peak range for the target peak (in points)
% 
% RETURNS:
% A_peak = value of target peak
% I_peak = index of the target peak in the spectrum (in points)
% peak_fitted = the fitted peak
% pars_fitted = fitted values of parameters  ([y0 x0 fwhm A])
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    x=round(peak_range(1)):round(peak_range(2));
            
    peak_fitted=real(spectrum);
        
    [f,pars_fitted] = fitPeak( real(spectrum(x))', x );
    
	[A_peak,index]=max(f);
	I_peak=x(index);
 
    peak_fitted(x)=f;
end

function  [peak_fitted,pars_fitted] = fitPeak(data, x )

    [A_ini,index]=max(data);
    par_initials=[(data(1)+data(end))/2, x(index), 2.5, A_ini]; 
        
    [peak_fitted, pars_fitted] = mrs_lorentzFit(par_initials, data, x);
    
	f=figure(4);
    clf(f)
	hold on
	plot(x,data','r');
	plot(x,peak_fitted);
    plot(x,pars_fitted(1).*ones(length(x),1),'c')
    legend('real','fitted','baseline','Location','NorthEastOutside');
    pause(0.5)
end  