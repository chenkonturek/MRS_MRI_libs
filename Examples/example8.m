% EXAMPLE8 illustrates how to use MRS_MRI_libs to create .RAW file for   
% macromoledule spectrum, and create .in script file for making basis set 
% (.basis) in LCmodel.     
% 
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.

%% create MM .raw file from .txt (output from jMRUI)
clear 
clc

ref=mrs_readLcmodelBasisRAW('Ref');
ref=fft(ref);

MM=mrs_readJmruiTXT('MM.txt');
MM=fft(MM);
MM=fliplr(MM');
MM=MM*1000;
MM=MM+ref;

lac=mrs_readLcmodelBasisRAW('Lac');
lac=fft(lac);

figure
plot(real(lac))
hold on 
plot(real(MM),'r')

mrs_writeLcmodelBasisRAW('Lac','MM',MM);



%% create .in file for making basis with MM
clear
clc

metabo_list={'Ala','Asp','Cho','Cr','GABA','Glc','Gln','Glu','Gly','GPC','GSH',...
    'Lac','mI','NAA','NAAG','PCho','PCr','PE','sI','Tau','MM'};

makebasis_file='STEAM_TE17_TM17_mm';

info.raw_dir='/home/chen/.lcmodel/STEAM_TE17_TM17/';

info.seq='STEAM';
info.TE='17';
info.fwhmba='0.01';
info.ppmst='10.0';
info.ppmend='-0.4';
info.hzppm='298.06';
info.deltat='.00025';
info.nunfil='4096';

mrs_writeLcmodelIN(makebasis_file,info,metabo_list);
 
