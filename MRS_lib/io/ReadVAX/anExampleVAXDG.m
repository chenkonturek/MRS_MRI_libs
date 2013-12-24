function anExampleVAXDG
% This tests reading vaxd and vaxg files with the ieee-le file
% format. The functions freadVAXD and freadVAXG work in R2008b.
% This function works in R2008a and earlier because it requires
% fopen(...,'vaxd') and fopen(...,'vaxg') to write the files.
%
% See also freadVAXD, freadVAXG

% Copyright 2009-2011 The MathWorks, Inc.

%% Create (and store) test data (works on R2008a and earlier)
% % For later versions of MATLAB, use the existing files for testing
% genTestData    = [ rand(100,1)         ;
%                   -rand(100,1)         ;
%                    rand(100,1)*1e40    ;
%                    rand(100,1)*1e-40   ;
%                    rand(100,1)*1e100   ;
%                    rand(100,1)*1e-100  ;
%                    rand(100,1)*1e300   ;
%                    rand(100,1)*1e-300  ;
%                    eps('double')       ;%ieee minimum
%                   -eps('double')       ;%ieee minimum
%                    eps('single')       ;%ieee minimum
%                   -eps('single')       ;%ieee minimum
%                    inf                 ;%not supported data type by VAX
%                   -inf                 ;%not supported data type by VAX
%                    NaN                 ;%not supported data type by VAX
%                   -NaN                 ;%not supported data type by VAX
%                    realmax('double')   ;
%                   -realmax('double')   ;
%                    realmax('single')   ;
%                   -realmax('single')   ;
%                    realmin('double')   ;
%                   -realmin('double')   ;
%                    realmin('single')   ;
%                   -realmin('single')   ;
%                    realmax('double')/2 ;
%                   -realmax('double')/2 ;
%                    realmax('single')/2 ;
%                   -realmax('single')/2 ;
%                    realmin('double')/2 ;
%                   -realmin('double')/2 ;
%                    realmin('single')/2 ;
%                   -realmin('single')/2 ;
%                   -0                   ;
%                    0                   ;
%                   -1                   ;
%                    1                    ];
% 
% % Create VAXD File (works on R2008a and earlier)
% fid = fopen('test_vaxd','w','vaxd');
% fwrite(fid, genTestData, 'single');
% fwrite(fid, genTestData, 'double');
% fclose(fid);
% 
% % Create VAXG File (works on R2008a and earlier)
% fid = fopen('test_vaxg','w','vaxg');
% fwrite(fid, genTestData, 'single');
% fwrite(fid, genTestData, 'double');
% fclose(fid);
% 
% % Read VAXD File (works on R2008a and earlier)
% fid = fopen('test_vaxd','r','vaxd');
% genTestData_single_vaxd = fread(fid, length(genTestData), 'single');
% genTestData_double_vaxd = fread(fid, length(genTestData), 'double');
% fclose(fid);
% 
% % Read VAXG File (works on R2008a and earlier)
% fid = fopen('test_vaxg','r','vaxg');
% genTestData_single_vaxg = fread(fid, length(genTestData), 'single');
% genTestData_double_vaxg = fread(fid, length(genTestData), 'double');
% fclose(fid);
% 
% save testData

%% Load reference test data (works on 
testData = load('testData.mat');

%% Read VAXD files with ieee-le format (available in all MATLAB versions)
fid = fopen('test_vaxd','r','ieee-le');
vaxdSingle = freadVAXD(fid, length(testData.genTestData), 'single');
vaxdDouble = freadVAXD(fid, length(testData.genTestData), 'double');
fclose(fid);

%% Read VAXG files with ieee-le format (available in all MATLAB versions)
fid = fopen('test_vaxg','r','ieee-le');
vaxgSingle = freadVAXG(fid, length(testData.genTestData), 'single');
vaxgDouble = freadVAXG(fid, length(testData.genTestData), 'double');
fclose(fid);

%% Check for errors between:
% fid  = fopen(..., 'r', 'vaxd')
% data = fread(fid, ...)
%             vs
% fid  = fopen(..., 'r', 'ieee-le')
% data = freadVAX?(fid, ...)
disp(['Number of elements tested: ' num2str(length(testData.genTestData_single_vaxd))])
disp('Maximum Error --> VAXF:Single(in VAXD file) vs MATLAB:Single')
disp(max(abs(vaxdSingle-testData.genTestData_single_vaxd)))
disp('Maximum Error --> VAXD:Double vs MATLAB:Double')
disp(max(abs(vaxdDouble-testData.genTestData_double_vaxd)))
disp('Maximum Error --> VAXF:Single(in VAXG file) vs MATLAB:Single')
disp(max(abs(vaxgSingle-testData.genTestData_single_vaxg)))
disp('Maximum Error --> VAXG:Double vs MATLAB:Double')
disp(max(abs(vaxgDouble-testData.genTestData_double_vaxg)))

end
