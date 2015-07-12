function geomtform = mri_registration( fixedFilename, movingFilename )

    disp('********* Registration in process... *********')
    
    fixedHeader  = mri_readHDR(fixedFilename);
    movingHeader = mri_readHDR(movingFilename);

    fixedVolume = mri_readIMG(fixedFilename);
    movingVolume = mri_readIMG(movingFilename);

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
    movingRegisteredVolume = imregister(movingVolume,Rmoving, fixedVolume,Rfixed, 'rigid', optimizer, metric);


    %figure, title('Axial slice of registered volume.');
    %imshowpair(movingRegisteredVolume(:,:,centerFixed(3)), fixedVolume(:,:,centerFixed(3)));
    %helperVolumeRegistration(fixedVolume,movingRegisteredVolume);
    
    geomtform = imregtform(movingVolume, Rmoving, fixedVolume, Rfixed, 'rigid', optimizer, metric);

    geomtform.T
%     centerXWorld = mean(Rmoving.XWorldLimits);
%     centerYWorld = mean(Rmoving.YWorldLimits);
%     centerZWorld = mean(Rmoving.ZWorldLimits);
%     [xWorld,yWorld,zWorld] = transformPointsForward(geomtform,centerXWorld,centerYWorld,centerZWorld);
%     [r,c,p] = worldToSubscript(Rfixed,xWorld,yWorld,zWorld);


    movingRegisteredVolume = imwarp(movingVolume,Rmoving,geomtform,'bicubic','OutputView',Rfixed);


    %figure, title('Axial slice of registered volume.');
    %imshowpair(movingRegisteredVolume(:,:,centerFixed(3)), fixedVolume(:,:,centerFixed(3)));

    copyfile([movingFilename,'.hdr'],[movingFilename,'_new.hdr']);
    mri_writeIMG([movingFilename,'_new.img'], movingRegisteredVolume);


end