% EXAMPLE7 illustrates how to use MR_libs to view chemical shift imaging data.
%  
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

clear
clc

% CSI and MPRAGE has same angulation & offcentre parameters
csi_fileName = 'sub3_CSI_act';
mri_fileName = 'sub3_MPRAGE';

csi_info = mrs_readSPAR(csi_fileName);
csi_data = mrs_readSDAT(csi_fileName); % time domain data

for x = 1:size(csi_data,2)
    for y = 1:size(csi_data,3)
        csi_data(:,x,y)=mrs_fft(csi_data(:,x,y)); % spectra
    end
end
    
mrs_viewCSI(csi_info, csi_data, mri_fileName);