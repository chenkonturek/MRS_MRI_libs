function varargout = create_stdMaskvoxel(varargin)
% CREATE_STDMASKVOXEL M-file for create_stdMaskvoxel.fig
%      CREATE_STDMASKVOXEL, by itself, creates a new CREATE_STDMASKVOXEL or raises the existing
%      singleton*.
%
%      H = CREATE_STDMASKVOXEL returns the handle to a new CREATE_STDMASKVOXEL or the handle to
%      the existing singleton*.
%
%      CREATE_STDMASKVOXEL('Property','Value',...) creates a new CREATE_STDMASKVOXEL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to create_stdMaskvoxel_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CREATE_STDMASKVOXEL('CALLBACK') and CREATE_STDMASKVOXEL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CREATE_STDMASKVOXEL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% AUTHOR : Dr. Chen Chen 
% PLACE  : Sir Peter Mansfield Imaging Centre (SPMIC)
%
% Copyright (c) 2016, University of Nottingham. All rights reserved.
%
% Edit the above text to modify the response to help create_stdMaskvoxel

% Last Modified by GUIDE v2.5 18-Jan-2016 10:04:36
% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @create_stdMaskvoxel_OpeningFcn, ...
                   'gui_OutputFcn',  @create_stdMaskvoxel_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before create_stdMaskvoxel is made visible.
function create_stdMaskvoxel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for create_stdMaskvoxel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes create_stdMaskvoxel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = create_stdMaskvoxel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function i_LR_Callback(hObject, eventdata, handles)
% hObject    handle to i_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
     
     val=get(hObject,'Value');       
     h=findobj('Tag','openfile');
     mri = get(h,'UserData'); 
     
     ho=findobj('Tag','overlay');
     overlay = get(ho,'UserData'); 
     if ~isempty(overlay)
         hlb=findobj('Tag','lb_fROI');
         hlb_ID=get(hlb,'Value');
     
        %overlay.fROI.name(hlb_ID)
        overlay_img=int16(overlay.img==overlay.fROI.val(hlb_ID)); 
     end
     slice_num=round((size(mri.img,1)-1)*val);
     axes(handles.LR)
     imagesc(rot90(squeeze(mri.img(slice_num+1,:,:))));
     axis off
     hold on
     if ~isempty(overlay)
        p1=imagesc(rot90(squeeze(overlay_img(slice_num+1,:,:))/overlay.max*mri.max),[mri.min mri.max]);
        alpha(p1,.5)
        axis off
     end     
     p11=imagesc(rot90(squeeze(mri.mask(slice_num+1,:,:))/mri.maskmax*mri.max),[mri.min mri.max]);
     alpha(p11,.5)
     hold off
     
     
     txt=findobj('Tag','di_LR');
     set(txt,'String',num2str(slice_num)); 
     

% --- Executes during object creation, after setting all properties.
function i_LR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
   
end


% --- Executes on slider movement.
function i_AP_Callback(hObject, eventdata, handles)
% hObject    handle to i_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

     val=get(hObject,'Value');       
     h=findobj('Tag','openfile');
     mri = get(h,'UserData'); 
     
     ho=findobj('Tag','overlay');
     overlay = get(ho,'UserData');
     
     if ~isempty(overlay) 
         hlb=findobj('Tag','lb_fROI');
         hlb_ID=get(hlb,'Value');
         %overlay.fROI.name(hlb_ID)
         overlay_img=int16(overlay.img==overlay.fROI.val(hlb_ID)); 
     end
     slice_num=round((size(mri.img,2)-1)*val);
     axes(handles.AP)
     imagesc(rot90(squeeze(mri.img(:,slice_num+1,:))));
     axis off
     hold on
     if ~isempty(overlay)
        p2=imagesc(rot90(squeeze(overlay_img(:,slice_num+1,:))/overlay.max*mri.max),[mri.min mri.max]);
        alpha(p2,.5)
        axis off
     end 
     p22=imagesc(rot90(squeeze(mri.mask(:,slice_num+1,:))/mri.maskmax*mri.max),[mri.min mri.max]);
     alpha(p22,.5)
     hold off

     txt=findobj('Tag','di_AP');
     set(txt,'String',num2str(slice_num)); 

