function temperature = mrs_calTemp( water_ref_shifts,ref )
% MRS_CALTEMP calculates the temperature based on chemical shift difference
% of the water resonance and the temperature-independent reference resonance. 
% 
% temperature = mrs_calTemp( water_ref_shifts,ref)
% 
% ARGS :
% water_NAA_shifts = water-reference chemical shifts in ppm
% ref = the temperature-independent reference
% 
% RESULTS :
% temperature = temperature in celcius degree
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
   
   switch ref
       case 'NAA'
        temperature=282.0-92.2*water_ref_shifts; % water NAA shifts
        %temperature=286.9-94.*water_ref_shifts;
       case 'Cho'
        temperature=166.4-88.7*water_ref_shifts; % water Cho shifts
       case 'Cr'
        temperature=199.0-99.0*water_ref_shifts; % water Cr shifts
   end
end

