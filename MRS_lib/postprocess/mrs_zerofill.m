function fids_zf= mrs_zerofill( fids, n )
% MRS_ZEROFILL adds n points to the end of each FID   
% 
% fids_zf= mrs_zerofill( fids, n )
%
% ARGS :
% fids = FIDs before zerofilling    (dim=[samples,avgs,dyns])
% n = number of points to be added to the end of each FID 
%
% RETURNS:
% fids_zf = FIDs after zerofilling  (dim=[samples+n,avgs,dyns])
%
% EXAMPLE: 
% >> size(FIDs)
% >> FIDs_zf = mrs_zerofill(FIDs, 4096); 
% >> size(FIDs_zf)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    s = size(fids); 
    samples = s(1);
    s(1) = s(1) + n;
    
    fids_zf=zeros(s);        
    fids_zf(1:samples,:,:)=fids;

end