% --- Executes during object creation, after setting all properties.
function i_AP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function i_FH_Callback(hObject, eventdata, handles)
% hObject    handle to i_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

     val=get(hObject,'Value');       
     h=findobj('Tag','openfile');
     mri = get(h,'UserData'); 
       
     ho=findobj('Tag','overlay');
     overlay = get(ho,'UserData'); 
     if ~isempty(overlay)
        hlb=findobj('Tag','lb_fROI');
         hlb_ID=get(hlb,'Value');
         %overlay.fROI.name(hlb_ID)
         overlay_img=int16(overlay.img==overlay.fROI.val(hlb_ID)); 
     end
     slice_num=round((size(mri.img,3)-1)*val);
     axes(handles.FH)
     imagesc(rot90(mri.img(:,:,slice_num+1)));
     axis off
     hold on
     if ~isempty(overlay)
        p3=imagesc(rot90(overlay_img(:,:,slice_num+1)/overlay.max*mri.max),[mri.min mri.max]);
        alpha(p3,.5)
        axis off
     end
     p33=imagesc(rot90(mri.mask(:,:,slice_num+1)/mri.maskmax*mri.max),[mri.min mri.max]);
     alpha(p33,.5)
     hold off
     
     txt=findobj('Tag','di_FH');
     set(txt,'String',num2str(slice_num)); 

