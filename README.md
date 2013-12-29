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
  * **mrs_PRESS.m**      : signal acquired using 
  * **mrs_STEAM.m**      :  
  * **mrs_ISISscheme.m** : 
  * **mrs_simulateFID.m**: 
* 


**MRI_lib** contains functions for post-processing, analysing and simulating Magnetic Resonance Imaging data
* file1
