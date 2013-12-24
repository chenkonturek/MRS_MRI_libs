function peak_range = mrs_selectPeakrange( spectra )
% MRS_SELECTPEAKRANGE allows user manually select the peak range 
% 
% peak_range = mrs_selectPeakrange( spectra )
% 
% ARGS :
% spectra = spectra for selecting the peak range 
% 
% RETURNS:
% peak_range = peak range along x axis
%
% EXAMPLE: 
% >> peak_range = mrs_selectPeakrange( spectra )
% >> disp(peak_range);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    figure 
    plot(real(spectra))
    title('Press [ENTRE] to start selection of peak range')
    zoom on;  
    input('Press [ENTRE] to start selection:')
    zoom off;

    [xs,~] = ginput(2);
    peak_range = round(xs);

end

