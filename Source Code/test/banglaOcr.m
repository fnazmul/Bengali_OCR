function varargout = banglaOcr(varargin)
% BANGLAOCR M-file for banglaOcr.fig
%      BANGLAOCR, by itself, creates a new BANGLAOCR or raises the existing
%      singleton*.
%
%      H = BANGLAOCR returns the handle to a new BANGLAOCR or the handle to
%      the existing singleton*.
%
%      BANGLAOCR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BANGLAOCR.M with the given input arguments.
%
%      BANGLAOCR('Property','Value',...) creates a new BANGLAOCR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before banglaOcr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to banglaOcr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help banglaOcr

% Last Modified by GUIDE v2.5 26-Jul-2008 04:16:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @banglaOcr_OpeningFcn, ...
                   'gui_OutputFcn',  @banglaOcr_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);


if nargin && ischar(varargin{1})
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %global W_Width W_Height
    now_path=cd;
    cd ('..\data');        
    pathname=cd;
    cd(now_path)
    filename='\default.mat';
    global Load_Data_Name
    Load_Data_Name=[pathname filename];
    
    %s = get(0,'ScreenSize');
    %W_Width=s(3);
    %W_Height=s(4);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before banglaOcr is made visible.
function banglaOcr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to banglaOcr (see VARARGIN)

set(handles.loadText,'Visible','off');
set(handles.waitText,'Visible','off');

%{
set(handles.stepButton,'Visible','off');

set(handles.stepChar,'Visible','off');    
set(handles.stEqual,'Visible','off');    
set(handles.stepYes,'Visible','off');    
set(handles.stepNo,'Visible','off');
set(handles.stepNext,'Visible','off');
%}
% Choose default command line output for banglaOcr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes banglaOcr wait for user response (see UIRESUME)
% uiwait(handles.start);


% --- Outputs from this function are returned to the command line.
function varargout = banglaOcr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImage.
function loadImage_Callback(hObject, eventdata, handles)
% hObject    handle to loadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global binImg %W_Height W_Width 

set(handles.pressText,'Visible','off');
drawnow 
 
now_path=cd;
cd ('..\data');        
[filename,pathname] = uigetfile({
    '*.bmp;*.jpeg;*.gif','All Picture Files';...
        '*.bmp','Bitmap Files (*.bmp)';...
        '*.jpg','Jpeg Files (*.jpg)';...
        '*.gif','GIF Files (*.gif)';...
        %            '*.tif','TIFF Files (*.tif)';...
    '*.*','All Files (*.*)'},...
    'Load Image File');
cd(now_path);

 


if filename ~= 0		
        
     s = get(handles.panel1,'Position');    
     w_max= s(3) - 12;  % W_Width*0.36;%-10
     h_max= s(4) - 20; %W_Height*0.60;%-W_Height*.2
     
     % clear the input axes and change to default position
     set(handles.oInput,'Position',[6  4 w_max h_max+12]);
     cla(handles.oInput);
          
     set(handles.loadText,'Visible','on');
     drawnow 
   
    
    % Read the image and convert to intensity 
    temp_image=imread([pathname filename]);
    temp_image = imresize(temp_image, [1024, NaN]);    
    level = 0.9;%graythresh(temp_image);      
    cImage=im2bw(temp_image,level);
    binImg = cImage;
    
    clear temp_image;
    
    [h,w] = size(cImage);
    [im_width,im_height] = fit_im(w_max,h_max,w,h);
    
    %{
    temp_image = imresize(cImage, [NaN,w_max]);
    cImage = temp_image;
    [im_height,im_width] = size(cImage);
    %}
    extra_w=w_max-im_width;
    extra_h=h_max-im_height;    
     
    set(handles.oInput,'Position',[5+extra_w/2  5+extra_h/2 im_width im_height]);
    axes(handles.oInput);
    colormap(gray(2));
    image(cImage);
    set(handles.oInput,'XTick',[],'YTick',[])
    %set(handles.pressText,'Visible','off');
    set(handles.loadText,'Visible','off');
    set(handles.oInput,'Visible','on');
    %set(fig,'Pointer','arrow');

