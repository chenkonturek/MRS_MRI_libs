function [resp_phase]=mri_calRESPphase(resp,win_step,win)
% MRI_CALRESTPHASE calculates the phase of the respiratory cycle by using
% the method detail in Glover et al (2000) and employing a peak/trough
% finding algorithm to determine the sign of the phase.
% This function is used in the RETROICOR program for the correction of
% image data for physiological noise.
% 
% [resp_phase]=mri_calRESPphase(resp,win_step,win)
%
% ARGS :
% resp = psyiological respiration log data (info.resp) 
% win_step = window moving step
% win = window size 
%
% RETURNS:
% resp_phase = calcuated phase of the respiratory cycle
%
% AUTHOR : Dr Emma Hall
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2009, University of Nottingham. All rights reserved.


    Rmin = min(resp);
    resp = resp - Rmin; %Resp now in the range 0-Rmax
    Rmax = max(resp);
    bin_centre = linspace((Rmax/100),Rmax);
    h = hist(resp,bin_centre);
    samples=1:150:length(resp);
    smoothed_resp = resp(samples);
    pos_min = zeros(size(resp));
    pos_max = pos_min;
    pos=zeros(size(resp));
    for N=1:win_step:(length(smoothed_resp)-win+1)
        b = N:(N+win-1);
        wind = smoothed_resp(b);
        f = find(wind ==min(wind));
        F = find(wind ==max(wind));
        f = f(1);
        F = F(1);
        if f ~= 1 || f ~= win
            pos_min(samples(b(f)))=smoothed_resp(b(f));
            pos(samples(b(f)))=1;
        end
        if F ~= 1 || F ~= win
            pos_max(samples(b(F)))=smoothed_resp(b(F));
            pos(samples(b(F)))=2;
        end
    end

    MMM=find(pos);
    dis=ones(size(pos));
    for MM=1:(length(MMM)-1)
        M=MMM(MM);
        T=MMM(MM+1);
        if pos(M)==pos(T)
            if pos(M)==1 && pos(T)==1
                if pos_min(M)<pos_min(T)
                    dis(T)=0;
                else
                    dis(M)=0;
                end
            end
            if pos(M)==2 && pos(T)==2
                if pos_max(M)>pos_max(T)
                    dis(T)=0;
                else
                   dis(M)=0; 
                end
            end
        end
    end
    pos = pos.*dis;
    P = find(pos);
    S = zeros(size(pos));
    for K=1:(length(P)-1)
        if pos(P(K))==1 && pos(P(K+1))==2
            S(P(K):P(K+1))=1;
        end
        if pos(P(K))==2 && pos(P(K+1))==1
            S(P(K):P(K+1))=-1;
        end
    end

    if P(1)~=1
        if P(1)==1;
            S(1:P(1))=-1;
        else
            S(1:P(1))=1;
        end
    end
    if P(length(P))~=length(S)
        if P(length(P))==1;
            S(P(length(P)):length(S))=1;
        else
            S(P(length(P)):length(S))=-1;
        end
    end
    %% Assign the sign to the phase;
    resp_phase =zeros(size(S));
    for RR=1:length(resp_phase)

        top = round(100*resp(RR)/Rmax);
        resp_phase(RR)=pi*sum(h(1:top))/sum(h);

    end

    resp_phase = resp_phase.*S;
end
