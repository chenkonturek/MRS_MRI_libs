function count = fwriteVAX(fid, A, precision, method)
% FWRITEVAX Write data in VAX format.
% COUNT = FWRITEVAX(FID, A, PRECISION, METHOD) writes the elements of matrix A
% to the specified file, translating MATLAB ® values to the specified
% precision. COUNT is the number of elements successfully written.
%
% FID is an integer file identifier obtained from FOPEN. FWRITEVAX requires
% FOPEN to open the output file in IEEE little-endian machineformat.
%
% PRECISION controls the form and size of result. See FREAD for supported
% formats.
% 
% METHOD specifies which of the two VAX file formats to use: VAXD or VAXG.
% 
% Usage:
%   A = rand(3,3); 
% 	fid = fopen('myFile', 'w', 'ieee-le');
%	count = fwriteVAX(fid, A, 'double', 'vaxg');
%   fclose(fid);
% 
% The function is intended to be called by the user.
%
% ® 2009 The MathWorks, Inc. MATLAB and Simulink are registered trademarks
% of The MathWorks, Inc. See www.mathworks.com/trademarks for a list of 
% additional trademarks. Other product or brand names may be trademarks or 
% registered trademarks of their respective holders.

switch method

   case {'vaxd', 'VAXD'}
     count = fwriteVAXD(fid, A, precision);

   case {'vaxg', 'VAXG'}
     count = fwriteVAXG(fid, A, precision);

   otherwise
     error([method, ' is an unsupported method'])

end
