function [spect_phased phi]= mrs_manualzeroPHC(spect, xrange, spect_disp)   
% MRS_MANUALZEROPHC allows users to manually apply zero-order phase correction 
% of a spectrum. Use the slider to adjust the phase correction value. 
% Once the spectrum is corrected, click 'Done'.    
% 
% [spect_phased phi]= mrs_manualzeroPHC(spect, xrange)   
%
% ARGS :
% spect = a spectrum before mannual zero-order phase correction
% xrange (optional) = x ranges (in points) you want to display when doing phase correction 
% spect_disp = a fxied spectrum displayed for comparison purpose
%
% RETURNS:
% spect_phased = a spectrum after mannual zero-order phase correction 
% phi = phase correction value (in rad) 
%
%
%
% AUTHOR : Chen Chen
% PLACE  : Sir Peter Mansfield Magnetic Resonance Centre (SPMMRC)
%
% Copyright (c) 2013, University of Nottingham. All rights reserved. 

   spect_phased=[];
   phi=[];
   
   if nargin>1
       xs=xrange(1):xrange(2);
   else
       xs=1:size(spect,1);
   end
   
   
   g=figure('Position', [360 400 560 560]);
   plot(xs,real(spect(xs)));
   if nargin>2
       hold on 
       plot(xs,real(spect_disp(xs)),'r');
       hold off
   end
   title(' real (Spectra)');
   
   bg_color = get(gcf,'Color'); 
   
   uicontrol('Style','text','Position',[80 20 250 20],...
        'BackgroundColor',bg_color,'String','Zero Order Phase (degree): ');  
    
   text = uicontrol('Style','text',...
        'BackgroundColor',bg_color,'Position',[280 20 50 20],'String',0);
    
   slider = uicontrol('Style', 'slider',...
        'Min',0,'Max',2*pi,'Value',0,'SliderStep',[0.002 0.10],...
        'Position',[350 20 200 20],...
        'Callback', {@updateGUI,text, spect, xs, spect_disp}); 
    
   pushbutton = uicontrol('Style', 'pushbutton', 'String', 'Done',...
        'BackgroundColor',bg_color,'Position',[20 20 50 20],...
        'Callback', {@done,g,slider,spect});  
    
   set( g, 'menubar', 'figure' );
   
   waitfor(g);
   if exist('pc_temp.mat', 'file')
        load pc_temp.mat;
        delete pc_temp.mat;
   end
end   

function updateGUI(hObj, ~, textH, spect, xs, spect_disp) 
	val = get(hObj,'Value');
    text = findobj(textH,'Style','text');
    phi = val/pi*180;
    set(text, 'String', phi);
    
    spect_phased = mrs_rephase(spect,val);    
    
    plot(xs,real(spect_phased(xs)));
    hold on
    plot(xs,real(spect_disp(xs)),'r');
    hold off
    %[A B spects_fit ~]=mrs_fitPeak(spect_phased,[1 size(spect,1)],1);
    %hold on 
    %plot(real(spects_fit),'r');
    %hold off
    title(' real (Spectra)');       
end   

function done(~, ~, fig, sliderH, spect)
    phi = get(sliderH,'Value');
    spect_phased = mrs_rephase(spect, phi); 
   
    save('pc_temp.mat','spect_phased','phi');
    close(fig);
end

