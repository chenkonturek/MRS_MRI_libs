function info = mrs_readSIN( fileName )
% MRS_READSIN reads Philips MRS raw header file (.SIN) 
%
% info = mrs_readSIN(fileName)
%
% ARGS :
% fileName = name of header file 
%
% RETURNS:
% info = header file information 
%
% EXAMPLE: 
% >> info = mrs_readSIN('sub4.SIN');
% >> disp(info)
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    [~,~,ext]=fileparts(fileName);    
    if isempty(ext)==1
        fileName=[fileName,'.sin'];
    end

    fid=fopen(fileName,'r');            
    sin_info=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    c=1; e=1; f=1; g=1; h=1; d=1; % index

    for i = 1:length(sin_info{:});
        b=char(sin_info{1}{i});
        ch = strfind(b,'nr_measured_channels');
        dy = strfind(b, 'max_rows');
        av = strfind(b, 'nr_measurements');
        ph = strfind(b, 'phase_per_channel_arr');
        nop = strfind(b, 'recon_resolutions');
        dr = strfind(b, 'max_dr_samples');
        if ch~=0
            ch_str=textscan(b,'%s','delimiter',':');
            info.no_channels(c) = str2double(ch_str{1}{3});
            c=c+1;
        end
        if  dy~=0
             dy_str = textscan(b,'%s','delimiter',':');
             info.no_dynamics(d) = str2double(dy_str{1}{3});
             d=d+1;
        end
        if  av~=0
            avg_str = textscan(b,'%s','delimiter',':');
            info.no_averages(e) = str2double(avg_str{1}{3}); 
            e=e+1;
        end
        if ph~=0
            ph_str = textscan(b,'%s','delimiter',':');
            info.channel_phase(f) = str2double(ph_str{1}{3});
            f=f+1;
        end
        if nop~=0
            np_str = textscan(b,'%s','delimiter',':');
            np_str = textscan(np_str{1}{3},'%s','delimiter',' ');
            info.no_points(g) = str2double(char(np_str{1}{1}));
            g=g+1;
        end
        if dr~=0
            acq_str = textscan(b,'%s','delimiter',':');
            info.no_acq_points(h) = str2double(acq_str{1}{3});
            h=h+1;
        end
    end
    
end

