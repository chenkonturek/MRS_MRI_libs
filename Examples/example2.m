% EXAMPLE2 illustrates how to use MR_libs to post-process MRS data 
% & locates the spectroscopic voxel in the axial MR images.  
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

clear 
clc

% MRPAGE is acquired before single-voxel MRS data for localising the voxel
% of interest. MRS is acquired using STEAM sequence (TR/TM/TE=2000/17/16ms   
% BW=4000Hz, sample=4096, 2 dynamics, phase cycle=8) at 7T Philips system.  

%% post-process
% read in 1H raw .DATA MRS data and .SPAR header information
fids = mrs_readDATA('sub2_MRS'); 
disp('Data size: ')
disp(size(fids));
mrs_info = mrs_readSPAR('sub2_MRS');
disp('MRS Header information: ')
disp(mrs_info)

% average over all the FIDs in each dynamic
fids_avg = mrs_average(fids,272);

% FT
spects_avg = mrs_fft(fids_avg);

% phase correction
for i = 1:size(spects_avg,2)
    spects_pc(:,i) = mrs_zeroPHC(spects_avg(:,i));
end

% Plots of spectra
figure
subplot(2,1,1)
mrs_plotSpectra(real(spects_avg),'ppm', mrs_info.BW, mrs_info.transmit_frequency);
xlabel('frequency domain (in ppm)');
legend('dynamic 1','dynamic 2');
title('\bfwater-suppressed spectra after averaging', 'FontSize', 11);
subplot(2,1,2)
mrs_plotSpectra(real(spects_pc),'ppm', mrs_info.BW, mrs_info.transmit_frequency);
xlabel('frequency domain (in ppm)');
legend('dynamic 1','dynamic 2');
title('\bfwater-suppressed spectra after phase correction', 'FontSize', 11);


%% creates an mask for locating the spectroscopic voxel in the axial MR images
% requires MRS .SPAR and MRI .PAR files
svoi_mask = mri_locateSVOI( 'sub2_MRS', 'sub2_MPRAGE' ); 

% read in MPRAGE .img data 
mri_data = mri_readIMG('sub2_MPRAGE');

% display
mri_dispSVOI( svoi_mask, mri_data );









