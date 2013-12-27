function svoi_mask = mri_locateSVOI( spect_fileName, mri_fileName )
% MRI_LOCATESVOI creates an mask for locating the spectroscopic voxel in axial MR images. 
% Axial MRI localiser were acquired before single voxel MRS. 
% 
% svoi_mask = mri_locateSVOI( spect_fileName, mri_fileName )
% 
% ARGS :
% spect_fileName = filename of single voxel MRS header file  (.SPAR)
% mri_fileName = filename of Axial MRI localiser header file  (.PAR)
% 
% RETURNS:
% svoi_mask = a mask for locating the spectroscopy voxel in MR images. 
%            The mask has the same size as the MR image localiser. 
%            The voxels correspoinding to spectroscopy voxel is assigned with value 1; 
%            otherwise, the voxel value is set to be 0. 
%
% EXAMPLE: 
% >> voi_mask = mri_locateSVOI( 'sub1_MRS.SPAR', 'sub1_MPRAGE.PAR' );
% >> mri_data = mri_readIMG('sub1_MPRAGE.hdr');
% >> mri_dispSVOI( svoi_mask, mri_data );
%
% AUTHOR : Dr. Emma Hall, Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

   
    % read MRS header infomation (.SPAR)
    [~, spect_fileName, ~]=fileparts(spect_fileName); 
    spect_info = mrs_readSPAR(spect_fileName); 
    box_centre = [spect_info.offcentre(2) spect_info.offcentre(1) spect_info.offcentre(3)];% rl ap fh
    
    x_size = spect_info.size(2); % rl
    y_size = spect_info.size(1); % ap
    z_size = spect_info.size(3); % fh
    
    ang_rl = spect_info.angulation(2)*pi/180; % x
    ang_ap = spect_info.angulation(1)*pi/180; % y
    ang_fh = spect_info.angulation(3)*pi/180; % z
    
    % read MRI header infomation (.PAR)
    [~, mri_fileName, ~]=fileparts(mri_fileName); 
    mri_info = mri_readPAR(mri_fileName);

    mri_box_centre = [mri_info.offCentre(3) mri_info.offCentre(1) mri_info.offCentre(2)]; % rl ap fh
    mri_ang_rl = mri_info.angulations(3)*pi/180; % x
    mri_ang_ap = mri_info.angulations(1)*pi/180; % y
    mri_ang_fh = mri_info.angulations(2)*pi/180; % z  

    imxdim = mri_info.dim(1);
    imydim = mri_info.dim(2);
    imzdim = mri_info.dim(3);
    
    vx = mri_info.vox_x;
    vy = mri_info.vox_y;
    vz = mri_info.vox_z;  
     
    
    %% Calculate the Mask
    % Define Rotation Functions
    rot_rl = @(ang)[1 0 0;0 cos(ang) -sin(ang);0 sin(ang) cos(ang)]; %eg. x
    rot_ap = @(ang)[cos(ang) 0 sin(ang);0 1 0;-sin(ang) 0 cos(ang)]; %eq. y
    rot_fh = @(ang)[cos(ang) -sin(ang) 0;sin(ang) cos(ang) 0;0 0 1]; %eq. z
    
    
    % Position and Rotate MRS Voxel
    counter=0;
    for a=[-1, 1]
        for b=[-1, 1]
            for c=[-1, 1]
                counter=counter+1;
                corner = 0.5*[x_size y_size z_size].*[a b c];
                location(counter,:)=corner;
            end
        end
    end
    
    % Rotation
    nlocation=(rot_fh(ang_fh)*location')';
    nlocation=(rot_ap(ang_ap)*nlocation')';
    nlocation=(rot_rl(ang_rl)*nlocation')';
    
    nlocation=nlocation+repmat(box_centre,8,1);
    
    % Want to rotate MRS VOI slab back to flat mri space
    nlocation=nlocation-repmat(mri_box_centre,8,1);
    
    rnlocation=(rot_rl(-mri_ang_rl)*nlocation')';
    rnlocation=(rot_ap(-mri_ang_ap)*rnlocation')';
    rnlocation=(rot_fh(-mri_ang_fh)*rnlocation')';
    
    rnlocation=rnlocation+repmat(mri_box_centre,8,1);
    
    new_box_centre = box_centre - mri_box_centre;
    new_box_centre=(rot_rl(-mri_ang_rl)*new_box_centre')';
    new_box_centre=(rot_ap(-mri_ang_ap)*new_box_centre')';
    new_box_centre=(rot_fh(-mri_ang_fh)*new_box_centre')';
    new_box_centre = new_box_centre + mri_box_centre;
    
    
    % Create Grid the Size of mri
    mask=zeros(imxdim,imydim,imzdim,6);
    
    mx=linspace(mri_box_centre(1)-vx*(imxdim/2-0.5),mri_box_centre(1)+vx*(imxdim/2-0.5),imxdim);
    my=linspace(mri_box_centre(2)-vy*(imydim/2-0.5),mri_box_centre(2)+vy*(imydim/2-0.5),imydim);
    mz=linspace(mri_box_centre(3)-vz*(imzdim/2-0.5),mri_box_centre(3)+vz*(imzdim/2-0.5),imzdim);
    
    for plane_counter=1:6
        %finding equation of planes
        if plane_counter == 1 % -x plane
            p1 = rnlocation(1,:);p2 = rnlocation(2,:);p3 = rnlocation(3,:);
        elseif plane_counter ==4 %+ x plane
            p1 = rnlocation(5,:);p2 = rnlocation(6,:);p3 = rnlocation(7,:);
        elseif plane_counter == 2 %-y plane
            p1 = rnlocation(1,:);p2 = rnlocation(2,:);p3 = rnlocation(5,:);
        elseif plane_counter ==5 %+y plane
            p1 = rnlocation(3,:);p2 = rnlocation(4,:);p3 = rnlocation(7,:);
        elseif plane_counter ==3 %-z plane
            p1 = rnlocation(1,:);p2 = rnlocation(3,:);p3 = rnlocation(5,:);
        elseif plane_counter ==6
            p1 = rnlocation(2,:);p2 = rnlocation(4,:);p3 = rnlocation(6,:);
        end
        
        A=cat(1,p1,p2,p3);
        b = [1; 1; 1];
        v=A\b; % inv(A)*B
        
        t = sum(v.*new_box_centre')-1;
        
        for x=1:imxdim
            X=mx(x);
            for y=1:imydim
                Y=my(y);
                for z=1:imzdim
                    Z=mz(z);
                    if  t < 0 && (v(1)*X+v(2)*Y+v(3)*Z-1) <0
                        mask(x,y,z,plane_counter)=1;
                    elseif t > 0 && (v(1)*X+v(2)*Y+v(3)*Z-1) >0
                        mask(x,y,z,plane_counter)=1;
                    end
                end
            end
        end
    end
    
    svoi_mask=zeros(imxdim,imydim,imzdim);
    for z=1:imzdim
        temp=sum(mask(:,:,z,:),4);
        temp=temp>5;
        temp=fliplr(temp);
        svoi_mask(:,:,z)=(temp);
    end
    
end

