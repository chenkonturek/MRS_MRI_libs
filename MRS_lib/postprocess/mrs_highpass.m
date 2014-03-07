function data_hp = mrs_highpass(data, n, fc, BW) 
% MRS_HIGHPASS filters out low frequency components below specified frequency      
% 
% data_hp = mrs_highpass(data, n, fc, BW) 
%
% ARGS :
% data = data to be filtered 
% n = order of highpass digital Butterworth filter
% fc = cutoff frequency
% BW = Nyquist frequency
% 
% RETURNS:
% data_hp = highpass filtered data  
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved. 

    fnq= BW/2;  % Nyquist frequency = BW/2
    w2 = fc/fnq;
    Wn=w2;
    
    [b,a]=butter(n,Wn,'high');
    
    data_hp = filtfilt(b,a,data); % zero phase filter the data    

end

