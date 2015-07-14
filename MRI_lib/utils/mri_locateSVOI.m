function [mask, msvoi_centre, msvoi_corners]= mri_locateSVOI( SPAR_info, PAR_info, isBe)
% MRI_LOCATESVOI creates a mask for locating the spectroscopic VOI in MR images. 
% MRI localiser were acquired before single voxel MRS.  
% 
% mask = mri_locateSVOI(SPAR_info, PAR_info, isBe)
% 
% ARGS :
% SPAR_info = spectroscopy header information from .SPAR
% PAR_info = Axial MRI localiser header information from .PAR
% isBe = 1 if ByteOrder is 'ieee-Be', 0 if ByteOrder is 'ieee-Le'
% 
% RETURNS:
% mask = a mask for locating the spectroscopy VOI in MR images. 
%            The mask has the same size as the MR image localiser. 
%            The voxels correspoinding to spectroscopy VOI is assigned with value 1; 
%            otherwise, the voxel value is set to be 0. 
% msvoi_centre = coordinate of the centre of the spectrosopic voxel in the image space 
% msvoi_corners = coordinates of the corners of the spectrosopic voxel in the image space 
%
% EXAMPLE: 
% >> spar_info = mrs_readSPAR('sub1_MRS.SPAR');
% >> par_info = mri_readPAR('sub1_MPRAGE.PAR');
% >> voi_mask = mri_locateSVOI(spar_info, par_info);
% >> mri_data = mri_readIMG('sub1_MPRAGE.hdr');
% >> mri_dispSVOI( svoi_mask, mri_data );
%
% AUTHOR : Dr. Chen Chen, Dr. Emma Hall
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2015, University of Nottingham. All rights reserved.
    
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
    if nargin == 2
        isBe = 1;
    end
    mask = mri_createMask(mri_dim, mri_size, mri_vox, msvoi_corners, msvoi_centre, isBe);
    
end


  