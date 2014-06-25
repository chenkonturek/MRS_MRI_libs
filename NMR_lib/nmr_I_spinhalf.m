%% a script that defines the operators & states for spin-1/2 
clear
clc

% states 
a=[1;0];% alpha
b=[0;1]; % beta

% superposition states 
Xp=[1;1]/sqrt(2);
Xm=[-1i;1i]/sqrt(2);

Yp=[1-1i;1+1i]/2;
Ym=[1+1i;1-1i]/2;

Zp=a;
Zm=b;

% angular momentum operators 
Ix=[0 1; 1 0]/2;
Iy=[0 1; -1 0]/2i;
Iz=[1 0; 0 -1]/2;

% unit operator 
one=eye(2);

% shift operators
Ip=[0 1; 0 0];  % I+
Im=[0 0; 1 0];  % I-

% projection operators
Ia=[1 0; 0 0];
Ib=[0 0; 0 1];

