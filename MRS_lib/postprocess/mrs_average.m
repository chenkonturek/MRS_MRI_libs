function fids_avg = mrs_average( fids, n )
% MRS_AVERAGE averages every n FIDs.    
% 
% fids_avg = mrs_average( fids, n )
%
% ARGS :
% fids = FIDs before averaging  (dim=[samples,avgs,dyns])
% n = number of FIDs to average over 
%
% RETURNS:
% FIDs_avg = FIDs after averaging  (dim=[samples,avgs/n,dyns])
%
% EXAMPLE: 
% >> size(FIDs)
% >> FIDs_avg = mrs_average(FIDs,8); 
% >> size(FIDs_avg)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.


    [samples, avgs, dyns]=size(fids);    
    fids_avg=squeeze(mean(reshape(fids,samples,n,avgs/n,dyns),2)); 
end

