function [ uint32le ] = VAXD_to_uint64le(doubleVAXD)
%VAXD_TO_UINT64LE Converts from VAXD (double) to IEEE-LE (UINT32)
% This function converts floating point numbers initialized in MATLAB ®
% into equivalent 64bit unsigned integers, and then splits the result
% into a vector columns of raw 32bit unsigned integers (little endian)
% using the specification for the VAXD floating point number format.
% VAXD is a 64bit floating point format. VAXF is the 32bit floating point 
% format used in conjunction with both VAXD and VAXG.
%  http://www.opengroup.org/onlinepubs/9629399/chap14.htm#tagfcjh_20
%
% The function is intended to be called from FWRITEVAXD.
%
% See also VAXF_TO_UINT32LE, VAXG_TO_UINT64LE, FWRITEVAX
%
% ® 2009 The MathWorks, Inc. MATLAB and Simulink are registered trademarks
% of The MathWorks, Inc. See www.mathworks.com/trademarks for a list of 
% additional trademarks. Other product or brand names may be trademarks or 
% registered trademarks of their respective holders.

%% Define floating value properties for VAX architecture
% The generic equation for a floating point number is:
% V = (-1)^double(S) * M * A^(double(E)-B);
% Substituting M = C + F 
% V = (-1)^double(S) * (C+F) * A^(double(E)-B);
%
% Performing inverse operations to solve for E and F:
% 0 <= 1 + log(M)/log(2) < 1  (VAX specific)
% E = (floor) (logV / D) + 1 + B   
% F = V / ((A ^ (E-B)) - C)
%
% V = value, S = sign, M = mantissa, A = base, E = exponent, B = exponent 
% bias, C = mantissa constant, F = fraction

A = 2;      % VAX specific
B = 128;    % VAX specific
C = 0.5;    % VAX specific
D = log(2); % VAX specific

%% Determine the sign bit. If -ve transform to positive.
S = zeros(size(doubleVAXD));
if any(doubleVAXD(:) < 0)
	indices = find(doubleVAXD<0);
    doubleVAXD(indices) = (-1) .* doubleVAXD(indices);
    S = zeros(size(doubleVAXD));
    S(indices) = 1;
end

%% Decompose the floating point number to SEF (Sign, Exp, Fract)
E = floor((log(doubleVAXD)./ D) + 1 + B); 
F = ((doubleVAXD ./ A.^(double(E)-B))) - C; 
% Convert floating point fraction to unsigned integer
F = F * 72057594037927936;   %VAX Specific 72057594037927936=2^56

%% Shift the bits of S, E and F
% VAX FLOAT BYTES  <-----WORD1----><-----WORD2----><-----WORD1----><-----WORD2---->
% VAX FLOAT BITS   0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
% Sign Exp Fract   SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

S = bitshift(bitshift(uint64(S),0), 63);
E = bitshift(bitshift(uint64(E),0), 56);
F = bitshift(bitshift(uint64(F),0), 9);

%% Combine the S, E and F into the unsigned integer value
vaxInt = bitor(bitor(S,bitshift(E,-1)),bitshift(F,-9));

%% Convert to raw 32bit integers
% Flip the upper and lower bits (based on how Vax data storage format)
% VAX (64bit)      <--WORD1--><--WORD2--><--WORD3--><--WORD4-->
% IEEE-LE (32bit)  <--WORD2--><--WORD1-->
% IEEE-LE (32bit)  <--WORD4--><--WORD3-->

% Split IEEE UINT64: <--WORD1--><--WORD2-->|<--WORD3--><--WORD4-->
%                    \____________________/ \____________________/
%                          vaxIntA               vaxIntB

vaxIntA = uint32(bitshift(bitshift(vaxInt,0), -32));
vaxIntB = uint32(bitshift(bitshift(vaxInt,32), -32));

% Swap WORD1 and WORD2

word2 = bitshift(bitshift(vaxIntA, 16), -16);
word1 = bitshift(vaxIntA, -16);
uint32leA = bitor(bitshift(word2,16), word1);

% Swap WORD3 and WORD4

word4 = bitshift(bitshift(vaxIntB, 16), -16);
word3 = bitshift(vaxIntB, -16);
uint32leB = bitor(bitshift(word4,16), word3);

uint32le(:,1) = reshape(uint32leA, numel(uint32leA), []);  %<--WORD2--><--WORD1-->
uint32le(:,2) = reshape(uint32leB, numel(uint32leB), []);  %<--WORD4--><--WORD3-->

uint32le = uint32le';

% IEEE (LE) DOUBLE BYTES  <-----WORD4----><-----WORD3----><-----WORD2----><-----WORD1---->
% IEEE (LE) DOUBLE BITS   0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
% Sign Exp Fract          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEES


