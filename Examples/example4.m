% EXAMPLE4 illustrates how to use MR_libs to do Bloch Equation simulation 
%  
% 
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

%% 1) Bloch Equation Simulation : Relaxation 
clear
clc

% 3 T
T1 = 800/1000; % s
T2 = 80/1000;  % s

n = 2000;
ts = linspace(1,3000,n)/1000; % s, time line 
M0 = [0 1 0]; % initial magnetisation

w1 = zeros(1,n); % assume no RF pulse (B1_eff*gamma), rad/s
w0 = 2.*pi.*30.*ones(1,n); % assume 30Hz off resonance (B0_eff*gamma), rad/s

[Tt,Mt] = ode45(@(t,M) nmr_bloch(t, M, ts, w1, ts, w0, T1, T2, 1), ts, M0);

Tt = Tt.*1000; % ms

figure
title('Magnetisation Relaxation after Excitation')
subplot(3,1,1)
plot(Tt, Mt(:,1));
xlabel('t (ms)');
ylabel('Mx(t)');
subplot(3,1,2)
plot(Tt, Mt(:,2));
xlabel('t (ms)');
ylabel('My(t)');
subplot(3,1,3)
plot(Tt, Mt(:,3))
xlabel('t (ms)');
ylabel('Mz(t)');


figure 
plot3(Mt(:,1),Mt(:,2),Mt(:,3),'-');
xlabel('x')
ylabel('y')
zlabel('z')
grid
title('Magnetisation Relaxation after Excitation')

%% 2) Bloch Equation Simulation : Excitation (Hard pulse)
clear
clc

B0 = 3;
T1 = 800/1000; % s
T2 = 80/1000;  % s

n=2000;
B1 = 2*10^(-6); % T
rf_AM = B1.*ones(1,n); % T           
gamma = nmr_getGamma(); % kHz/T 
gamma = gamma.H1*1000*2*pi; % rad/s/T
angle=90; % flip angle, degree
rf_len = (angle/180*pi)/gamma/B1; % s

ts = linspace(0,rf_len,n); % s, time line 
M0 = [0 0 1]; % initial magnetisation

w1 = rf_AM.*gamma;% rf_AM.*gamma; % rad/s
w0 = zeros(1,n); % on resonance (B0_eff*gamma), rad/s

[Tt,Mt] = ode45(@(t,M) nmr_bloch(t, M, ts, w1, ts, w0, T1, T2, 1), ts, M0);

Tt = Tt.*1000; % ms

figure
subplot(3,1,1)
plot(Tt, Mt(:,1));
xlabel('t (ms)');
ylabel('Mx(t)');
title('Magnetisation Excitation (90_{x}^{\circ} degree hard pulse)')
subplot(3,1,2)
plot(Tt, Mt(:,2));
xlabel('t (s)');
ylabel('My(t)');
subplot(3,1,3)
plot(Tt, Mt(:,3))
xlabel('t (ms)');
ylabel('Mz(t)');


figure 
plot3(Mt(:,1),Mt(:,2),Mt(:,3),'-');
xlabel('x')
ylabel('y')
zlabel('z')
grid
title('Magnetisation Excitation (90_{x}^{\circ} degree hard pulse)')

