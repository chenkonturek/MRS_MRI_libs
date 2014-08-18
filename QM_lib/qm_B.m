function B = qm_B( B0, T, nuclei)
% QM_B returns Boltzmann Factor 
% 
% ARGS :
% B0 = field strength
% T = temperature (celsius degree)
% nuclei = nuclei type
%
% RETURNS:
% B= Boltzmann Factor 
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
    

    % Temperatuer, Kelvin
    T=T+273.15;
    % Boltzmann constant, kgm^2/s^2/k=J/k
    kb=1.38*10^(-23);
    
    % Planck constant, kgm^2/s
    h=6.63*10^(-34);
    
    % gyromagnetic ratio, r,  rad/s/T
    switch nuclei
        case '1H'
            r=267.522*10^6;
        case '13C'
            r=67.262*10^6;
        case '31P'
            r=108.291*10^6;
    end
    
    B=h*r*B0/(2*pi)/kb/T;

end

