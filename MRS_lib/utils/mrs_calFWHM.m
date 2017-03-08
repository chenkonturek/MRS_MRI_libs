function FWHM = mrs_calFWHM( spectrum, peak_range )
% MRS_CALFWHM calucalte full width at half maximum (FWHM) of the peak
% within the given range 
%
% FWHM = mrs_calFWHM( spectrum, peak_range )
%
% ARGS :
% spectrum = MR spectroscopy data in frequency domain 
% peak_range = range of the peak of interest 
%
% RETURNS:
% FWHM = full width at half maximum of the peak of interest (in points)
%
% EXAMPLE: 
% >> fwhm=mrs_calFWHM(spect,[1000 1200]);
% >> fwhm_Hz =mrs_points2Hz(fwhm,info.sample, info.BW)-mrs_points2Hz(0,info.sample, info.BW);
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Imaing Centre (SPMIC)
%
% Copyright (c) 2017, University of Nottingham. All rights reserved.

    x = peak_range(1):peak_range(2);
    y = real(spectrum(x));
    
    xi = peak_range(1):0.01:peak_range(2); 
    yi = interp1(x,y,xi);
    
   
    HM = max(y)/2;

     C_lower = 0;
     C_upper = 0;
     
     reached = 0; 
    
    for i=1:length(xi)
        
        if yi(i)<HM && ~reached
            C_lower=C_lower+1;
            C_upper=C_upper+1;
        end
        if yi(i)>=HM
            reached =1; 
            C_upper=C_upper+1;
        end
    end
    
    FWHM = xi(C_upper)-xi(C_lower+1);

end

