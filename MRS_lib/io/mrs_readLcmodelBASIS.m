function [basis_spectra, info] = mrs_readLcmodelBASIS( fileName )
% MRS_READLCMODELBASIS reads the LCModel input .basis file which contains the basis   
% set of model metabolite spectra. 
% 
% [basis_sets, info] = mrs_readLcmodelBASIS( fileName )
%
% ARGS :
% fileName = name of LCModel input .basis file 
%
% RETURNS:
% basis_spectra = a matrix contains basis sets of all metabolite model spectra 
% info = info.sample (points in each spectrum); info.BW (spectral bandwidth);
%        info.metabolites (name list of all model metabolites), info.ishift
%        (the frequency shift of spectra in points)
% 
% EXAMPLE: 
% [basis_spectra, info] = mrs_readLcmodelBASIS('steam_te14_tm16_298mhz.basis');
% for i=1:size(basis_spectra,2)
%     figure
%     plot(real(basis_spectra(:,i)),'r'); 
%     set(gca,'XDir','reverse');
%     title(info.metabolites{i});
% end
%
% AUTHOR : Chen Chen, Emma Halls
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


    [~,~,ext]=fileparts(fileName);  
    
    if isempty(ext)==1
        fileName=[fileName,'.basis'];
    end
    
    fid=fopen(fileName,'r');
	f=textscan(fid,'%s','delimiter','\n');
	fclose(fid);
    
	no_lines=size(f{1});
    c1=0;
    c2=0;
    c3=0;
    m=0;
    l=[];
    for i=1:no_lines
        line=f{1}{i};  
        BADELT_ind = strfind(line, 'BADELT =');
        NDATAB_ind = strfind(line, 'NDATAB =');
        ISHIFT_ind = strfind(line, 'ISHIFT =');
        metabo_ind = strfind(line, 'METABO =');
         
        if c1==0
            if ~isempty(BADELT_ind)
                    str_temp = textscan(line, '%s', 'delimiter', '=');               
                    info.BW= 1/str2double(str_temp{1}{2});
                    c1=c1+1;
            end
        end
        if c2==0
            if ~isempty(NDATAB_ind)
                    str_temp = textscan(line, '%s', 'delimiter', '=');               
                    info.sample= str2double(str_temp{1}{2});
                    c2=c2+1;
            end
        end
        
        if ~isempty(ISHIFT_ind)
            c3=c3+1;
            str_temp = textscan(line, '%s', 'delimiter', '=');
            info.ishift(c3)= str2double(str_temp{1}{2});            
        end
        
        if ~isempty(metabo_ind)
                m=m+1;
                str_temp = textscan(line, '%s', 'delimiter', '='); 
                names=str_temp{1}{2};
                info.metabolites{m}= names(isletter(names)); 
                l=[l,i+5];
        end
    end   
    
     basis_spectra=zeros(info.sample,length(l));
     if ~isempty(l)        
            % each metabolite basis spectrum
            for i=1:length(l)
                fid = fopen(fileName);
                C = textscan(fid, '%f', info.sample*2, 'headerlines', l(i));
                d = reshape(C{1,1},2,[]);
                basis_spectra(:,i) = d(1,:)'+1i*d(1,:)';
                fclose(fid);           
            end
    end
	
    
end

