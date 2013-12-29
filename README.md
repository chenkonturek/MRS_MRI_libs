MR_libs
=======
### Description

These are MATLAB libraries for post-processing, analysing and simulating Magnetic Resonance Spectroscopy and Imaging (MRS &amp; MRI) data.

### Configuration

Data files & header files are required to be added to MATLAB path.  

### File List
**MRS_lib:** contains functions for post-processing, analysing and simulating Magnetic Resonance Spectroscopy data
* io/ 
  * **mrs_readSPAR.m**  : reads .SPAR MRS header file
  * **mrs_readSDAT.m**  : reads .SDAT MRS data file
  * **mrs_readLIST.m**  : reads .list MRS header file
  * **mrs_readDATA.m**  : reads .data raw MRS data file
  * **mrs_readTXT.m**   : reads .txt MRS data file from jMRUI
  * **mrs_writeSDAT.m** : writes MRS data to .SDAT file
  * **mrs_editSPAR.m**  : edits .SPAR file
* postprocess/
  * **mrs_truncate.m**  : truncates points from the end of spectra
  * **mrs_zerofill.m**  : fills zeros to the end of spectra
  * **mrs_apod.m**      : applies line-broadening filter 
  * **mrs_fft.m**       : applies fourier transformation 
  * **mrs_ifft.m**      : applies inverse fourier transformation 
  * **mrs_zeroPHC.m**   : applies automatic zero-order phase correction to a spectrum
  * **mrs_realign.m**   : aligns the target peaks in the spectra
  * **mrs_average.m**   : calculates averaged data
* simulation/  
  * **mrs_PRESS.m**      : simulates signal acquired using Position Resolved Spectroscopy (PRESS)
  * **mrs_STEAM.m**      : simulates signal acquired using Stimulated Echo Acquisition Mode (STEAM) 
  * **mrs_ISISscheme.m** : demonstrates how Image Selective in vivo Spectroscopy (ISIS) works
  * **mrs_simulateFID.m**: simulates a Free Induction Decay (FID) or Half-Echo. 
* utils/
  * **mrs_plotSpectra.m**     : displays spectra 
  * **mrs_selectPeakrange.m** : allows users to manually pick the peak range interactively
  * **mrs_findPeak.m**        : locates the highest positive peak or lowest negative peak
  * **mrs_points2Hz.m**       : converts unit from points to Hz
  * **mrs_points2ppm.m**      : converts unit from points to ppm
  * **mrs_ppm2Hz.m**          : converts unit from ppm to Hz
  
**MRI_lib** contains functions for post-processing, analysing and simulating Magnetic Resonance Imaging data
* io/
  * **mri_readHDR.m**  : reads .hdr MRI ANALYZE 7.5 header file 
  * **mri_readIMG.m**  : reads .img MRI ANALYZE 7.5 data file 
  * **mri_writeIMG.m** : writes data to .img file 
  * **mri_readPAR.m**  : reads .PAR MRI PHILIPS header file
* utils/
  * **mri_IRcurve.m**        : calculates the inversion recovery (IR) curve
  * **mri_absIRcurveFit.m**  : fits the data to absolute inversion recovery curve 
  * **mri_locateSVOI.m**     : creates a mask for locating the spectroscopic voxel in the axial MR images
  * **mri_dispSVOI.m**       : displays the spectroscopic voxel on top of the axial MR images



