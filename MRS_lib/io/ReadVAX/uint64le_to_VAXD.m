function [ doubleVAXD ] = uint64le_to_VAXD(uint32le)
%UINT64LE_TO_VAXD Converts from IEEE-LE (UINT32) to VAXD (double)
%  This function takes a vector columns of raw 32bit unsigned integers
%  (little endian), combines them into 64bit unsigned integers, and
%  converts the result into the equivalent floating point numbers using
%  the specification for the VAXD floating point number format.
%  VAXD and VAXG are two 64bit floating point formats. VAXF is the 32bit
%  floating point format used in conjunction with both VAXD and VAXG.
%  http://www.opengroup.org/onlinepubs/9629399/chap14.htm#tagfcjh_20
%
%  The function is intended to be called from FREADVAXD.
%
%   See also UINT32LE_TO_VAXF, UINT64LE_TO_VAXG, FREADVAXD, FREADVAXG

%   Copyright 2009-2011 The MathWorks, Inc.

%% Define floating value properties for VAX architecture
% The generic equation for a floating point number is:
% (-1)^double(S) * (F+C) * A^(double(E)-B);
% Different operating systems and file formats utilize different values
% for A, B, and C. F, E, and S are computed from the appropriate bits in
% the number as stored on disk.

    A = 2   ;%VAX specific
    B = 128 ;%VAX specific
    C = 0.5 ;%VAX specific

%% Move the raw unsigned bytes into the right order
% Flip the upper and lower bits (based on how Vax data storage format)
% VAX (64bit)      <--WORD1--><--WORD2--><--WORD3--><--WORD4-->
% IEEE-LE (32bit)  <--WORD2--><--WORD1-->
% IEEE-LE (32bit)  <--WORD4--><--WORD3-->

    uint32le  = reshape(uint32le,2,[])';%reshape and transpose
    uint32leA = uint32le(:,1)          ;%<--WORD2--><--WORD1-->
    uint32leB = uint32le(:,2)          ;%<--WORD4--><--WORD3-->

% Swap WORD1 and WORD2

    word2   = bitshift(bitshift(uint32leA,  0), -16);%mask FFFF0000
    word1   = bitshift(bitshift(uint32leA, 16), -16);%mask 0000FFFF
    vaxIntA = bitor(bitshift(word1,16), bitshift(word2, 0));

% Swap WORD3 and WORD4

    word4   = bitshift(bitshift(uint32leB,  0), -16);%mask FFFF0000
    word3   = bitshift(bitshift(uint32leB, 16), -16);%mask 0000FFFF
    vaxIntB = bitor(bitshift(word3,16), bitshift(word4, 0));

% Create UINT64: <--WORD1--><--WORD2--><--WORD3--><--WORD4-->
    
    vaxIntA = bitshift(uint64(vaxIntA),32);
    vaxIntB = uint64(vaxIntB);
    vaxInt  = bitor(vaxIntA,vaxIntB);
       
% Pull out the sign, exponent, and fractional component
% VAX FLOAT BYTES  <-----WORD1----><-----WORD2----><-----WORD1----><-----WORD2---->
% VAX FLOAT BITS   0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
% Sign Exp Fract   SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

    S  = bitshift(vaxInt, -63);
    E  = bitshift(bitshift(vaxInt, 1),-56);
    F  = bitshift(bitshift(vaxInt, 9), -9);

% Construct the floating point number from SEF (Sign, Exp, Fract)
% Formula valid for non-zero values only (zeros fixed in next step)
% http://www.codeproject.com/KB/applications/libnumber.aspx
% http://www.opengroup.org/onlinepubs/9629399/chap14.htm#tagfcjh_20

    M = C+double(F)./72057594037927936; %VAX Specific 72057594037927936=2^56
    doubleVAXD = (-1).^double(S) .* M .* A.^(double(E)-B);%Generic

% Add in zeros (if E and S are zero, doubleVAXD should be set to zero)

    zerosIndex = (E == 0 & S == 0);%logical index of all zeros
    doubleVAXD(zerosIndex) = 0;
    
end
