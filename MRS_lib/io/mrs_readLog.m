function info = mrs_readLog( fileName)
% MRS_READLOG reads physiological log file (.log) 
%
% info = mrs_readLog(fileName)
%
% ARGS :
% fileName = name of log file 
%
% RETURNS:
% info = log file information 
%
% EXAMPLE: 
% >> info = mrs_readSPAR('sub1.log');
% >> disp(info)
%
% AUTHOR : Chen Chen, Dr Emma Hall
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


    [~,~,ext]=fileparts(fileName);
    if isempty(ext)==1
        fileName=[fileName,'.log'];
    end
    
    [info.v1raw, info.v2raw, info.v1, info.v2, info.ppu, info.resp, info.gx, info.gy, info.gz, info.mark] = textread(fileName, ...
    '%d %d %d %d %d %d %d %d %d %s', 'headerlines', 5, 'whitespace', '#');	
        
    info.mark = cell2mat(info.mark);
    info.t=(0:1:(length(info.resp)-1))'*0.002;
end

