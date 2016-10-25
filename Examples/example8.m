% EXAMPLE8 illustrates how to use MRS_MRI_libs to create .RAW file for   
% macromoledule spectrum, and create .in script file for making basis set 
% (.basis) in LCmodel.     
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.

%% create .raw file from .txt (output data file from iRMUI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE 1: create basis .RAW file from .txt file which contains a basis 
% spectrum simulated in jMRUI using NMRscope tool.   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ref=mrs_readJmruiTXT('Ref.txt');  % Ref.txt contains a reference signal at 0 ppm (simulated in jMRUI-NMRscope)
ref=mrs_apod(ref,4000,3);
ref=fft(ref);

data=mrs_readJmruiTXT('GABA.txt'); % GABA.txt contains basis spetrum of GABA (simulated in jMRUI-NMRscope)
data=mrs_apod(data,4000,3);
data=fft(data);

data=mrs_rephase(data,pi);
data=data+ref;

p= size(data,1);    % number of points simulated for basis spectrum [please update the value here!]
sw=4000;            % sweep width of the basis spectrum simulated   [please update the value here!]
water_ppm=4.65;     % chemical shift of water resonance    
B0=298.032*10^6;    % B0 used in simulating the basis spectrum      [please update the value here!] 
s=mrs_points2ppm( p, p, sw, B0);
n=round(p/2*water_ppm/s); % number of points to shift to make water resonance as the central frequency

data=fliplr(data');
data=circshift(data',n);

figure
plot(real(data))

% template.RAW file is a .RAW file to provide the RAW file structure (recognised by LCmodel) to
% generate the output .RAW file for a new basis spectrum (e.g. for GABA here)  
mrs_writeLcmodelBasisRAW('template.RAW','GABA.RAW',data');  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE2: create basis .RAW file from .txt file which contains a metabolite basis 
% spectrum measured from a phantom or a macromolecule (MM) spectrum measured in vivo  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
clc

ref=mrs_readLcmodelBasisRAW('Ref.RAW'); % Ref.RAW contains a reference signal at 0 ppm (simulated from VESPA)
ref=fft(ref);

MM=mrs_readJmruiTXT('MM.txt'); % MM.RAW contains a basis macromolecule spectrum measured in vivo
MM=fft(MM);
MM=fliplr(MM');
MM=MM*1000;
MM=MM+ref;

mrs_writeLcmodelBasisRAW('template.RAW','MM.RAW',MM);



%% create .in file for making basis
clear
clc

% The list of filenames of your .RAW files to be combined into one basis set  
metabo_list={'Ala','Asp','Cho','Cr','GABA','Glc','Gln','Glu','Gly','GPC','GSH',...
    'Lac','mI','NAA','NAAG','PCho','PCr','PE','sI','Tau','MM'};

makebasis_file='STEAM_TE17_TM17_mm'; % Name for your .in file   

info.raw_dir='/home/chen/.lcmodel/STEAM_TE17_TM17/'; % file path of your .RAW files 
 
info.seq='STEAM';
info.TE='17';
info.fwhmba='0.01';
info.ppmst='10.0';
info.ppmend='-0.4';
info.hzppm='298.06';
info.deltat='.00025';
info.nunfil='4096';

mrs_writeLcmodelIN(makebasis_file,info,metabo_list);
 
% Once this .in file was generated, you can use lcmodel command:  
% >> makebasis < STEAM_TE17_TM17_mm.in 
% to generate the .basis file  






















