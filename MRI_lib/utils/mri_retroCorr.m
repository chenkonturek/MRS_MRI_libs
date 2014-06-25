function  corr_img =  mri_retroCorr( img, mod_img,CP, RP )
% MRI_RETROCORR retrospective correction of physiological motion effects    
% 
% slices_t = mri_locateSlices( info )
%
% ARGS :
% info = physiological log file information 
%
% RETURNS:
% slices_t = a list of points where each slice was located in log file 
%
%
% AUTHOR : Dr Emma Hall, Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved.

        corr_CP=1;
        corr_RP=1;
        if isempty(CP)
            CP = zeros(size(RP)); 
            corr_CP=0;
        end
        if isempty(CP)
            RP = zeros(size(CP));
            corr_RP=0;
        end
    
        % Calculate Coefficients
        [xdim ydim zdim dyn]=size(img);
        N=dyn;
        
        delta = zeros(xdim,ydim,zdim,dyn);  
        
        mask = mod_img>0;    %Need a mask
        x=(1:dyn)';
        X = [ones(dyn,1) x x.^2 x.^3 x.^4];
        disp('Now correcting time course for physiological noise effects')          
        lf = input('Would you like the low frequency drift to be removed? y/n    ','s');
        for sl=1:zdim
            RPs = RP(sl:zdim:zdim*dyn);
            CPs = CP(sl:zdim:zdim*dyn);
            disp(['Slice ',num2str(sl),' of ',num2str(zdim),' completed']);
            [C,D]=find(mask(:,:,sl));        
            M(:,1) = cos(RPs);
            M(:,2) = cos(2*RPs);
            M(:,3) = sin(RPs);
            M(:,4) = sin(2*RPs);
            M(:,5) = cos(CPs);
            M(:,6) = cos(2*CPs);
            M(:,7) = sin(CPs);
            M(:,8) = sin(2*CPs);
            for i=1:length(C)
                %extract single voxel timecourse from image file
                tc=squeeze(img(C(i),D(i),sl,:));            
                if lf == 'y' || lf =='Y'
                    a = X\tc;
                    Y = X*a;
                    tc = tc - Y;
                    tc = tc+ mean(Y);
                end
                T = mean(tc);
                coeffs = zeros(1,8);
                for I = 1:N
                    coeffs(1)=coeffs(1)+(tc(I)-T)*M(I,1);        %Resp a1
                    coeffs(2)=coeffs(2)+(tc(I)-T)*M(I,2);        %Resp a2
                    coeffs(3)=coeffs(3)+(tc(I)-T)*M(I,3);        %Resp b1
                    coeffs(4)=coeffs(4)+(tc(I)-T)*M(I,4);        %Resp b2
                    coeffs(5)=coeffs(5)+(tc(I)-T)*M(I,5);        %Card a1
                    coeffs(6)=coeffs(6)+(tc(I)-T)*M(I,6);        %Card a2
                    coeffs(7)=coeffs(7)+(tc(I)-T)*M(I,7);        %Card b1
                    coeffs(8)=coeffs(8)+(tc(I)-T)*M(I,8);        %Card b2
                end
                coeffs(1)=coeffs(1)/sum(M(:,1).^2);
                coeffs(2)=coeffs(2)/sum(M(:,2).^2);
                coeffs(3)=coeffs(3)/sum(M(:,3).^2);
                coeffs(4)=coeffs(4)/sum(M(:,4).^2);
                coeffs(5)=coeffs(5)/sum(M(:,5).^2);
                coeffs(6)=coeffs(6)/sum(M(:,6).^2);
                coeffs(7)=coeffs(7)/sum(M(:,7).^2);
                coeffs(8)=coeffs(8)/sum(M(:,8).^2);

                %Create correction factor
                if corr_RP && corr_CP
                    delta(C(i),D(i),sl,:) = coeffs(5)*M(:,5)+coeffs(7)*M(:,7)+coeffs(1)*M(:,1)+coeffs(3)*M(:,3)+...
                    coeffs(6)*M(:,6)+coeffs(8)*M(:,8)+coeffs(2)*M(:,2)+coeffs(4)*M(:,4);
                elseif corr_CP
                    delta(C(i),D(i),sl,:) = coeffs(5)*M(:,5)+coeffs(7)*M(:,7)+...
                    coeffs(6)*M(:,6)+coeffs(8)*M(:,8);
                else
                    delta(C(i),D(i),sl,:) = coeffs(1)*M(:,1)+coeffs(3)*M(:,3)+...
                    coeffs(2)*M(:,2)+coeffs(4)*M(:,4);
                end
            end
        end
    %% Corrected image
     corr_img= img - delta;
end

