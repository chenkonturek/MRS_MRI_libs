% EXAMPLE3 illustrates how to use MR_libs to simulate tye half-echo signal 
% acquired using PRESS and STEAM sequences.respectively.
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

clear 
clc

%% set parameters
B0 = 7;
gamma = nmr_getGamma(); % gyromagnetic ratio, kHz/T
w_rf = gamma.H1*1000*B0; % Hz
delta_w = 28; % Hz <- B0 inhomogeneous


S0_NAA = 24; 
S0_Cr = 13; 
S0_Cho = 4; 

T1_NAA = 1730;  % longitudinal relaxation time, ms
T1_Cr = 1780; 
T1_Cho = 1240; 

T2_NAA = 169; % transverse relaxation time, ms
T2_Cr = 114; 
T2_Cho = 128; 

shift_NAA = 2.01; % chemical shift, ppm
shift_Cr = 3.0; 
shift_Cho = 3.2; 

w_NAA = mrs_ppm2Hz(shift_NAA, w_rf + delta_w)*2*pi; % frequency, rad/s
w_Cr = mrs_ppm2Hz(shift_Cr, w_rf + delta_w)*2*pi; 
w_Cho = mrs_ppm2Hz(shift_Cho, w_rf + delta_w)*2*pi;  

w_ref= w_NAA; % new frequency reference, rad/s

delta_w_NAA = w_NAA - w_ref; % relative frequency, rad/s
delta_w_Cr = w_Cr - w_ref;  
delta_w_Cho = w_Cho - w_ref; 

phi_NAA = 0; % phase, rad
phi_Cr = 0; 
phi_Cho = 0; 

T2_star_NAA = nmr_calT2star(T2_NAA, delta_w/pi/2/1000 ); % T2*,  ms
T2_star_Cr = nmr_calT2star(T2_Cr, delta_w/pi/2/1000 ); 
T2_star_Cho = nmr_calT2star(T2_Cho, delta_w/pi/2/1000 ); 

%% simulate half-echo signal from STEAM sequence 
TR=2000;    % repetition time, ms
TM=17;      % mixing time, ms  
TE=144;      % echo time, ms  
BW=4000;    % Hz
n=4096;   % sample points

S_0_NAA = mrs_STEAM (S0_NAA, T1_NAA, T2_NAA, TR, TE, TM);  % S0(t_acq=0)
S_0_Cr = mrs_STEAM (S0_Cr, T1_Cr, T2_Cr, TR, TE, TM);
S_0_Cho = mrs_STEAM (S0_Cho, T1_Cho, T2_Cho, TR, TE, TM);

hEcho_NAA = mrs_simulateFID(S_0_NAA, delta_w_NAA, phi_NAA, T2_star_NAA/1000, BW, n); % half echo
hEcho_Cr = mrs_simulateFID(S_0_Cr, delta_w_Cr, phi_Cr, T2_star_Cr/1000, BW, n); 
hEcho_Cho = mrs_simulateFID(S_0_Cho, delta_w_Cho, phi_Cho, T2_star_Cho/1000, BW, n); 
noise = normrnd(0,0.05,n,1);

hEcho_steam = hEcho_NAA + hEcho_Cr + hEcho_Cho + noise;
spect_steam = mrs_fft(hEcho_steam);


%% simulate half-echo signal from PRESS sequence 
TR=2000;     % repetition time, ms
TE=144;      % echo time, ms  
TE1=20;
TE2=TE-TE1;
BW=4000;    % Hz
n=4096;   % sample points

S_0_NAA = mrs_PRESS (S0_NAA, T1_NAA, T2_NAA, TR, TE1, TE2);  % S0(t_acq=0)
S_0_Cr = mrs_PRESS (S0_Cr, T1_Cr, T2_Cr, TR, TE1, TE2);
S_0_Cho = mrs_PRESS (S0_Cho, T1_Cho, T2_Cho, TR, TE1, TE2);

hEcho_NAA = mrs_simulateFID(S_0_NAA, delta_w_NAA, phi_NAA, T2_star_NAA/1000, BW, n); % half echo
hEcho_Cr = mrs_simulateFID(S_0_Cr, delta_w_Cr, phi_Cr, T2_star_Cr/1000, BW, n); 
hEcho_Cho = mrs_simulateFID(S_0_Cho, delta_w_Cho, phi_Cho, T2_star_Cho/1000, BW, n); 
noise = normrnd(0,0.05,n,1);

hEcho_press = hEcho_NAA + hEcho_Cr + hEcho_Cho + noise;
spect_press = mrs_fft(hEcho_press);


%% plot results
figure
subplot(2,1,1)
plot(real([hEcho_steam,hEcho_press]));
xlabel('time domain (points)');
legend('STEAM','PRESS');
title('Comparison of simulated signals in time domain');
subplot(2,1,2)
mrs_plotSpectra(real([spect_steam,spect_press]),'ppm', BW, w_ref/2/pi, 2.01);
xlabel('frequency (ppm)');
legend('STEAM','PRESS');
title('Comparison of simulated signals in frequency domain');


