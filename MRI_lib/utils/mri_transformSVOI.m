function [ svoi_offcentre_est, svoi_ang_est, msvoi_corners] = mri_transformSVOI( fixedFilename, movingFilename, sparFilename, geomtform)
% MRI_TRANSFORMSVOI calculates location in scanner space of the spectroscopic voxel in the second set of images (fixed), 
% which has the same position as in the first set of images (moving). 
% 
% [ svoi_offcentre_est, svoi_ang_est, msvoi_corners] = mri_transformSVOI( fixedFilename, movingFilename, sparFilename, geomtform)
% 
% ARGS :
% fixedFilename = .img/.hdr filename (without extension) of the images registered to 
% movingFilename = .img/.hdr filename (without extension) of the images to be transformed
% sparFilename = .spar filename of spectroscopy header file 
% geomtform = 4x4 3D transformation matrix for image registration 
% 
% RETURNS:
% svoi_offcentre_est = off centre parameters of the spectroscopic voxel in scanner space   
% svoi_ang_est = angulation parameters of the spectroscopic voxel in scanner space
% msvoi_corners = coordinates of corners of the spectroscopic voxel in scanner space  
%
%
% AUTHOR : Dr Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2015, University of Nottingham. All rights reserved.

    [~, sparFilename, ~]=fileparts(sparFilename); 
    [~, movingFilename, ~]=fileparts(movingFilename); 
    [~, fixedFilename, ~]=fileparts(fixedFilename); 
    
    SPAR_info = mrs_readSPAR(sparFilename);
    PAR_info = mri_readPAR(movingFilename);    
    HDR_info = mri_readHDR(movingFilename);
    
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

    %% svoi to scanner space
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

    %% svoi to moving_MRI space
    msvoi_corners=svoi_corners-repmat(mri_offcentre,8,1);
    msvoi_centre =svoi_offcentre-mri_offcentre;

    msvoi_corners=(rot_rl(-mri_ang(1))*msvoi_corners')';
    msvoi_corners=(rot_ap(-mri_ang(2))*msvoi_corners')';
    msvoi_corners=(rot_fh(-mri_ang(3))*msvoi_corners')';
    
    msvoi_centre=(rot_rl(-mri_ang(1))*msvoi_centre')';
    msvoi_centre=(rot_ap(-mri_ang(2))*msvoi_centre')';
    msvoi_centre=(rot_fh(-mri_ang(3))*msvoi_centre')';
    
    disp('* 8 corners of Spectroscopic voxel in Moving Imaging space: ');
    disp(msvoi_corners)
    disp('* Centre of Spectroscopic voxel in Moving Imaging space: ');
    disp(msvoi_centre)
    
    %% create svoi mask in moving_MRI space 
    mask_moving = mri_createMask(mri_dim,mri_size,mri_vox, msvoi_corners, msvoi_centre, all(HDR_info.ByteOrder=='ieee-be'));
    copyfile([movingFilename,'.hdr'],'svoi_mask_moving.hdr');
    mri_writeIMG('svoi_mask_moving.img', mask_moving);

    %% svoi to fixed_MRI space      
    [msvoi_centre(1),msvoi_centre(2),msvoi_centre(3)] = transformPointsForward(geomtform,msvoi_centre(1),msvoi_centre(2),msvoi_centre(3));
    
    for i = 1:8
        [msvoi_corners(i,1),msvoi_corners(i,2),msvoi_corners(i,3)] = transformPointsForward(geomtform,msvoi_corners(i,1),msvoi_corners(i,2),msvoi_corners(i,3));
    end
   
    
    disp('* 8 corners of Spectroscopic voxel in Fixed Imaging space: ');
    disp(msvoi_corners)
    disp('* Centre of Spectroscopic voxel in Fixed Imaging space: ');
    disp(msvoi_centre)
    
    %% create svoi mask in fixed_MRI space 
    mask_fixed = mri_createMask(mri_dim,mri_size,mri_vox, msvoi_corners, msvoi_centre, all(HDR_info.ByteOrder=='ieee-be'));
    copyfile([fixedFilename,'.hdr'],'svoi_mask_fixed.hdr');
    mri_writeIMG('svoi_mask_fixed.img', mask_fixed);
    
    
    %% new svoi in scanner space 
    PAR_fixed_info = mri_readPAR(fixedFilename);   
    mri_fixed_offcentre = [PAR_fixed_info.offCentre(3) PAR_fixed_info.offCentre(1) PAR_fixed_info.offCentre(2)];  % rl ap fh
    mri_fixed_ang = [PAR_fixed_info.angulations(3) PAR_fixed_info.angulations(1) PAR_fixed_info.angulations(2)]*pi/180;% rl ap fh
    
    msvoi_corners=(rot_fh(mri_fixed_ang(3))*msvoi_corners')';
    msvoi_corners=(rot_ap(mri_fixed_ang(2))*msvoi_corners')';
    msvoi_corners=(rot_rl(mri_fixed_ang(1))*msvoi_corners')';
    
    
    msvoi_centre=(rot_fh(mri_fixed_ang(3))*msvoi_centre')';
    msvoi_centre=(rot_ap(mri_fixed_ang(2))*msvoi_centre')';
    msvoi_centre=(rot_rl(mri_fixed_ang(1))*msvoi_centre')';
       
    msvoi_corners=msvoi_corners+repmat(mri_fixed_offcentre,8,1);
    msvoi_centre =msvoi_centre+mri_fixed_offcentre;
    
    disp('* 8 corners of Spectroscopic new voxel in scanner space: ');
    disp(msvoi_corners)
    disp('* Centre of Spectroscopic new voxel in scanner space: ');
    disp(msvoi_centre)
    
    %% calculate the rotation parameters     
    c=0;
    for x=[-1, 1]
        for y=[-1, 1]
            for z=[-1, 1]
                c=c+1;
                svoi_corners_moving(c,:)= 0.5*svoi_size.*[x y z];
            end
        end
    end

    svoi_ang_est = mri_estAng(svoi_ang, msvoi_centre, msvoi_corners, svoi_corners_moving); 
    svoi_ang_est = svoi_ang_est*180/pi;
    svoi_ang_est = [svoi_ang_est(2) svoi_ang_est(1) svoi_ang_est(3)];
    
    disp('*********************************')
    disp('           Results               ')
    disp('*********************************')
    svoi_offcentre_est = [msvoi_centre(2), msvoi_centre(1), msvoi_centre(3)];  
    disp('new offcentre (AP, LR, FH): ');
    disp(svoi_offcentre_est);
   
    disp('new ang (AP, LR, FH): ');
    disp(svoi_ang_est);
    disp('*********************************')
    %% write into a text file 
    
    
    %% check 
    %    mask=mri_locateSVOI(mrs_readSPAR('new'), PAR_fixed_info, all(HDR_info.ByteOrder=='ieee-be'));
    %    copyfile([fixedFilename,'.hdr'],'svoi_mask_check.hdr');
    %    mri_writeIMG('svoi_mask_check.img', mask);
    
end
