function FID = mrs_readLcmodelRAW( fileName )
% MRS_READLCMODELRAW reads the LCModel input .RAW file which contains  
% time domain data of each metabolite spectrum. 
% 
% FID = mrs_readLcmodelRAW( fileName )
%
% ARGS :
% fileName = name of LCModel output .RAW file 
%
% RETURNS:
% FIDs =  time domain data
% 
% EXAMPLE: 
% >> FID = mrs_readLcmodelRAW( fileName );
% >> figure; plot(real(mrs_fft(FID)));
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


    [~,~,ext]=fileparts(fileName);  
    
    if isempty(ext)==1
        fileName=[fileName,'.RAW'];
    end
    
    fid=fopen(fileName,'r');
	C = textscan(fid, '%f', 4096*2, 'headerlines', 5);
    data=reshape(C{1,1},2,[]);
	fclose(fid);
    
    FID=data(1,:)'+1i.*data(2,:)';
    
end

