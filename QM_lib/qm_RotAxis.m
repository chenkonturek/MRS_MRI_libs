function R = qm_RotAxis( beta, axis )
% QM_ROTAXIS returns rotation matrix around one axis 
%
% ARGS :
% beta = angle
% axis = x, y, or z
%
% RETURNS:
% R = rotation matrix
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2014, University of Nottingham. All rights reserved.
    
    switch axis
        case 'x'
            R=[cos(beta/2), -1i*sin(beta/2); -1i*sin(beta/2), cos(beta/2)];
            
        case 'y'
            R=[cos(beta/2), -sin(beta/2); sin(beta/2), cos(beta/2)];
            
        case 'z'
            R=[exp(-1i*beta/2), 0; 0, exp(1i*beta/2)];
            
        otherwise
            disp('Wrong axis option. Please select from x,y,z.');
        
    end
end

