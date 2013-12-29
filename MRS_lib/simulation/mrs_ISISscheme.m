function  mrs_ISISscheme( dim )
% MRS_ISIS demonstrates how Image Selective in vivo Spectroscopy (ISIS) works 
% as a localisation method. 
% 
% mrs_ISISscheme (dim)
%
% ARGS :
% dim = dimensions 
%
% RETURNS:
% 
% REFERENCE: 
% R.A. de Graaf, In vivo NMR Spectroscopy - 2nd Edition: Principles and Techniques. 
% John Wiley & Sons, Ltd (2007). 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
 
    % 1: positive signal, -1: negative signal
    switch dim
        case 1  
            disp('for 1D ISIS localisation(VOI=slice), 2 FIDs are acquired ')
            % FID1: 90 
            m = [1 1 1; 1 1 1; 1 1 1]; 
            m1(:,:,1) = m;
            m1(:,:,2) = m;
            m1(:,:,3) = m;
            
            % FID2: 180(x gradient) - 90
            m = [1 -1 1; 1 -1 1; 1 -1 1];
            m2(:,:,1) = m;
            m2(:,:,2) = m;
            m2(:,:,3) = m;
            
            ms = m1-m2;
            disp('FID1-FID2 =')
            disp(ms)
            
        case 2  
            disp('for 2D ISIS localisation(VOI=bar), 4 FIDs are acquired ')
            % FID1: 90 
            m = [1 1 1; 1 1 1; 1 1 1]; 
            m1(:,:,1) = m;
            m1(:,:,2) = m;
            m1(:,:,3) = m;
            
            % FID2: 180(x gradient) - 90
            m = [1 -1 1; 1 -1 1; 1 -1 1];
            m2(:,:,1) = m;
            m2(:,:,2) = m;
            m2(:,:,3) = m;
            
            % FID3: 180(y gradient) - 90
            m = [1 1 1; -1 -1 -1; 1 1 1];
            m3(:,:,1) = m;
            m3(:,:,2) = m;
            m3(:,:,3) = m;
            
            % FID4: 180(x gradient) - 180(y gradient)- 90
            m = [1 -1 1; -1 1 -1; 1 -1 1];
            m4(:,:,1) = m;
            m4(:,:,2) = m;
            m4(:,:,3) = m;
            
            ms=m1-m2-m3+m4;
            disp('FID1-FID2-FID3+FID4 =')
            disp(ms)
            
        case 3 
            disp('for 3D ISIS localisation(VOI=voxel), 8 FIDs are acquired ')
            % FID1: 90 
            m = [1 1 1; 1 1 1; 1 1 1]; 
            m1(:,:,1) = m;
            m1(:,:,2) = m;
            m1(:,:,3) = m;
            
            % FID2: 180(z gradient) - 90
            m = [1 1 1; 1 1 1; 1 1 1];
            m2(:,:,1) = m;
            m2(:,:,2) = -m;
            m2(:,:,3) = m;           
            
            % FID3: 180(y gradient) - 90
            m = [1 1 1; -1 -1 -1; 1 1 1];
            m3(:,:,1) = m;
            m3(:,:,2) = m;
            m3(:,:,3) = m;
            
            % FID4: 180(x gradient) - 90
            m = [1 -1 1; 1 -1 1; 1 -1 1];
            m4(:,:,1) = m;
            m4(:,:,2) = m;
            m4(:,:,3) = m;
            
            % FID5: 180(z gradient) - 180(y gradient)- 90
            m = [1 1 1; -1 -1 -1; 1 1 1];
            m5(:,:,1) =  m;
            m5(:,:,2) =  -m;
            m5(:,:,3) =  m;
            
            % FID6: 180(z gradient) - 180(x gradient)- 90
            m = [1 -1 1; 1 -1 1; 1 -1 1];
            m6(:,:,1) =  m;
            m6(:,:,2) =  -m;
            m6(:,:,3) =  m;
            
            % FID7: 180(x gradient) - 180(y gradient)- 90
            m = [1 -1 1; -1 1 -1; 1 -1 1];
            m7(:,:,1) = m;
            m7(:,:,2) = m;
            m7(:,:,3) = m;
            
            % FID8: 180(x gradient) - 180(y gradient) - 180(z gradient)- 90
            m = [1 -1 1; -1 1 -1; 1 -1 1];
            m8(:,:,1) = m;
            m8(:,:,2) = -m;
            m8(:,:,3) = m;
            
            ms=m1-m2-m3-m4+m5+m6+m7-m8;
            disp('FID1-FID2-FID3-FID4+FID5+FID6+FID7-FID8 =')
            disp(ms)
    end

end

