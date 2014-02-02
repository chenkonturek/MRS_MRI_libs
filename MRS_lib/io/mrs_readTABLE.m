function info = mrs_readTABLE( fileName )
% MRS_READTABLE reads the important metabolites concentration from the 
% LCModel output file (.table)
%
% info = mrs_readTABLE( fileName )
%
% ARGS :
% fileName = name of LCModel ouput .table file 
%
% RETURNS:
% info = metabolite concentration information 
% 
% NOTE: info.metabolite_name=[ Concentration, SD(%), Relative Concentration]
%
% EXAMPLE: 
% >> info = mrs_readTABLE('sub1_1_1.table');
% >> disp(info)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.
    
	[~,~,ext]=fileparts(fileName);    
    if isempty(ext)==1
        fileName=[fileName,'.table'];
    end
    
    fid=fopen(fileName,'r');
    header_info=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    num_lines=size(header_info{1});
    
    info.Asp=[];
    info.NAA=[];
	info.GABA=[];
	info.Glc=[];
	info.Gln=[];
	info.Glu=[];
    info.Gly=[];
	info.GSH=[];
	info.Lac=[]; 
    info.mI_Gly=[];
    info.Glu_Gln=[];
            
	for i=1:num_lines % for each line 
        line=header_info{1}{i};
        
        has_Asp=strfind(line, 'Asp');
        has_NAA=strfind(line, 'NAA ');
        has_GABA=strfind(line, 'GABA');
        has_Glc=strfind(line, 'Glc');
        has_Gln=strfind(line, ' Gln');
        has_Glu=strfind(line, 'Glu ');
        has_Gly=strfind(line, ' Gly');
        has_GSH=strfind(line, 'GSH');
        has_Lac=strfind(line, 'Lac ');
        has_mIGly=strfind(line, 'mI+Gly');
        has_GluGln=strfind(line, 'Glu+Gln');
        
        % Asp
        if ~isempty(has_Asp)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'Asp')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.Asp=[info.Asp, val{1}];
                end                
            end
        end  
        
        % NAA
        if ~isempty(has_NAA)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'NAA')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.NAA=[info.NAA, val{1}];
                end                
            end
        end  
        
        % GABA
        if ~isempty(has_GABA)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'GABA')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.GABA=[info.GABA, val{1}];
                end                
            end
        end
        % Glc
        if ~isempty(has_Glc)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'Glc')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.Glc=[info.Glc, val{1}];
                end                
            end
        end 
        % Gln                      
        if ~isempty(has_Gln)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'Gln')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.Gln=[info.Gln, val{1}];
                end                
            end
        end 
        % Glu
        if ~isempty(has_Glu)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'Glu')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.Glu=[info.Glu, val{1}];
                end                
            end
        end 
        % Gly
        if ~isempty(has_Gly)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'Gly')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.Gly=[info.Gly, val{1}];
                end                
            end
        end 
        % GSH
        if ~isempty(has_GSH)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'GSH')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.GSH=[info.GSH, val{1}];
                end                
            end
        end         
        % Lac
        if ~isempty(has_Lac)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'Lac')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.Lac=[info.Lac, val{1}];
                end                
            end
        end  
        % mI+Gly
        if ~isempty(has_mIGly)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'mI+Gly')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.mI_Gly=[info.mI_Gly, val{1}];
                end                
            end
        end  
        % Glu+Gln
        if ~isempty(has_GluGln)
            line_chars = textscan(line, '%s', 'delimiter', ' ');  
            for c=1:length(line_chars{1})
                if strcmp(line_chars{1}{c},'Glu+Gln')
                    break;
                end
                
                if ~isempty(line_chars{1}{c})
                    val=textscan(line_chars{1}{c}, '%f', 'delimiter', '');
                    info.Glu_Gln=[info.Glu_Gln, val{1}];
                end                
            end
        end             
        
	end 

end

