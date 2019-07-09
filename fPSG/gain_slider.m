function varargout = gain_slider(varargin)
% GAIN_SLIDER M-file for gain_slider.fig
%      GAIN_SLIDER, by itself, creates a new GAIN_SLIDER or raises the existing
%      singleton*.
%
%      H = GAIN_SLIDER returns the handle to a new GAIN_SLIDER or the handle to
%      the existing singleton*.
%
%      GAIN_SLIDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAIN_SLIDER.M with the given input arguments.
%
%      GAIN_SLIDER('Property','Value',...) creates a new GAIN_SLIDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gain_slider_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gain_slider_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gain_slider

% Last Modified by GUIDE v2.5 08-Mar-2006 15:06:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gain_slider_OpeningFcn, ...
                   'gui_OutputFcn',  @gain_slider_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before gain_slider is made visible.
function gain_slider_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gain_slider (see VARARGIN)

% Choose default command line output for gain_slider
handles.output = hObject;

%Initialize
handles.button_output = 1;
handles.quit = 0;

%Parse varargin
if ~isempty(varargin)
    slider1 = handles.slider1;     %get the slider's handle
    for i = 1:size(varargin,2)
        if ischar(varargin{1,i})
            switch varargin{1,i}
                case 'max'
                    set(slider1,'Max',varargin{1,i+1});
                case 'min'
                    set(slider1,'Min',varargin{1,i+1});
                case 'value'
                    set(slider1,'Value',varargin{1,i+1});
            end
        end
    end
end

%Set a new default slider value
%slider1 = handles.slider1;     %This gets slider1's handle
%set(slider1,'Value',78);       %This sets the new start value for slider1

%Set a new location for the slider
%figure1 = handles.figure1;          %get figure1's handle
%pos = get(figure1,'position')       %get the default location
%new_pos = [20 35 pos(1,3) pos(1,4)] %create the new location
%set(figure1,'position',new_pos);    %set the figure to the new location

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gain_slider wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = gain_slider_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.button_output;

q = handles.quit;
if q==1
    delete(handles.figure1);
end

% --- Executes on gain_slider movement.
function slider1_Callback(hObject, eventdata, handles)
gain_slider_value = get(hObject,'Value');
handles.output = gain_slider_value;
guidata(hObject, handles);
uiresume;
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of gain_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of gain_slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: gain_slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%If you want to reset Values before the GUI is displayed you want to do it
%here, but the caviate is that varargin does not work in, so no user input
%here.  So what is the use?  ???!!!
%set(hObject,'Value',0.5);

%handles.slider = hObject       %OK, this is how you do it, you need the handle of the particular object you want to change
%guidata(hObject,handles);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.button_output = 0;
    handles.output = 0;
    handles.quit = 1;
    guidata(hObject, handles);
    uiresume;
%    delete(handles.figure1)

