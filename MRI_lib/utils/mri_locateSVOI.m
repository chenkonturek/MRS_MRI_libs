function mask = mri_locateSVOI( SPAR_info, PAR_info )
% MRI_LOCATESVOI creates an mask for locating the spectroscopic voxel in axial MR images. 
% Axial MRI localiser were acquired before single voxel MRS. 
% 
% mask = mri_locateSVOI(  SPAR_info, PAR_info )
% 
% ARGS :
% SPAR_info = spectroscopy header information from .SPAR
% PAR_info = Axial MRI localiser header information from .PAR
% 
% RETURNS:
% mask = a mask for locating the spectroscopy voxel in MR images. 
%            The mask has the same size as the MR image localiser. 
%            The voxels correspoinding to spectroscopy voxel is assigned with value 1; 
%            otherwise, the voxel value is set to be 0. 
%
% EXAMPLE: 
% >> spar_info = mrs_readSPAR('sub1_MRS.SPAR');
% >> par_info = mri_readPAR('sub1_MPRAGE.PAR');
% >> voi_mask = mri_locateSVOI(spar_info, par_info);
% >> mri_data = mri_readIMG('sub1_MPRAGE.hdr');
% >> mri_dispSVOI( svoi_mask, mri_data );
%
% AUTHOR : Chen Chen, Dr. Emma Hall
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    svoi_offcentre = SPAR_info.offcentre;  % rl ap fh
    if SPAR_info.CSI==0
        svoi_size = SPAR_info.size;    % rl ap fh, mm
    else
        svoi_size = SPAR_info.FOV;    % rl ap fh, mm
    end
    svoi_ang = SPAR_info.angulation*pi/180; % rl ap fh

    mri_offcentre = [PAR_info.offCentre(3) PAR_info.offCentre(1) PAR_info.offCentre(2)];  % rl ap fh
    mri_ang = [PAR_info.angulations(3) PAR_info.angulations(1) PAR_info.angulations(2)]*pi/180;% rl ap fh
    mri_dim = PAR_info.dim(1:3);      % rl ap fh
    mri_vox = PAR_info.vox;           % rl ap fh, mm
    mri_size = mri_dim.*mri_vox;      % rl ap fh, mm

    % rotation function
    rot_rl = @(ang)[1 0 0;0 cos(ang) -sin(ang);0 sin(ang) cos(ang)];
    rot_ap = @(ang)[cos(ang) 0 sin(ang);0 1 0;-sin(ang) 0 cos(ang)];
    rot_fh = @(ang)[cos(ang) -sin(ang) 0;sin(ang) cos(ang) 0;0 0 1];

    % svoi to scanner space
    c=0;
    for x=[-1, 1]
        for y=[-1, 1]
            for z=[-1, 1]
                c=c+1;
                corner = 0.5*svoi_size.*[x y z];
                svoi_corners(c,:)=corner;
            end
        end
    end

    svoi_corners=(rot_fh(svoi_ang(3))*svoi_corners')';
    svoi_corners=(rot_ap(svoi_ang(2))*svoi_corners')';
    svoi_corners=(rot_rl(svoi_ang(1))*svoi_corners')';

    svoi_corners=svoi_corners+repmat(svoi_offcentre,8,1);

    % svoi to MRI space
    msvoi_corners=svoi_corners-repmat(mri_offcentre,8,1);
    msvoi_centre =svoi_offcentre-mri_offcentre;

    msvoi_corners=(rot_rl(-mri_ang(1))*msvoi_corners')';
    msvoi_corners=(rot_ap(-mri_ang(2))*msvoi_corners')';
    msvoi_corners=(rot_fh(-mri_ang(3))*msvoi_corners')';
    
    msvoi_centre=(rot_rl(-mri_ang(1))*msvoi_centre')';
    msvoi_centre=(rot_ap(-mri_ang(2))*msvoi_centre')';
    msvoi_centre=(rot_fh(-mri_ang(3))*msvoi_centre')';
    
    disp('* 8 corners of Spectroscopic voxel in Imaging space: ');
    disp(msvoi_corners)
    disp('* Centre of Spectroscopic voxel in Imaging space: ');
    disp(msvoi_centre)

    % create mask 
    mask=zeros(mri_dim(1),mri_dim(2),mri_dim(3));

    xs = linspace(-mri_size(1)/2, mri_size(1)/2, mri_dim(1)+1)+mri_vox(1)/2;
    ys = linspace(-mri_size(2)/2, mri_size(2)/2, mri_dim(2)+1)+mri_vox(2)/2;
    zs = linspace(-mri_size(3)/2, mri_size(3)/2, mri_dim(3)+1)+mri_vox(3)/2;
    
    for plane = 1:6 % 6 planes of Spectroscopic VOI
        if plane == 1 % -x plane
            p1 = msvoi_corners(1,:);p2 = msvoi_corners(2,:);p3 = msvoi_corners(3,:);
        elseif plane ==4 %+ x plane
            p1 = msvoi_corners(5,:);p2 = msvoi_corners(6,:);p3 = msvoi_corners(7,:);
        elseif plane == 2 %-y plane
            p1 = msvoi_corners(1,:);p2 = msvoi_corners(2,:);p3 = msvoi_corners(5,:);
        elseif plane ==5 %+y plane
            p1 = msvoi_corners(3,:);p2 = msvoi_corners(4,:);p3 = msvoi_corners(7,:);
        elseif plane ==3 %-z plane
            p1 = msvoi_corners(1,:);p2 = msvoi_corners(3,:);p3 = msvoi_corners(5,:);
        elseif plane ==6
            p1 = msvoi_corners(2,:);p2 = msvoi_corners(4,:);p3 = msvoi_corners(6,:);
        end
        
        A=cat(1,p1,p2,p3);
        b = [1; 1; 1];
        v=A\b;
        
        cv = sum(v.*msvoi_centre')-1;
        
        for x = 1:mri_dim(1)
            Px = xs(x);
            for y = 1:mri_dim(2)
                Py = ys(y);
                for z = 1:mri_dim(3)    
                    Pz = zs(z);
                
                    if  cv < 0 && (v(1)*Px+v(2)*Py+v(3)*Pz-1)<0
                        mask(x,y,z)= mask(x,y,z)+1;
                    elseif cv > 0 && (v(1)*Px+v(2)*Py+v(3)*Pz-1)>0
                        mask(x,y,z)= mask(x,y,z)+1;
                    end
                end               
            end
        end
    end
     % if centre of the MRI voxel is one the same side
     % of plane as the centre of spectroscopic VOI for all planes
    mask = mask > 5;
    
    for z = 1: mri_dim(3)
         mask(:,:,z)=fliplr(mask(:,:,z));
    end
end


  