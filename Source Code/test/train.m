function varargout = train(varargin)
% TRAIN M-file for train.fig
%      TRAIN, by itself, creates a new TRAIN or raises the existing
%      singleton*.
%
%      H = TRAIN returns the handle to a new TRAIN or the handle to
%      the existing singleton*.
%
%      TRAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAIN.M with the given input arguments.
%
%      TRAIN('Property','Value',...) creates a new TRAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before train_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to train_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help train

% Last Modified by GUIDE v2.5 21-Jul-2008 23:24:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @train_OpeningFcn, ...
                   'gui_OutputFcn',  @train_OutputFcn, ...
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before train is made visible.
function train_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to train (see VARARGIN)

set(handles.loadText,'Visible','off');

% Choose default command line output for train
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes train wait for user response (see UIRESUME)
% uiwait(handles.start);


% --- Outputs from this function are returned to the command line.
function varargout = train_OutputFcn(hObject, eventdata, handles) 
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
global binImg currentChar;
currentChar = 0;


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
    % Read the image and convert to intensity 
    
    set(handles.loadText,'Visible','on');
    drawnow
    
    temp_image=imread([pathname filename]);
    temp_image = imresize(temp_image, [1024, NaN]);    
    level = graythresh(temp_image);      
    cImage=im2bw(temp_image,level);
    binImg = cImage;
    
    clear temp_image;
    
    s = get(handles.panel1,'Position');
    
    w_max= s(3) - 10;  % W_Width*0.36;%-10
    h_max= s(4) - 20; %W_Height*0.60;%-W_Height*.2
    
    temp_image = imresize(cImage, [NaN,w_max]);
    cImage = temp_image;
    [im_height,im_width] = size(cImage);
    
    extra_w=w_max-im_width;
    extra_h=h_max-im_height;    
     
    set(handles.oInput,'Position',[5+extra_w/2  5+extra_h/2 im_width im_height]);
    axes(handles.oInput);
    colormap(gray(2));
    imshow(cImage);
    set(handles.oInput,'XTick',[],'YTick',[])
    
    set(handles.loadText,'Visible','off');
    set(handles.oInput,'Visible','on');    
else
    set(handles.pressText,'Visible','on');
    
end

% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global net1 net2 net3 net4 net5 net6 net7;

binSeg();
createAllNets();
load neuralNets;


%waitfor(handles.next,'Value',1.0);
%set(handles.next,'Value',0.0);



% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.next,'Value',0.0);
    global allChars currentChar;

    num = size(allChars,3);
    currentChar = currentChar+1;
    if(currentChar > num)
        currentChar = num;
    end
    
    img = allChars(:,:,currentChar);    
    img = imresize(img, [80,80]);    
    [im_height,im_width] = size(img);         
   
    set(handles.stepChar,'Position',[5,6,im_width im_height]);
    axes(handles.stepChar);        
      
    imshow(img);   
    set(handles.stepChar,'XTick',[],'YTick',[])
        
    %waitfor(handles.next,'Value',1.0);
    %set(handles.next,'Value',0.0);  


% --- Executes on button press in prev.
function prev_Callback(hObject, eventdata, handles)
% hObject    handle to prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global allChars currentChar;

    currentChar = currentChar-1;
    if(currentChar < 1)
        currentChar = 1;
    end
    
    img = allChars(:,:,currentChar);
    
    img = imresize(img, [80,80]);    
    [im_height,im_width] = size(img);         
   
    set(handles.stepChar,'Position',[5,6,im_width im_height]);
    axes(handles.stepChar);     
    imshow(img);   
    set(handles.stepChar,'XTick',[],'YTick',[])


    


% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global allChars currentChar;
global net1 net2 net3 net4 net5 net6 net7;

load trainingChars;

str = getLabel(handles.editBox);

