function [svoi_ang, svoi_corners_moving] = mri_estAng( pars0, svoi_offcentre, svoi_corners_fixed, svoi_corners_moving) 
% MRI_ESTANG estimates the angulation in scanner space of a spectrosopy voxel, 
% when the coordinates of 8 corners, and voxel centre are known in scanner space.    
%
% [svoi_ang, svoi_corners_moving] = mri_estAng( pars0, svoi_offcentre, svoi_corners_fixed, svoi_corners_moving) 
% 
% ARGS :
% pars0 = initial values for angulation parameters in scanner space, e.g. [0 0 0]
% svoi_offcentre = coordinates of a spectroscopy voxel centre in scanner space 
% svoi_corners_fixed = coordinates of 8 corners of a spectroscopy voxel in scanner space 
% svoi_corners_moving = coordinates of 8 corners of a equivalent voxel with
%                       no angulation positioned in the centre of the scanner space; this voxel will be moved to match  
%                       coordinates of svoi_corners_fixed
% 
% RETURNS:
% svoi_ang = estimated spectroscopy voxel angulation 
% svoi_corners_moving = coordinates of 8 corners of a spectroscopy voxel
% after transformation with the estimated angulation parameters 
%
% EXAMPLE: 
% >> svoi_size=[2 2 2];
% >> c=0;
% >> for x=[-1, 1]
% >>     for y=[-1, 1]
% >>         for z=[-1, 1]
% >>             c=c+1;
% >>             svoi_corners_moving(c,:)= 0.5*svoi_size.*[x y z];
% >>         end
% >>     end
% >> end
% >> svoi_ang_est = mri_estAng([0 0 0], msvoi_centre, msvoi_corners, svoi_corners_moving);
%
%
% AUTHOR : Dr Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2015, University of Nottingham. All rights reserved.
     options = optimset('TolX',1e-8,'MaxFunEvals',1e8, 'MaxIter',10000);
    [svoi_ang, ~] = fminsearch(@(pars) se_fun(pars, svoi_corners_fixed, svoi_corners_moving, svoi_offcentre), pars0,options);
    
    rot_rl = @(ang)[1 0 0;0 cos(ang) -sin(ang);0 sin(ang) cos(ang)];
    rot_ap = @(ang)[cos(ang) 0 sin(ang);0 1 0;-sin(ang) 0 cos(ang)];
    rot_fh = @(ang)[cos(ang) -sin(ang) 0;sin(ang) cos(ang) 0;0 0 1];
    
    
    svoi_corners_moving=(rot_fh(svoi_ang(3))*svoi_corners_moving')';
    svoi_corners_moving=(rot_ap(svoi_ang(2))*svoi_corners_moving')';
    svoi_corners_moving=(rot_rl(svoi_ang(1))*svoi_corners_moving')';

    svoi_corners_moving=svoi_corners_moving+repmat(svoi_offcentre,8,1);
    disp('estimated corners:')
    disp(svoi_corners_moving)
end 

function se = se_fun(pars, svoi_corners_fixed, svoi_corners_moving, svoi_offcentre)
 
    lr_ang=pars(1);    
    ap_ang=pars(2);
    fh_ang=pars(3);
    
     % rotation function
    rot_rl = @(ang)[1 0 0;0 cos(ang) -sin(ang);0 sin(ang) cos(ang)];
    rot_ap = @(ang)[cos(ang) 0 sin(ang);0 1 0;-sin(ang) 0 cos(ang)];
    rot_fh = @(ang)[cos(ang) -sin(ang) 0;sin(ang) cos(ang) 0;0 0 1];
    
    
    svoi_corners_moving=(rot_fh(fh_ang)*svoi_corners_moving')';
    svoi_corners_moving=(rot_ap(ap_ang)*svoi_corners_moving')';
    svoi_corners_moving=(rot_rl(lr_ang)*svoi_corners_moving')';

    svoi_corners_moving=svoi_corners_moving+repmat(svoi_offcentre,8,1);
 
    % squared error
    se = sum(sum((svoi_corners_moving-svoi_corners_fixed).^2));
    
end
