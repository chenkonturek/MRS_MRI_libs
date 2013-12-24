function fids_apod = mrs_apod( fids, BW, LB )
% MRS_APOD multiplies each FID by an exponential filter (a line broadening filter)  
% to eliminate sinc ringing caused by a truncated FID. 
% 
% Exponential Filter: E(t)=exp(-pi*LB*t).  
% 
% fids_apod = mrs_apod( fids, BW, LB )
%
% ARGS :
% fids = FIDs before apodization       (dim=[samples,avgs,dyns])
% BW = spectral bandwidth   (Hz)
% LB = the FWHM of the exponential filter (Hz)
% 
% RETURNS:
% fids_apod = FIDs after apodization   (dim=[samples,avgs,dyns])
%
% EXAMPLE: 
% >> FID_apod = mrs_apod(FID, 4000, 5); 
% >> figure; plot(real(FID));
% >> hold on; plot(real(FID_apod),'r');
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [samples, avg, dyn]= size(fids);  
   
    % apodization 
    if LB~=0 
        t = 0:(1/BW):((samples-1)/BW);
        filter=exp(-pi*LB.*t);
        
        filter=repmat(filter',1,avg);
        
        for d=1:dyn
            fids_apod(:,:,d)=fids(:,:,d).*filter; 
        end
    else
        fids_apod=fids;
    end     
end

