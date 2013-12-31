% EXAMPLE1 illustrates how to use MR_libs to post-process MRS data 
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


clear 
clc
% 31P MRS is acquired on 3T Philips system with surface 31P coil (P-140)
% and ISIS sequence (TR=12000ms, BW=3000Hz, sample=4096). 

% 1. read in 31P-MRS data and header information
fid = mrs_readSDAT('sub1'); 
info = mrs_readSPAR('sub1');
disp('Header information: ')
disp(info);

% 2. truncation 
fid_tc = mrs_truncate(fid,2048);

% 3. zero filling  
fid_zf = mrs_zerofill(fid_tc,2048);

% 4. Apodization
fid_apod = mrs_apod(fid_zf, info.BW, 15);

% 5. Fourier transformation (FT)
spect = mrs_fft(fid);
spect_tc = mrs_fft(fid_tc);
spect_zf = mrs_fft(fid_zf);
spect_apod = mrs_fft(fid_apod);

% 6. Phase correction 
spect_pc = mrs_zeroPHC(spect_apod);
fid_pc = mrs_ifft(spect_pc);


% Plots of FID/spectrum after each post-processing step
figure; 
subplot(5,2,1);
plot(real(fid));
ys=get(gca,'YLim'); 
axis([0 info.samples  ys]);
xlabel('time domain (in points)');
title('\bfOriginal FID', 'FontSize', 11);
subplot(5,2,2);
mrs_plotSpectra(spect, 'ppm', info.BW, info.transmit_frequency);
xlabel('frequency domain (in ppm)');
title('\bfOriginal spectrum', 'FontSize', 11);


subplot(5,2,3);
plot(real(fid_tc));
ys=get(gca,'YLim'); 
axis([0 info.samples  ys]);
xlabel('time domain (in points)')
title('\bfFID after truncation', 'FontSize', 11);
subplot(5,2,4);
mrs_plotSpectra(spect_tc, 'ppm', info.BW, info.transmit_frequency);
xlabel('frequency domain (in ppm)');
title('\bfspectrum after truncation', 'FontSize', 11);

subplot(5,2,5);
plot(real(fid_zf));
ys=get(gca,'YLim'); 
axis([0 info.samples  ys]);
xlabel('time domain (in points)')
title('\bfFID after zero filling', 'FontSize', 11);
subplot(5,2,6);
mrs_plotSpectra(spect_zf, 'ppm', info.BW, info.transmit_frequency);
xlabel('frequency domain (in ppm)');
title('\bfspectrum after zero filling', 'FontSize', 11);

subplot(5,2,7);
plot(real(fid_apod));
ys=get(gca,'YLim'); 
axis([0 info.samples  ys]);
xlabel('time domain (in points)')
title('\bfFID after apodization', 'FontSize', 11);
subplot(5,2,8);
mrs_plotSpectra(spect_apod, 'ppm', info.BW, info.transmit_frequency);
xlabel('frequency domain (in ppm)');
title('\bfspectrum after apodization', 'FontSize', 11);

subplot(5,2,9);
plot(real(fid_pc));
ys=get(gca,'YLim'); 
axis([0 info.samples  ys]);
xlabel('time domain (in points)')
title('\bfFID after phase correction', 'FontSize', 11);
subplot(5,2,10);
mrs_plotSpectra(spect_pc, 'ppm', info.BW, info.transmit_frequency);
xlabel('frequency domain (in ppm)');
title('\bfspectrum after phase correction', 'FontSize', 11);