% --- Executes during object creation, after setting all properties.
function i_FH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function s_LR_Callback(hObject, eventdata, handles)
% hObject    handle to s_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function s_LR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function s_AP_Callback(hObject, eventdata, handles)
% hObject    handle to s_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function s_AP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function s_FH_Callback(hObject, eventdata, handles)
% hObject    handle to s_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function s_FH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function c_LR_Callback(hObject, eventdata, handles)
% hObject    handle to c_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function c_LR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function c_AP_Callback(hObject, eventdata, handles)
% hObject    handle to c_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function c_AP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function c_FH_Callback(hObject, eventdata, handles)
% hObject    handle to c_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function c_FH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a_LR_Callback(hObject, eventdata, handles)
% hObject    handle to a_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function a_LR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a_AP_Callback(hObject, eventdata, handles)
% hObject    handle to a_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function a_AP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function a_FH_Callback(hObject, eventdata, handles)
% hObject    handle to a_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function a_FH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function openfile_Callback(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
    % reset to default values 
    cla
    hlb=findobj('Tag','lb_fROI');
    set(hlb,'String','None','Value',1);
    tags_dd={'ds_LR','ds_AP','ds_FH','dc_LR','dc_AP','dc_FH','da_LR','da_AP','da_FH'};
    for s=1:3
        txt=findobj('Tag',tags_dd{s});
        set(txt,'Value', 20, 'String', '20'); 
    end
    for s=4:9
        txt=findobj('Tag',tags_dd{s});
        set(txt,'Value', 0, 'String', '0'); 
    end
    
    % read in data  
    [filename,filepath]=uigetfile({'*.*','.gz'},'Select Standard Brain Atalas');
    cd(filepath);
    
    mri_standard=load_nii(filename);
    mri_size=size(mri_standard.img);
    mri_size
    max_val=max(reshape(mri_standard.img,1,[]));
    min_val=min(reshape(mri_standard.img,1,[]));    
    
    % create voxel mask 
    msvoi_size=[20 20 20];
    c=0;
    for x=[-1, 1]
        for y=[-1, 1]
            for z=[-1, 1]
                c=c+1;
                corner = 0.5*msvoi_size.*[x y z];
                msvoi_corners(c,:)=corner;
            end
        end
    end
    msvoi_centre=[0 0 0];
    mask = mri_createMask(mri_size, mri_size.*mri_standard.hdr.dime.pixdim(2:4), mri_standard.hdr.dime.pixdim(2:4), msvoi_corners, msvoi_centre,1);
    mask = int16(mask);
    max_mask=max(reshape(mask,1,[]));
    min_mask=min(reshape(mask,1,[]));
    
    % set UserData for data sharing across callback functions   
    set(hObject,'UserData',struct('filename',[filepath,filename],'img',mri_standard.img,'size',mri_size,'pix',mri_standard.hdr.dime.pixdim(2:4),'max',max_val,'min',min_val,'mask',mask,'maskmax',max_mask,'svoi_centre',msvoi_centre,'svoi_corners',msvoi_corners));
    
    % update image display windows 
    axes(handles.LR)
    colormap gray
    imagesc(rot90(squeeze(mri_standard.img(round(mri_size(1)/2),:,:))),[min_val max_val]);
    axis off
    hold on
    p11=imagesc(rot90(squeeze(mask(round(mri_size(1)/2),:,:))/max_mask*max_val),[min_val max_val]);
    alpha(p11,.5)
    hold off 
    
    axes(handles.AP)
    colormap gray
    imagesc(rot90(squeeze(mri_standard.img(:,round(mri_size(2)/2),:))),[min_val max_val]);    
    axis off
    hold on
    p22=imagesc(rot90(squeeze(mask(:,round(mri_size(2)/2),:))/max_mask*max_val),[min_val max_val]);
    alpha(p22,.5)
    hold off 
     
    axes(handles.FH)   
    colormap gray
    imagesc(rot90(mri_standard.img(:,:,round(mri_size(3)/2))),[min_val max_val]); 
    axis off
    hold on
    p33=imagesc(rot90(mask(:,:,round(mri_size(3)/2))/max_mask*max_val),[min_val max_val]);
    alpha(p33,.5)
    hold off 
    
    % update slider position
    h1=findobj('Tag','i_LR');
    set(h1,'Value',1/(mri_size(1)-1)*(round(mri_size(1)/2)-1),'SliderStep',[1/(mri_size(1)-1) 1/(mri_size(1)-1)]); 
    h2=findobj('Tag','i_AP');
    set(h2,'Value',1/(mri_size(2)-1)*(round(mri_size(2)/2)-1),'SliderStep',[1/(mri_size(2)-1) 1/(mri_size(2)-1)]); 
    h3=findobj('Tag','i_FH');
    set(h3,'Value',1/(mri_size(3)-1)*(round(mri_size(3)/2)-1),'SliderStep',[1/(mri_size(3)-1) 1/(mri_size(3)-1)]); 
    % update slice number above slider 
    tags={'di_LR','di_AP','di_FH'};
    for s=1:3
        val=1/(mri_size(s)-1)*(round(mri_size(s)/2)-1);
        slice_num=round((mri_size(s)-1)*val);
        txt=findobj('Tag',tags{s});
        set(txt,'String',num2str(slice_num)); 
    end
    
% --------------------------------------------------------------------
function overlay_Callback(hObject, eventdata, handles)
% hObject    handle to overlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [filename,filepath]=uigetfile({'*.*','.gz'},'Select Cortex Atalas');
    cd(filepath);
    
    mri_overlay=load_nii(filename);
      
    [fROI_info.val fROI_info.name] = textread([strtok(filename,'.'),'.txt'],'%d\t%s'); % load in labelling information 
    hlb=findobj('Tag','lb_fROI');
    set(hlb,'String',fROI_info.name);
    
    mri_overlay.img=int16(mri_overlay.img);
    set(hlb,'Value',1);
    overlay_img=int16(mri_overlay.img==fROI_info.val(1));%initial value is the first in the list 
    max_overlay=max(reshape(overlay_img,1,[]));
    min_overlay=min(reshape(overlay_img,1,[]));
    overlay_size=size(overlay_img);
     
    set(hObject,'UserData',struct('img',mri_overlay.img,'size',overlay_size,'max',max_overlay,'min',min_overlay,'fROI',fROI_info)); 
        
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    
    if (all(overlay_size==mri.size))
        tags={'di_LR','di_AP','di_FH'};
        for s=1:3
            txt=findobj('Tag',tags{s});
            slice_num(s)=str2num(get(txt,'String'));
        end
        % update image display windows 
        axes(handles.LR)
        hold on 
        p1=imagesc(rot90(squeeze(overlay_img(slice_num(1)+1,:,:))/max_overlay*mri.max),[mri.min mri.max]);
        alpha(p1,.5)
        axis off
        p11=imagesc(rot90(squeeze(mri.mask(slice_num(1)+1,:,:))/mri.maskmax*mri.max),[mri.min mri.max]);
        alpha(p11,.5)
        hold off   

        axes(handles.AP)
        hold on 
        p2=imagesc(rot90(squeeze(overlay_img(:,slice_num(2)+1,:))/max_overlay*mri.max),[mri.min mri.max]);    
        alpha(p2,.5)
        axis off
        p22=imagesc(rot90(squeeze(mri.mask(:,slice_num(2)+1,:))/mri.maskmax*mri.max),[mri.min mri.max]);
        alpha(p22,.5)
        hold off

        axes(handles.FH)   
        hold on 
        p3=imagesc(rot90(overlay_img(:,:,slice_num(3)+1))/max_overlay*mri.max,[mri.min mri.max]); 
        alpha(p3,.5)
        axis off
        p33=imagesc(rot90(mri.mask(:,:,slice_num(3)+1)/mri.maskmax*mri.max),[mri.min mri.max]);
        alpha(p33,.5)
        hold off
        
    else
         error('Error. \nOverlay image size does no match Background image size!')
    end
    

% --- Executes on selection change in lb_fROI.
function lb_fROI_Callback(hObject, eventdata, handles)
% hObject    handle to lb_fROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_fROI contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_fROI
  
   % update all the display windows
    h=findobj('Tag','openfile');
    mri = get(h,'UserData'); 
    
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData'); 
    
    hlb_ID=get(hObject,'Value');
    overlay_img=int16(overlay.img==overlay.fROI.val(hlb_ID)); 
    
    % LR window 
     hs=findobj('Tag','i_LR');
     val=get(hs,'Value');    
       
     slice_num=round((size(mri.img,1)-1)*val);
     axes(handles.LR)
     imagesc(rot90(squeeze(mri.img(slice_num+1,:,:))));
     axis off
     hold on
     p1=imagesc(rot90(squeeze(overlay_img(slice_num+1,:,:))/overlay.max*mri.max),[mri.min mri.max]);
     alpha(p1,.5)
     axis off
     p11=imagesc(rot90(squeeze(mri.mask(slice_num+1,:,:))/mri.maskmax*mri.max),[mri.min mri.max]);
     alpha(p11,.5)
     hold off
     
    % AP window 
     hs=findobj('Tag','i_AP');
     val=get(hs,'Value'); 
       
     slice_num=round((size(mri.img,2)-1)*val);
     axes(handles.AP)
     imagesc(rot90(squeeze(mri.img(:,slice_num+1,:))));
     axis off
     hold on
     p2=imagesc(rot90(squeeze(overlay_img(:,slice_num+1,:))/overlay.max*mri.max),[mri.min mri.max]);
     alpha(p2,.5)
     axis off
     p22=imagesc(rot90(squeeze(mri.mask(:,slice_num+1,:))/mri.maskmax*mri.max),[mri.min mri.max]);
     alpha(p22,.5)
     hold off
     
     % FH window 
     hs=findobj('Tag','i_FH');
     val=get(hs,'Value');       
     
     slice_num=round((size(mri.img,3)-1)*val);
     axes(handles.FH)
     imagesc(rot90(mri.img(:,:,slice_num+1)));
     axis off
     hold on
     p3=imagesc(rot90(overlay_img(:,:,slice_num+1)/overlay.max*mri.max),[mri.min mri.max]);
     alpha(p3,.5)
     axis off
     p33=imagesc(rot90(mri.mask(:,:,slice_num+1)/mri.maskmax*mri.max),[mri.min mri.max]);
     alpha(p33,.5)
     hold off


% --- Executes during object creation, after setting all properties.
function lb_fROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_fROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ds_LR_Callback(hObject, eventdata, handles)
% hObject    handle to ds_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ds_LR as text
%        str2double(get(hObject,'String')) returns contents of ds_LR as a double
    % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);
    

     

