function [A_peaks, I_peaks] = mrs_findPeak( spectra, peak_range, ispositive)    
% MRS_FINDPEAK automatically locates the highest positive peak or
% lowest negative peak within the given range for each spectrum. 
% It returns the peak height and peak index.  
% 
% [A_peak, I_peak] = mrs_findPeak(spectrum, peak_range, ispositive)   
% 
% ARGS :
% spectra = MR spectra
% peak_range (optional) = peak range for finding the target peak (in points)
% ispositive (optional) = if 1, finds the highest positive peak; 
%              if 0, finds the lowest negative peak. 
% 
% RETURNS:
% A_peak = amplitude of the target peak
% I_peak = index of the target peak
%
% EXAMPLE: 
% >> [A, I] = mrs_findPeak(spectrum, [2000 2500], 1);
% >> disp(A);
% >> disp(I);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [samples avgs dyns] = size(spectra);
    
    % creat a window mask
    if nargin == 1 
       mask=ones(samples,1); 
    else        
        mask=zeros(samples,1);
        mask(peak_range(1):peak_range(2))=1;
    end

    for d=1:dyns
        for a = 1:avgs
            if nargin <3 || ispositive 
                [A_peaks(:,a,d), I_peaks(:,a,d)]=max(mask.*real(spectra(:,a,d)));
            else
                [A_peaks(:,a,d),I_peaks(:,a,d)]=min(mask.*real(spectra(:,a,d)));                
            end
        end
    end
end

 