%% Non-interating spins
clear
clc

T=25;
B0=7;

B = qm_B( B0, T, '1H');
disp('Boltzmann Factor:')
disp(B);

% starting M
disp('M0:')
disp([0 0 1])

% non-interacting spins
P0=qm_Peq1(B);
disp('P0:')
disp(P0);

% after 90degree pulse along x-axis
phi=0;
beta=90/180*pi;
P1=qm_Rot1( beta, phi )*P0*qm_Rot1( -beta, phi );
disp('P1:')
disp(P1)

M1 = qm_getM(P1, B);
disp('M1:')
disp(M1)

% after t=tau relaxation 
T1=810/1000; %s
T2=100/1000; %s
ts=(0:100:5000)/1000;
omega=0; % offset frequency
for i=1:length(ts)
    Pt = qm_Trelax( P1, omega, T2, ts(i) );
    Pt = qm_Lrelax( Pt, B, T1, ts(i) );  
    
    M(i,:) = qm_getM(Pt, B);
end

figure
plot3(M(:,1),M(:,2),M(:,3));
grid

%% Two-coupled spins
clear
clc

T=25;
B0=7;

B = qm_B( B0, T, '1H');
disp('Boltzmann Factor:')
disp(B);

%%%%% case 1: start from thermal equilibrium %%%%%%
P0=qm_Peq2(B);
disp('P0:')
disp(P0);


% after 90degree pulse along x-axis
phi=0;
beta=90/180*pi;
%disp(qm_Rot2( beta, phi ));


P1=qm_Rot2( beta, phi )*P0*qm_Rot2( -beta, phi );
disp('P1:')
disp(P1)


%%%%% case 2: start from 2I1xI2y %%%%%%








