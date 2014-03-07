function [spect_phased phi]= mrs_manualzeroPHC(spect, xrange)   
% MRS_MANUALZEROPHC allows users to manually apply zero-order phase correction 
% of a spectrum.     
% 
% [spect_phased phi]= mrs_manualzeroPHC(spect, xrange)   
%
% ARGS :
% spect = a spectrum before mannual zero-order phase correction
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
   g=figure('Position', [360 400 560 560]);
   plot(xrange,real(spect(xrange)));
   title(' real (Spectra)');
   
   bg_color = get(gcf,'Color'); 
   
   uicontrol('Style','text','Position',[80 20 250 20],...
        'BackgroundColor',bg_color,'String','Zero Order Phase (degree): ');  
    
   text = uicontrol('Style','text',...
        'BackgroundColor',bg_color,'Position',[280 20 50 20],'String',0);
    
   slider = uicontrol('Style', 'slider',...
        'Min',0,'Max',2*pi,'Value',0,...
        'Position',[350 20 200 20],...
        'Callback', {@updateGUI,text, spect, xrange}); 
    
   pushbutton = uicontrol('Style', 'pushbutton', 'String', 'Done',...
        'BackgroundColor',bg_color,'Position',[20 20 50 20],...
        'Callback', {@done,g,slider,spect});  
    
   set( g, 'menubar', 'figure' );
   
   waitfor(g);
   if exist('pc_temp.mat', 'file')
        load pc_temp.mat;
         disp(['Phase to be corrected = ', num2str(phi)]);
        delete pc_temp.mat;
   end
end   

function updateGUI(hObj, ~, textH, spect, xrange) 
	val = get(hObj,'Value');
    text = findobj(textH,'Style','text');
    phi = val/pi*180;
    set(text, 'String', phi);
    
    spect_phased = mrs_rephase(spect,val);    
    
    plot(xrange,real(spect_phased(xrange)));
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

