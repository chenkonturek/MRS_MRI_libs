function data_lp = mrs_lowpass(data, n, fc, BW) 
% MRS_LOWPASS filters out high frequency components above specified frequency      
% 
% data_lp = mrs_lowpass(data, n, fc, BW) 
%
% ARGS :
% data = data to be filtered 
% n = order of lowpass digital Butterworth filter
% fc = cutoff frequency
% BW = Nyquist frequency
% 
% RETURNS:
% data_lp = lowpass filtered data  
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved. 

    fnq= BW/2;  % Nyquist frequency = BW/2
    w2 = fc/fnq;
    Wn=w2; % normalised cutoff frequency
    
    [b,a]=butter(n,Wn,'low');
    
    data_lp = filtfilt(b,a,data); % zero phase filter the data    

end

