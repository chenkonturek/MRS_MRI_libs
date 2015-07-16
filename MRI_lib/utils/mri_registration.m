function geomtform= mri_registration( fixedFilename, movingFilename, type)
% MRI_REGISTRATION calculates the transformation matrix for registrating two 3D MR images.
% 
% geomtform = mri_registration( fixedFilename, movingFilename )
% 
% ARGS :
% fixedFilename = .img/.hdr filename (without extension) of the images registered to 
% movingFilename = .img/.hdr filename (without extension) of the images to be transformed
% type = transformation type: 'translation','rigid','similarity','affine'
% 
% RETURNS:
% geomtform = 4x4 3D transformation matrix for image registration  (AP, RL, FH)
%
% EXAMPLE: 
% >> geomtform = mri_registration('post', 'pre')
%
% AUTHOR : Dr Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2015, University of Nottingham. All rights reserved.

    disp('********* Registration in process... *********')
    
    [~, fixedFilename, ~]=fileparts(fixedFilename); 
    [~, movingFilename, ~]=fileparts(movingFilename); 
     
    fixedHeader  = mri_readHDR(fixedFilename);
    movingHeader = mri_readHDR(movingFilename);

    fixedVolume = mri_readIMG(fixedFilename);
    movingVolume = mri_readIMG(movingFilename);
    
    for z = 1:size(fixedVolume,3)
        fixedVolume(:,:,z)=imrotate(fixedVolume(:,:,z),90);
    end
    
    for z = 1:size(movingVolume,3)
        movingVolume(:,:,z)=imrotate(movingVolume(:,:,z),90);
    end

    %helperVolumeRegistration(fixedVolume,movingVolume);

    centerFixed = size(fixedVolume)/2;
    centerMoving = size(movingVolume)/2;
    figure, title('Unregistered Axial slice');
    imshowpair(movingVolume(:,:,centerMoving(3)), fixedVolume(:,:,centerFixed(3)));

    [optimizer,metric] = imregconfig('multimodal');

    Rfixed  = imref3d(size(fixedVolume),fixedHeader.PixelDimensions(1),fixedHeader.PixelDimensions(2),fixedHeader.PixelDimensions(3));
    Rmoving = imref3d(size(movingVolume),movingHeader.PixelDimensions(1),movingHeader.PixelDimensions(2),movingHeader.PixelDimensions(3));

    Rmoving.XWorldLimits;
    Rmoving.PixelExtentInWorldX;
    Rmoving.ImageExtentInWorldX;

    optimizer.InitialRadius = 0.004;
    movingRegisteredVolume = imregister(movingVolume,Rmoving, fixedVolume,Rfixed, type, optimizer, metric);


    figure, title('Axial slice of registered volume.');
    imshowpair(movingRegisteredVolume(:,:,centerFixed(3)), fixedVolume(:,:,centerFixed(3)));
    %helperVolumeRegistration(fixedVolume,movingRegisteredVolume);
    
    geomtform = imregtform(movingVolume, Rmoving, fixedVolume, Rfixed, type, optimizer, metric);

    geomtform.T
%     centerXWorld = mean(Rmoving.XWorldLimits);
%     centerYWorld = mean(Rmoving.YWorldLimits);
%     centerZWorld = mean(Rmoving.ZWorldLimits);
%     [xWorld,yWorld,zWorld] = transformPointsForward(geomtform,centerXWorld,centerYWorld,centerZWorld);
%     [r,c,p] = worldToSubscript(Rfixed,xWorld,yWorld,zWorld);


    movingRegisteredVolume = imwarp(movingVolume,Rmoving,geomtform,'bicubic','OutputView',Rfixed);


    %figure, title('Axial slice of registered volume.');
    %imshowpair(movingRegisteredVolume(:,:,centerFixed(3)), fixedVolume(:,:,centerFixed(3)));

    for z = 1:size(fixedVolume,3)
        movingRegisteredVolume(:,:,z)=imrotate(movingRegisteredVolume(:,:,z),-90);
    end
    
    copyfile([movingFilename,'.hdr'],[movingFilename,'_new.hdr']);
    mri_writeIMG([movingFilename,'_new.img'], movingRegisteredVolume);

end