if(str)
    
    stats = findFeatures(allChars(:,:,currentChar)); 
    %figure, imshow(allChars(:,:,currentChar));
    
    tmp = [stats.matra, stats.Lbar, stats.Rbar, stats.centroid(1),stats.centroid(2),...
           stats.eNum, stats.eccent, stats.hRatio, stats.vRatio,...
           stats.parts(1,1:4), stats.parts(2,1:4), stats.parts(3,1:4), stats.parts(4,1:4),...
           stats.HPSkewness, stats.VPSkewness, stats.HPKurtosis, stats.VPKurtosis]';
        
    alphabet = tmp; 
    
    % select which net
    if(stats.matra == 1)
        %netNum = 1
        [h w] = size(net1Chars);
        targets = zeros(w,1);
    
        num = str2num(str);
        indx = find(net1Chars == num);    
        targets(indx) = 1;       
        
        [net1] = train(net1,alphabet,targets);
    else
        %netNum = 2
        [h w] = size(net2Chars);
        targets = zeros(w,1);
    
        num = str2num(str);
        indx = find(net2Chars == num);    
        targets(indx) = 1;
    
        [net2] = train(net2,alphabet,targets);
    end
    
    
    if(stats.Lbar == 1)
        %netNum = 3
        [h w] = size(net3Chars);
        targets = zeros(w,1);
    
        num = str2num(str);
        indx = find(net3Chars == num);    
        targets(indx) = 1;
    
        [net3] = train(net3,alphabet,targets);
    elseif(stats.Rbar == 1)
        %netNum = 4
        [h w] = size(net4Chars);
        targets = zeros(w,1);
    
        num = str2num(str);
        indx = find(net4Chars == num);    
        targets(indx) = 1;
        
        [net4] = train(net4,alphabet,targets);
    else
        %netNum = 5
        [h w] = size(net5Chars);
        targets = zeros(w,1);
    
        num = str2num(str);
        indx = find(net5Chars == num);    
        targets(indx) = 1;
    
        [net5] = train(net5,alphabet,targets);
    end
    
    
    if(stats.eNum <= 0)
        %netNum = 6
        [h w] = size(net6Chars);
        targets = zeros(w,1);
    
        num = str2num(str);
        indx = find(net6Chars == num);    
        targets(indx) = 1;
        
        [net6] = train(net6,alphabet,targets);
    else
        %netNum = 7
        [h w] = size(net7Chars);
        targets = zeros(w,1);
    
        num = str2num(str);
        indx = find(net7Chars == num);    
        targets(indx) = 1;
    
        [net7] = train(net7,alphabet,targets);
    end
    
end
%waitfor(handles.next,'Value',1.0);

% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global net1 net2 net3 net4 net5 net6 net7;

[filename,pathname] = uigetfile({'*.mat','Data files'});
	
if filename ~= 0		
	% Clear the old data
	clear net1 net2 net3 net4 net5 net6 net7				
	load(filename);		
end



% --- Executes on button press in saveData.
function saveData_Callback(hObject, eventdata, handles)
% hObject    handle to saveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net1 net2 net3 net4 net5 net6 net7;

[filename,pathname] = uiputfile({'*.mat','Data files'});
if filename ~= 0		
    % Save the stats to a mat file%
    save(filename, 'net1', 'net2', 'net3', 'net4', 'net5', 'net6', 'net7');
end



% --- Executes on button press in exitWindow.
function exitWindow_Callback(hObject, eventdata, handles)
% hObject    handle to exitWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on mouse press over axes background.
function inputText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to inputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function stepChar_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to stepChar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    

function editBox_Callback(hObject, eventdata, handles)
% hObject    handle to editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBox as text
%        str2double(get(hObject,'String')) returns contents of editBox as a double


% --- Executes during object creation, after setting all properties.
function editBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c = getLabel(edit_box)
% Get the class label from the edit box

%get() Retrieve object properties
c = get(edit_box,'String');
set(edit_box,'String',[])

%{
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

%}



