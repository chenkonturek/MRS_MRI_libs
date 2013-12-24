function fids_tc = mrs_truncate( fids, n )
% MRS_TRUNCATE truncates n points from the end of each FID   
% 
% fids_tc = mrs_truncate( fids, n )
%
% ARGS :
% fids = FIDs before truncation    (dim=[samples,avgs,dyns])
% n = number of points to be truncated from the end of each FID 
%
% RETURNS:
% fids_tc = FIDs after truncation  (dim=[samples-n,avgs,dyns])
%
% EXAMPLE: 
% >> size(FIDs)
% >> FIDs_tc = mrs_truncate(FIDs, 1024); 
% >> size(FIDs_tc)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


	samples=size(fids,1);     
    fids_tc=fids(1:samples-n,:,:);  

end

