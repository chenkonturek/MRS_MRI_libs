function [aligned_spectra, I_peak] = mrs_realign( spectra, peak_range, BW, LB)
% MRS_REALIGN aligns the highest peaks within a given peak range in the spectra.
% For noisy peaks, apodization is applied before peak alignment. 
% 
% [aligned_spectra, I_peak] = mrs_realign( spectra, peak_range, BW, LB)
%
% ARGS :
% spectra = spectra before peak alignment     
% peak_range (optional) = peak range for the target peak for alignment (in points) 
% BW (optional) = spectral bandwidth (Hz), for apodization
% LB (optional) = the FWHM of the exponential filter (Hz), for apodization
%
% RETURNS:
% aligned_spectra = spectra after peak alignment  
% I_peak = index of the aligned peak after alignement
%
% EXAMPLE: 
% >> [aligned_spectra, I_peak] = mrs_realign(spectra)
% >> figure; plot(real(aligned_spectra))
% >> disp(I_peak)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [samples avgs dyns]=size(spectra);
    
    if nargin == 1  
        peak_range = [1 samples]; 
    end

    if nargin>2 && LB ~=0
        % apodization
        spectra_LB = mrs_fft(mrs_apod(mrs_ifft(spectra), BW, LB));
    else
        spectra_LB=spectra;
    end

    % creat a window mask
    mask=zeros(samples,1);
    mask(peak_range(1):peak_range(2))=1;

    aligned_spectra=zeros(samples,avgs,dyns);

    [amp_max,I_max]=max(mask.*real(spectra_LB(:,1,1)));
    [amp_min,I_min]=min(mask.*real(spectra_LB(:,1,1)));
    
    if abs(amp_min)<abs(amp_max)
        I_peak=I_max;
        for d=1:dyns
            for a=1:avgs;
                [~,Ia]=max(mask.*real(spectra_LB(:,a,d)));
                aligned_spectra(:,a,d)=circshift(spectra(:,a,d),[-(Ia-I_peak),0]);
            end
        end
    else
        I_peak=I_min;
         for d=1:dyns
            for a=1:avgs;
                [~,Ia]=min(mask.*real(spectra_LB(:,a,d)));
                aligned_spectra(:,a,d)=circshift(spectra(:,a,d),[-(Ia-I_peak),0]);
            end
        end
    end

    
end

