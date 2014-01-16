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
% csi_fileName = 'sub3_CSI_act';
% mri_fileName = 'sub3_MPRAGE';

csi_fileName = 'sub3_CSI_act';
mri_fileName = 'sub3_MPRAGE';


mrs_viewCSI( csi_fileName, mri_fileName );