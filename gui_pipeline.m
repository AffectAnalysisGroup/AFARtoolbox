function varargout = gui_pipeline(varargin)
% GUI_PIPELINE MATLAB code for gui_pipeline.fig
%      GUI_PIPELINE, by itself, creates a new GUI_PIPELINE or raises the existing
%      singleton*.
%
%      H = GUI_PIPELINE returns the handle to a new GUI_PIPELINE or the handle to
%      the existing singleton*.
%
%      GUI_PIPELINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PIPELINE.M with the given input arguments.
%
%      GUI_PIPELINE('Property','Value',...) creates a new GUI_PIPELINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_pipeline_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_pipeline_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_pipeline

% Last Modified by GUIDE v2.5 16-Jan-2019 12:52:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_pipeline_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_pipeline_OutputFcn, ...
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


% --- Executes just before gui_pipeline is made visible.
function gui_pipeline_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_pipeline (see VARARGIN)

% Choose default command line output for gui_pipeline
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_pipeline wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_pipeline_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function TrackDirTxt_Callback(hObject, eventdata, handles)
% hObject    handle to TrackDirTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TrackDirTxt as text
%        str2double(get(hObject,'String')) returns contents of TrackDirTxt as a double


% --- Executes during object creation, after setting all properties.
function TrackDirTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrackDirTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TrackDirBtn.
function TrackDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to TrackDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    trackDir = uigetdir;
    if isfolder(trackDir)
        set(handles.TrackDirTxt,'String',trackDir);
    end


% --- Executes on button press in OutDirBtn.
function OutDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to OutDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    outDir = uigetdir;
    if isfolder(outDir)
        set(handles.OutDirTxt,'String',outDir);
    end



function OutDirTxt_Callback(hObject, eventdata, handles)
% hObject    handle to OutDirTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutDirTxt as text
%        str2double(get(hObject,'String')) returns contents of OutDirTxt as a double


% --- Executes during object creation, after setting all properties.
function OutDirTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutDirTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on TrackDirTxt and none of its controls.
function TrackDirTxt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to TrackDirTxt (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over OutDirTxt.
function OutDirTxt_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OutDirTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