else
    set(handles.pressText,'Visible','off');
    drawnow 
end
%{
    val=get(handles.fullText,'Max');
    set(handles.fullText,'Value',val);
    val=get(handles.stepButton,'Min');        
    set(handles.stepButton,'Value',val);
  %}  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{
% --- Executes on button press in fullText.
function fullText_Callback(hObject, eventdata, handles)
% hObject    handle to fullText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fullText
 val=get(handles.fullText,'Max');
 set(handles.fullText,'Value',val);
 val=get(handles.stepButton,'Min');        
 set(handles.stepButton,'Value',val);
 
 set(handles.stepChar,'Visible','off');    
 set(handles.stEqual,'Visible','off');    
 set(handles.stepYes,'Visible','off');    
 set(handles.stepNo,'Visible','off');
 set(handles.stepNext,'Visible','off');
 drawnow;


% --- Executes on button press in stepButton.
function stepButton_Callback(hObject, eventdata, handles)
% hObject    handle to stepButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stepButton
val=get(handles.fullText,'Min');
set(handles.fullText,'Value',val);
val=get(handles.stepButton,'Max');        
set(handles.stepButton,'Value',val);
set(handles.stepChar,'Visible','on');    
set(handles.stepChar,'Visible','on');    
set(handles.stepYes,'Visible','on');    
set(handles.stepNo,'Visible','on');
set(handles.stepNext,'Visible','on');
drawnow;

% --- Executes on button press in stepYes.
function stepYes_Callback(hObject, eventdata, handles)
% hObject    handle to stepYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stepYes
val=get(handles.stepYes,'Max');
set(handles.stepYes,'Value',val);
val=get(handles.stepNo,'Min');        
set(handles.stepNo,'Value',val);


% --- Executes on button press in stepNo.
function stepNo_Callback(hObject, eventdata, handles)
% hObject    handle to stepNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stepNo
val=get(handles.stepNo,'Max');
set(handles.stepNo,'Value',val);
val=get(handles.stepYes,'Min');        
set(handles.stepYes,'Value',val);


% --- Executes on button press in stepNext.
function stepNext_Callback(hObject, eventdata, handles)
% hObject    handle to stepNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%}

% --- Executes on button press in startOcr.
function startOcr_Callback(hObject, eventdata, handles)
% hObject    handle to startOcr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.waitText,'Visible','on');
drawnow;

%global finalOutput;

set(handles.oOutput,'Value',[]);
ocrEngine(handles);
%set(handles.waitText,'Visible','off');
%set(handles.oOutput,'String',finalOutput);   



% --- Executes on button press in msWord.
function msWord_Callback(hObject, eventdata, handles)
% hObject    handle to msWord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global finalOutput lineCount;
send2Word();


% --- Executes on button press in exitWindow.
function exitWindow_Callback(hObject, eventdata, handles)
% hObject    handle to exitWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on selection change in outputText.
function oOutput_Callback(hObject, eventdata, handles)
% hObject    handle to outputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns outputText contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputText


% --- Executes on mouse press over axes background.
function inputText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to inputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%{
% --- Executes on mouse press over axes background.
function stepChar_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to stepChar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%}

function [im_width,im_height] = fit_im(w_max,h_max,w,h)
% Resize the image accordingly

w_ratio = w/w_max;
h_ratio = h/h_max;

if (w_ratio > 1) || (h_ratio > 1)
    if w_ratio > h_ratio
        im_width = w_max;
        im_height = h/w_ratio;
    else
        im_height = h_max;
        im_width = w/h_ratio;			
    end
else
    im_width = w;
    im_height = h;
end


% --- Executes on button press in Zoom.
function Zoom_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on;