% --- Executes during object creation, after setting all properties.
function ds_LR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ds_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ds_AP_Callback(hObject, eventdata, handles)
% hObject    handle to ds_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ds_AP as text
%        str2double(get(hObject,'String')) returns contents of ds_AP as a double
    % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);


% --- Executes during object creation, after setting all properties.
function ds_AP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ds_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ds_FH_Callback(hObject, eventdata, handles)
% hObject    handle to ds_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ds_FH as text
%        str2double(get(hObject,'String')) returns contents of ds_FH as a double
    % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);

% --- Executes during object creation, after setting all properties.
function ds_FH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ds_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dc_LR_Callback(hObject, eventdata, handles)
% hObject    handle to dc_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dc_LR as text
%        str2double(get(hObject,'String')) returns contents of dc_LR as a double

    % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);


% --- Executes during object creation, after setting all properties.
function dc_LR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dc_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dc_AP_Callback(hObject, eventdata, handles)
% hObject    handle to dc_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dc_AP as text
%        str2double(get(hObject,'String')) returns contents of dc_AP as a double
     % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);

% --- Executes during object creation, after setting all properties.
function dc_AP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dc_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dc_FH_Callback(hObject, eventdata, handles)
% hObject    handle to dc_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dc_FH as text
%        str2double(get(hObject,'String')) returns contents of dc_FH as a double
     % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);
   


