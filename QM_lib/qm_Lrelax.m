function  Pt = qm_Lrelax( P, B, T1, t )
% QM_LRELAX returns longitudinal relaxation spin density operator   
%
% ARGS :
% P= rho, spin density operator
% B = Boltzmann factor
% T1 = longitudinal relaxation time  (s)
% t= time (s)
%
% RETURNS:
% Pt = spin density operator after transverse relaxation
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
   
    Peq = qm_Peq1( B );
    Peqa = Peq(1,1);
    Peqb = Peq(2,2);
    
    Pt(1,1)=(P(1,1)-Peqa)*exp(-t/T1)+Peqa;
    Pt(2,2)=(P(2,2)-Peqb)*exp(-t/T1)+Peqb;
    
    Pt(2,1)=P(2,1);
    Pt(1,2)=P(1,2);
    
end

