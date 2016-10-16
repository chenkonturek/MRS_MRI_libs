function mrs_writeLcmodelIN(outputFile, info, metabo_list)
% MRS_WRITELCMODELIN writes .in file for making basis (.basis), 
% which combines all the .RAW files.
% 
% mrs_writeLcmodelIN(outputFile, info, metabo_list)
%
% ARGS :
% outputFile = filename of .in file  
% info = information required for .in file, includes: 
%        info.raw_dir = directory name where .raw files stored  
%        info.seq = sequence name  
%        info.TE = sequence echo time (TE)
%        info.fwhmba = FWHM of basis peaks 
%        info.ppmst = upper limit of ppm-range  
%        info.ppmend = lower limit of ppm-range 
%        info.hzppm = Hz per ppm 
%        info.deltat = dwell time (s), i.e. 1/SW (SW: sweep width)
%        info.nunfil = number of complex data points 
% metabo_list = a list of names of .raw files to be combined  
%
% 
% EXAMPLE: 
%>> metabo_list={'Ala','Asp','Cho','Cr','GABA','Glc','Gln','Glu','Glu','GPC','GSH',...
%    'Lac','mI','NAA','NAAG','PCho','PCr','PE','sI','Tau','MM'};
%>> makebasis_file='STEAM_TE17_TM17';
%>> info.raw_dir='/home/chen/.lcmodel/STEAM_TE17_TM17/';
%>> info.seq='STEAM';
%>> info.TE='17';
%>> info.fwhmba='0.01';
%>> info.ppmst='10.0';
%>> info.ppmend='-0.4';
%>> info.hzppm='298.06';
%>> info.deltat='.00025';
%>> info.nunfil='4096';
%>> mrs_writeLcmodelIN(makebasis_file,info,metabo_list); 
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.
    
    [~,name,ext]=fileparts(outputFile);  
    
    if isempty(ext)==1
        outputFile=[outputFile,'.in'];
    end       
    
     A{1}=' $seqpar';
     A{2}=[' seq=''',info.seq,''''];
     A{3}=[' echot=',info.TE];
     A{4}=[' fwhmba=',info.fwhmba]; 
     A{5}=' $end';
     A{6}=' ';
     
     A{7}=' $nmall';
     A{8}=[' hzpppm=',info.hzppm];  
     A{9}=[' deltat=',info.deltat];  
     A{10}=[' nunfil=',info.nunfil];  
     A{11}=[' filbas=''',info.raw_dir,name,'.basis'''];
     A{12}=[' filps=''',info.raw_dir,name,'.ps'''];
     A{13}=' autosc= .false.';
     A{14}=' autoph= .false.';
     A{15}=[' ppmst=',info.ppmst];   
     A{16}=[' ppmend=',info.ppmend];   
     A{17}=[' idbasi=''',name,''''];
     A{18}=' $end';
     A{19}=' ';   
     
     for i=1:size(metabo_list,2) 
         A{19+1+10*(i-1)}=' $nmeach';
         A{19+2+10*(i-1)}=[' filraw=''',info.raw_dir,metabo_list{i},'.RAW'''];
         A{19+3+10*(i-1)}=[' metabo=''',metabo_list{i},''''];
         A{19+4+10*(i-1)}=' degzer=0.';
         A{19+5+10*(i-1)}=' degppm=0.';
         A{19+6+10*(i-1)}=' conc=100';
         A{19+7+10*(i-1)}=' concsc=100.'; 
         A{19+8+10*(i-1)}=' ppmapp=0.2, -.2';
         A{19+9+10*(i-1)}=' $end';
         A{19+10+10*(i-1)}=' ';    
     end
     n=size(A,2);
     A{n+1}=-1;
    
    % write to file 
    fid=fopen(outputFile,'w');
    for i=1:numel(A)
        if A{i+1} == -1          
            break
        end
        fprintf(fid,'%s\n',A{i});
    end
    fclose(fid);
end