% --- Executes during object creation, after setting all properties.
function dc_FH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dc_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function da_LR_Callback(hObject, eventdata, handles)
% hObject    handle to da_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of da_LR as text
%        str2double(get(hObject,'String')) returns contents of da_LR as a double
     % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);

% --- Executes during object creation, after setting all properties.
function da_LR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to da_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function da_AP_Callback(hObject, eventdata, handles)
% hObject    handle to da_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of da_AP as text
%        str2double(get(hObject,'String')) returns contents of da_AP as a double
    % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
   [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);

% --- Executes during object creation, after setting all properties.
function da_AP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to da_AP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function da_FH_Callback(hObject, eventdata, handles)
% hObject    handle to da_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of da_FH as text
%        str2double(get(hObject,'String')) returns contents of da_FH as a double
    % update voxel mask 
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    [mask, msvoi_centre, msvoi_corners] = update_mask(mri);
    mri.mask = mask;
    mri.svoi_centre = msvoi_centre;
    mri.svoi_corners = msvoi_corners;
    set(h,'UserData',mri);
    
    % update display windows
    ho=findobj('Tag','overlay');
    overlay = get(ho,'UserData');
    
    update_disp_all(handles,mri,overlay);

% --- Executes during object creation, after setting all properties.
function da_FH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to da_FH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [mask, msvoi_centre, msvoi_corners] = update_mask(mri)
    
    h1=findobj('Tag','ds_LR');
    s_LR = get(h1,'String');
    h2=findobj('Tag','ds_AP');
    s_AP = get(h2,'String');
    h3=findobj('Tag','ds_FH');
    s_FH = get(h3,'String');
    
    h1=findobj('Tag','dc_LR');
    c_LR = get(h1,'String');
    h2=findobj('Tag','dc_AP');
    c_AP = get(h2,'String');
    h3=findobj('Tag','dc_FH');
    c_FH = get(h3,'String');
    
    h1=findobj('Tag','da_LR');
    a_LR = get(h1,'String');
    h2=findobj('Tag','da_AP');
    a_AP = get(h2,'String');
    h3=findobj('Tag','da_FH');
    a_FH = get(h3,'String');
    
    % rotation function
    rot_rl = @(ang)[1 0 0;0 cos(ang) -sin(ang);0 sin(ang) cos(ang)];
    rot_ap = @(ang)[cos(ang) 0 sin(ang);0 1 0;-sin(ang) 0 cos(ang)];
    rot_fh = @(ang)[cos(ang) -sin(ang) 0;sin(ang) cos(ang) 0;0 0 1];

    msvoi_size=[str2num(s_LR) str2num(s_AP) str2num(s_FH)];
    msvoi_centre=[str2num(c_LR) str2num(c_AP) str2num(c_FH)];
    msvoi_angulation = [str2num(a_LR) str2num(a_AP) str2num(a_FH)]/180*pi;
    c=0;
    for x=[-1, 1]
        for y=[-1, 1]
            for z=[-1, 1]
                c=c+1;
                corner = 0.5*msvoi_size.*[x y z];
                msvoi_corners(c,:)=corner;
            end
        end
    end
    msvoi_corners=(rot_fh(msvoi_angulation(3))*msvoi_corners')';
    msvoi_corners=(rot_ap(msvoi_angulation(2))*msvoi_corners')';
    msvoi_corners=(rot_rl(msvoi_angulation(1))*msvoi_corners')';

    msvoi_corners=msvoi_corners+repmat(msvoi_centre,8,1);
    
    mask = mri_createMask(mri.size, mri.size.*mri.pix, mri.pix, msvoi_corners, msvoi_centre,1);
    mask = int16(mask);
    

function update_disp_all(handles,mri,overlay)
    if ~isempty(overlay) 
         hlb=findobj('Tag','lb_fROI');
         hlb_ID=get(hlb,'Value');
         overlay_img=int16(overlay.img==overlay.fROI.val(hlb_ID)); 
    end
    
    % LR window 
     hs=findobj('Tag','i_LR');
     val=get(hs,'Value');    
       
     slice_num=round((size(mri.img,1)-1)*val);
     axes(handles.LR)
     imagesc(rot90(squeeze(mri.img(slice_num+1,:,:))));
     axis off
     hold on
     if ~isempty(overlay)
        p1=imagesc(rot90(squeeze(overlay_img(slice_num+1,:,:))/overlay.max*mri.max),[mri.min mri.max]);
        alpha(p1,.5)
        axis off
     end
     p11=imagesc(rot90(squeeze(mri.mask(slice_num+1,:,:))/mri.maskmax*mri.max),[mri.min mri.max]);
     alpha(p11,.5)
     hold off
    
    % AP window
    hs=findobj('Tag','i_AP');
    val=get(hs,'Value');
    
    slice_num=round((size(mri.img,2)-1)*val);
    axes(handles.AP)
    imagesc(rot90(squeeze(mri.img(:,slice_num+1,:))));
    axis off
    hold on
    if ~isempty(overlay)
        p2=imagesc(rot90(squeeze(overlay_img(:,slice_num+1,:))/overlay.max*mri.max),[mri.min mri.max]);
        alpha(p2,.5)
        axis off
    end
    p22=imagesc(rot90(squeeze(mri.mask(:,slice_num+1,:))/mri.maskmax*mri.max),[mri.min mri.max]);
    alpha(p22,.5)
    hold off
    
    % FH window
    hs=findobj('Tag','i_FH');
    val=get(hs,'Value');
    
    slice_num=round((size(mri.img,3)-1)*val);
    axes(handles.FH)
    imagesc(rot90(mri.img(:,:,slice_num+1)));
    axis off
    hold on
    if ~isempty(overlay)
        p3=imagesc(rot90(overlay_img(:,:,slice_num+1)/overlay.max*mri.max),[mri.min mri.max]);
        alpha(p3,.5)
        axis off
    end
    p33=imagesc(rot90(mri.mask(:,:,slice_num+1)/mri.maskmax*mri.max),[mri.min mri.max]);
    alpha(p33,.5)
    hold off


% --------------------------------------------------------------------
function save_svoi_Callback(hObject, eventdata, handles)
% hObject    handle to save_svoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h=findobj('Tag','openfile');
    mri = get(h,'UserData');
    mask=load_nii(mri.filename);
    mask.img=mri.mask;
    
    %the centre of image is at back bottom left corner (for FSL display)
    msvoi_location=[mri.svoi_centre; mri.svoi_corners]+repmat(mri.size/2,9,1);
    msvoi_location(:,2)=repmat(mri.size(2),9,1)-msvoi_location(:,2);
    msvoi_location
     
    [FileName,PathName] = uiputfile('.nii.gz');
    save_nii(mask,[PathName,FileName]);
    [~,name,~] = fileparts(FileName); 
    dlmwrite([PathName,name,'.txt'],msvoi_location,'delimiter','\t');

    
    
    