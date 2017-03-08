function  mrs_writeSPAR( fileName, info )
% MRS_WRITESPAR write Philips MRS header file (.SPAR)
% This function uses hdr_template.SPAR file as a template file, and
% modifies it with the given information (info). Please remember to add the 
% MRS_MRI_libs folder to MATLAB path. 
% 
% ARGS :
% fileName = name of header file to be saved 
% info = header information to be provided,
%        including: averages, TE, TR, BW, transmit_frequency, size[LR,AP,FH]
% 
%
% EXAMPLE: 
% >> [data_spectra, water_spectra, info]=mrs_readGEpfile(filename);
% >> mrs_writeSDAT([filename,'.SDAT'], data_spectra);
% >> mrs_writeSPAR([filename,'.SPAR'],info);
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Imaging  Centre (SPMIC)
%
% Copyright (c) 2017, University of Nottingham. All rights reserved.

    [~,~,ext]=fileparts(fileName);

    if isempty(ext)==1
        fileName=[fileName,'.SPAR'];
    end

    p=which('hdr_template.SPAR');     
    copyfile(p,fileName);
    
    mrs_editSPAR(fileName,'averages',info.averages(1));
    mrs_editSPAR(fileName,'echo_time',info.TE);
    mrs_editSPAR(fileName,'repetition_time',info.TR);
    mrs_editSPAR(fileName,'samples',info.samples);
    mrs_editSPAR(fileName,'sample_frequency',info.BW);
    mrs_editSPAR(fileName,'dim1_step',1/info.BW);
    mrs_editSPAR(fileName,'synthesizer_frequency',info.transmit_frequency);
    mrs_editSPAR(fileName,'ap_size',info.size(1));
    mrs_editSPAR(fileName,'lr_size',info.size(2));
    mrs_editSPAR(fileName,'cc_size',info.size(3));
    mrs_editSPAR(fileName,'spectrum_echo_time',info.TE);

end

