Copyright 2009-2011 The MathWorks, Inc.

04/12/2011 - Fixed a bug. Zeros now read in as zeros rather than very small (<1E-38) numbers.

Contains:

    anExampleVADG.m     - code to test the accuracy (and generate data file on R2008a or earlier)
    freadVAXD.m         - reads files assuming vaxd 64bit double precision floating point numbers
    freadVAXG.m         - reads files assuming vaxg 64bit double precision floating point numbers
    uint32le_to_VAXF.m  - converts 1 uint32 bit numbers into a floating point number (assuming vaxf encoding)
    uint64le_to_VAXD.m  - converts 2 uint32 bit numbers into a floating point number (assuming vaxd encoding)
    uint64le_to_VAXG.m  - converts 2 uint32 bit numbers into a floating point number (assuming vaxg encoding)
    readme.txt          - this file
    testData.mat        - some sample date
    test_vaxd           - the sample data encoded in vaxd and vaxf double/single floating point numbers
    test_vaxg           - the sample data encoded in vaxg and vaxf double/single floating point numbers


In R2009a, fopen no longer supports vaxd and vaxg file formats. This tool lets your use the ieee-le
file format to read these files in R2009a and later. These tools are not for writing vaxd or vaxg files.
Though you could write VAXF_to_uint32le.m, VAXD_to_uint64le.m, and VAXG_to_uint64le.m functions as well
as fwriteVAXD.m and fwriteVAXG.m files if you wanted to generate new files in VAXD or VAXG formats.

VAXD and VAXG are two methods VAX uses for representing floating point double precision numbers. VAX has
a single method for representing single precision floating point numbers, VAXF. A VAXD encoded file uses
VAXD standard for double precision and VAXF for single precision. A VAXG encoded file uses VAXG for
double precision and VAXF for single precision. Information for how numbers are encoded can be found
here: http://www.opengroup.org/onlinepubs/9629399/chap14.htm#tagfcjh_20

To patch your code:
    1) Open your file with the 'ieee-le' format instead of 'vaxd' or 'vaxg'.
    2) Replace fread commands with freadVAXD and freadVAXG functions.

Notes:
    1) freadVAXD and freadVAXG assume three input arguments whereas the fread in MATLAB can take a number
       of different input arguments.
    2) All code is written in MATLAB. Speed might be improved by writing C-MEX functions.

Example:

If your code originally looked like this:

fid = fopen('myfile', 'r', 'vaxd');
A = fread(fid, 2, 'double');
A = fread(fid, 3, 'uint32');
fclose(fid);

You would change your code to look like this: 


fid = fopen('myfile', 'r', 'ieee-le');
A = freadVAXD(fid, 2, 'double');
A = freadVAXD(fid, 3, 'uint32');
fclose(fid);

Mike.Agostini@mathworks.com

