% EXAMPLE6 illustrates how to use MR_libs to produce T1 maps.
%  
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


clear
clc

label_delay = 100;
TIs = label_delay+[0 200 400 600 800 1000 1300 1700 1900 2900];

% Simulate absolute IR curve data with random noise 
T1_true = 1000; 
M0_true = 1; 
data = abs(mri_IRcurve(M0_true, T1_true, TIs)+normrnd(0,0.05,[1 length(TIs)]));

% Estimate T1 by fitting the absolute IR curve 
ini_pars = [100,  0];
[T1_est M0_est, exitflags]= mri_absIRcurveFit(data, TIs, ini_pars);
data_fitted = abs(mri_IRcurve(M0_est, T1_est, TIs));

figure
plot(TIs, data,'*');
hold on 
plot(TIs, data_fitted,'r-*' );
legend('Real absolute IR data', 'Fitted absolute IR curve','Location','SouthEast');
xlabel('Inversion Recovery time (ms)');
ylabel('Signal Magnitude');
title({['T1_{true}=',num2str(T1_true),' ms, T1_{est}=',num2str(T1_est),' ms'];...
       ['M0_{true}=',num2str(M0_true),' ms, M0_{est}=',num2str(M0_est),' ms']});




