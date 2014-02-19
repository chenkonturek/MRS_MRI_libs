function [ spectrum_ph, phc0, phc1, ph ]= mrs_firstPHC ( spectrum )
% MRS_FIRSTPHC applies automatic first-order phase correction of a spectrum.     
% The optimal zero-order and first-order phase corrections for a NMR spectrum  
% are determined by minimizing entropy. The objective function is constructed 
% using a Shannon-type information entropy measure.
% 
% [spectrum_ph, phc0, phc1]= mrs_firstPHC ( spectrum )
%
% ARGS :
% spectrum = a spectrum before automatic first-order phase correction 
%
% RETURNS:
% spectrum_ph = a spectrum after automatic first-order phase correction 
% phc0 = zero order phase correction parameter  (range : [-pi, pi])
% phc1 = first order phase correction parameter 
% ph = linear phase correction vector (range : [-pi, pi])
%
% EXAMPLE: 
% >> [spectrum_ph, phc0, phc1]= mrs_firstPHC ( spectrum )
% >> figure; plot(real(spectrum_ph));
% >> disp(phc0);
% >> disp(phc1);
% 
% REFERENCE: 
% L. Chen, Z.Q. Weng, L.Y. Goh and M. Garland, Journal of Magnetic Resonance. 
% 158, 164–168 (2002).
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved. 
   
    options=optimset('TolX',1e-8,'MaxFunEvals',1e8, 'MaxIter',1e8);
    phc=fminsearch(@(x) mrs_entropy(x, spectrum), [0 0], options);
    
    phc0 = phc(1);
    phc1 = phc(2);
    
    n=length(spectrum);
    ph=(phc0+phc1.*(1:n)/n); % linear phase
     
%     figure
%     hold on
%     plot(angle(spectrum));
%     plot(ph,'r');
    
    spectrum_ph=mrs_rephase(spectrum, ph);

end
function f = mrs_entropy(x,spectrum)
% Entropy is defined as the normalized derivative of the NMR spectral data
% ARGS :
% x = phc0 and phc1
% spectrum = a spectrum before automatic first-order phase correction 
% RETURNS : 
% f = entropy value (Using the first derivative)

    %initial parameters
    stepsize=1; 
    func_type=1;

    %dephase
    L=length(spectrum);
    phc0=x(1);
    phc1=x(2);
    
    % linear phase
    n=length(spectrum);
    ph=(phc0+phc1.*(1:n)/n);
    
    spectrum=real(mrs_rephase(spectrum, ph));

    % Calculation of first derivatives 
    if (func_type == 1)
        ds1 = abs((spectrum(3:L)-spectrum(1:L-2))/(stepsize*2));
    else
        ds1 = ((spectrum(3:L)-spectrum(1:L-2))/(stepsize*2)).^2;
    end  
    p1 = ds1./sum(ds1);

    %Calculation of Entropy
    [M,K]=size(p1);
    for i=1:M
        for j=1:K
            if (p1(i,j)==0)%in case of ln(0)
               p1(i,j)=1; 
            end
        end
    end
    h1  = -p1.*log(p1);
    H1  = sum(h1);
    %Calculation of penalty
    Pfun	= 0.0;
    as      = spectrum - abs(spectrum);
    sumas   = sum(sum(as));
    if (sumas < 0)
       Pfun = Pfun + sum(sum((as./2).^2));
    end
    P = 1000*Pfun;

    % The value of objective function
    f = H1+P;

end



