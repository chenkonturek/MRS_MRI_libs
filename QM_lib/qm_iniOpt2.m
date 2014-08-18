function [Ixs Iys Izs I1x I2x I1y I2y I1z I2z] = qm_iniOpt2()
%QM_INIOPT2 returns operators  
%
% RETURNS:
% Ixs, Iys, Izs : angular momentum operators for two coupled spin system
% I1x I2x I1y I2y I1z I2z : angular momentum operators for two coupled spin
% system
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.

    [Ix Iy Iz] = qm_iniOpt1();
    
    
    I1x=2*qm_Dprod(Ix,qm_One(2)/2); 
    I2x=2*qm_Dprod(qm_One(2)/2,Ix);
    
    I1y=2*qm_Dprod(Iy,qm_One(2)/2); 
    I2y=2*qm_Dprod(qm_One(2)/2,Iy);
 
    I1z=2*qm_Dprod(Iz,qm_One(2)/2);   
    I2z=2*qm_Dprod(qm_One(2)/2,Iz);
    
    Ixs=I1x+I2x;
    Iys=I1y+I2y;
    Izs=I1z+I2z; 
    
    
    
end

