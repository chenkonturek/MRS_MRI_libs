function csi_rot = mrs_rot90( csi_data )
% MRS_ROT90 rotates slices of spectra 90 degree anti-clockwise. 
% For example, each slice of the CSI data read in from .SDAT is displayed with 
% Anterior on Right side of the image, Posterior on Left side of the image,
% Left on the Top of the image, and Right on the Bottom of the image. This
% will need to be rotate 90 degree anti-clock. 
% 
% csi_rot = mrs_rot90( csi_data )
% 
% ARGS :
% csi_data = chemical shift image data to be rotated 90 degree anti-clockwise
% csi_rot =  rotated chemical shift image data
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
    [n sx sy sz] = size(csi_data);
    csi_rot=zeros(n,sy,sx,sz);
    
    for z=sz
        for x=1:sx
            for y=1:sy
                csi_rot(:,sy+1-y,x,z)=csi_data(:,x,y,z);
            end
        end
    end
end

