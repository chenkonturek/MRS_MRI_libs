
function mask=mri_createMask(mri_dim,mri_size,mri_vox, msvoi_corners, msvoi_centre)
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

