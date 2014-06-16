function  slices_t = mrs_locateSlices( info )
% MRS_locateSLICE locate where the slices was acquired in the physiological log    
% 
% slices_t = mrs_locateSlices( info )
%
% ARGS :
% info = physiological log file information 
%
% RETURNS:
% slices_t = a list of points where each slice was located in log file 
%
%
% AUTHOR : Chen Chen, Dr Emma Hall
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

    slices_t = find(info.mark(:,4)=='8');
    if isempty(slices_t) 
        r=1;
        while r
            %if there is no slice marker (when scanner is not patched), look at the gradients
            f1=figure;
            plot(info.t,info.gx,'k');xlabel('time (s)');ylabel('gradient trace (AU)');title('GX');grid on;set(gcf,'color',[1 1 1]);
            f2=figure;
            plot(info.t,info.gy,'k');xlabel('time (s)');ylabel('gradient trace (AU)');title('GY');grid on;set(gcf,'color',[1 1 1]);
            f3=figure;
            plot(info.t,info.gz,'k');xlabel('time (s)');ylabel('gradient trace (AU)');title('GZ');grid on;set(gcf,'color',[1 1 1]);

            g = input('Choose a gradient trace to find slice timings, x y or z:   ','s');
            close(f1);close(f2);close(f3);
            if g =='x' || g =='X'
                gr = info.gx;
            elseif g == 'y' || g =='Y'
                gr = info.gy;
            else
                gr = info.gz;
            end
            peak = zeros(size(gr));
            for count = 2:length(gr)-1
                if gr(count) > gr(count-1) && gr(count) > gr(count+1)
                    peak(count)=1;
                end
            end
            peak(count+1)=0;
            b_thresh = input('Enter a lower threshold:    ');
            t_thresh = input('Enter an upper threshold:    ');
            peak_new = (peak.*gr)>b_thresh & (peak.*gr)<t_thresh;
            figure(5);plot(info.t,gr,'k');hold on; plot(info.t,peak_new.*gr,'r+');set(gcf,'color',[1 1 1]);
            slices_t = find(peak_new ==1);
            
            r=input('Do the slice markers need recalculating? 0)no 1)yes : ');
        end
    end
    disp([num2str(length(slices_t)),' slice markers were found']);
end

