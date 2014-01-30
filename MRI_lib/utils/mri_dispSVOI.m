function  mri_dispSVOI( svoi_mask, mri_data )
% MRI_DISPSVOI displays the spectroscopic VOI on top of axial MR images.
% 
% mri_dispSVOI( svoi_mask, mri_data )
% 
% ARGS :
% svoi_mask = a mask for locating the spectroscopy VOI in axial MR images. 
% mri_data = axial MRI data
% 
% RETURNS:
%
% EXAMPLE: 
% >> voi_mask = mri_locateSVOI( 'sub1_MRS.SPAR', 'sub1_MPRAGE.PAR' ); 
% >> mri_data = mri_readIMG('sub1_MPRAGE.hdr');
% >> mri_dispSVOI( svoi_mask, mri_data );
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

	mri_view=mri_data;
	mri_view(svoi_mask==1)=mri_data(svoi_mask==1)*3;
    
    z=size(svoi_mask,3);    
    
    ls=[];
    for i=1:z
        if sum(any(svoi_mask(:,:,i)==1))>0 
            ls=[i,ls];
        end
    end
    
    figure
    for i=min(ls):max(ls)
        %imagesc(imrotate(mri_view(:,:,i),90));
        imagesc(rot90(mri_view(:,:,i)));
        colormap gray;
        title(['slice ',num2str(i),' out of ', num2str(z)]);
        pause(0.5);
    end
end

