function [svoi_ang, svoi_corners_moving] = mri_estAng( pars0, svoi_offcentre, svoi_corners_fixed, svoi_corners_moving) 


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