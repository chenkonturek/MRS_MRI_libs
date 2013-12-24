function status = mrs_editSPAR(fileName, attribute, value)
% MRS_EDITSPAR edits the value of a pariticular attribute in 
% Philips MRS header file (.SPAR) 
%
% status = mrs_editSPAR(fileName, attribute, valu)
%
% ARGS :
% fileName = name of target header file 
% attribute = the name of the attribute 
% value = the new value for the attribute
%
% RETURNS:
% status =  1, when the operation is successful; otherwise, 0.  
%
% EXAMPLE: 
% >> mrs_editSPAR('sub1_new.SPAR', 'sample', 8192);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

	[~,~,ext]=fileparts(fileName);    
	if isempty(ext)==1
        fileName=[fileName,'.SPAR'];
	end
 
    fid=fopen(fileName,'r');            
    header_info=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
	no_lines=length(header_info{1});
            
    for i=1:no_lines    
        has_attr = strfind(header_info{1}{i},attribute); 
         if ~isempty(has_attr) % change  value of attribute
             header_info{1}{i}=[attribute,' : ',num2str(value)]; 
         end                             
    end  
    % write back to the same file  
    fid=fopen(fileName,'w');            
    fprintf(fid,'%s\n',header_info{1}{:});
    status=fclose(fid);
    
end

