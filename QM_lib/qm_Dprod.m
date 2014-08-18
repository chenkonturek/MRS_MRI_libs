function M = qm_Dprod( M1, M2 )
% QM_Dpord returns the direct product of matrices M1, M2
% 
% ARGS :
% M1 = a matrix
% M2 = a matrix 
%
% RETURNS:
% M = the direct product of M1 & M2
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
 
    
    M=kron(M1,M2);
%     M=[];
%     for i=1:size(M1,1)
%         Mt=[];
%         for j=1:size(M1,2)
%             Mt=[Mt M1(i,j)*M2];
%         end
%         M=[M;Mt];
%     end
end

