function varargout = fet_gui(varargin)
% FET_GUI MATLAB code for fet_gui.fig
%      FET_GUI, by itself, creates a new FET_GUI or raises the existing
%      singleton*.
%
%      H = FET_GUI returns the handle to a new FET_GUI or the handle to
%      the existing singleton*.
%
%      FET_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FET_GUI.M with the given input arguments.
%
%      FET_GUI('Property','Value',...) creates a new FET_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fet_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fet_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fet_gui

% Last Modified by GUIDE v2.5 02-Mar-2016 13:11:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fet_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @fet_gui_OutputFcn, ...
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


% --- Executes just before fet_gui is made visible.
function fet_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fet_gui (see VARARGIN)

% Choose default command line output for fet_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fet_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fet_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename,pathname] = uigetfile( {'*.txt','Text files (*.txt)'}, ...
        'Pick a file', '');
    if filename ~=0
%         handles.filename = filename;
%         handles.pathname = pathname;
        set(handles.textLoad,'String',[pathname filename]);
    end
    
    

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btnLoad.
function btnLoad_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on btnLoad and none of its controls.
function btnLoad_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnOutDir.
function btnOutDir_Callback(hObject, eventdata, handles)
% hObject    handle to btnOutDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    folder_name = uigetdir;
    if folder_name ~= 0
        handles.outDir = folder_name;
        set(handles.textOutDir,'String',folder_name);
    end

% --- Executes on button press in btnLoad.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pumFeature.
function pumFeature_Callback(hObject, eventdata, handles)
% hObject    handle to pumFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumFeature contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumFeature


% --- Executes during object creation, after setting all properties.
function pumFeature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnStart.
function btnStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    inFile = get(handles.textLoad,'String');
    if exist(inFile,'file')
        trackingDir = get(handles.textTrackingDir,'String');
        if exist(trackingDir,'dir')
            outDir = get(handles.textOutDir,'String');
            if exist(outDir,'dir')
                normFunc = get(handles.pumNormalization,'String');
                normFunc = normFunc{get(handles.pumNormalization,'Value')};
                res = str2num(get(handles.editRes,'String'));
                IOD = str2num(get(handles.editIOD,'String'));
                lmSS = get(handles.editLMs,'String');
                
                descFunc = get(handles.pumFeature,'String');
                descFunc = descFunc{get(handles.pumFeature,'Value')};
                patchSize = str2num(get(handles.editPatch,'String'));
                
                saveNormVideo = get(handles.cbSaveNormVideo,'Value');
                saveNormLandmarks = get(handles.cbSaveNormLandmarks,'Value');
                saveVideoLandmarks = get(handles.cbSaveVideoLandmarks,'Value');
                
                fet_parameter_setup;
                
                hPB = progressbar('Files');
                
                p = gcp(); % get the current parallel pool
                for i = 1:nItems
                    fn = C{1,1}{i,1};
                    if length(C{1,2}) >= i
                        strFr = C{1,2}{i,1};    
                    else
                        strFr = '';
                    end
                    
                    f(i) = parfeval(p,@fet_process_single,0,fn,strFr,ms3D,trackingDir,outDir,normFunc,res,IOD,lmSS,descFunc,patchSize,saveNormVideo,saveNormLandmarks,saveVideoLandmarks);
                end
                
                for i = 1:nItems
                  [completedNdx] = fetchNext(f);
                  fprintf('done: %s.\n', C{1,1}{completedNdx,1});
                  display(f(completedNdx).Diary);
                  fprintf('\n');
                  progressbar(i/nItems);
                end                
            else
                msgbox('Can''t find the output folder!');
            end
        else
            msgbox('Can''t find the tracking files folder!');
        end        
    else
        msgbox('Can''t find the input file!');
    end


function editFiltering_Callback(hObject, eventdata, handles)
% hObject    handle to editFiltering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFiltering as text
%        str2double(get(hObject,'String')) returns contents of editFiltering as a double


% --- Executes during object creation, after setting all properties.
function editFiltering_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFiltering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbShowTracking.
function cbShowTracking_Callback(hObject, eventdata, handles)
% hObject    handle to cbShowTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbShowTracking


% --- Executes on button press in cbWriteVideo.
function cbWriteVideo_Callback(hObject, eventdata, handles)
% hObject    handle to cbWriteVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbWriteVideo
    if get(handles.cbWriteVideo,'Value')
        set(handles.cbShowTracking,'Value',1);
    end


% --- Executes on button press in btnTrackingDir.
function btnTrackingDir_Callback(hObject, eventdata, handles)
% hObject    handle to btnTrackingDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    folder_name = uigetdir;
    if folder_name ~= 0
        handles.trackingDir = folder_name;
        set(handles.textTrackingDir,'String',folder_name);
    end


% --- Executes on selection change in pumNormalization.
function pumNormalization_Callback(hObject, eventdata, handles)
% hObject    handle to pumNormalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumNormalization contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumNormalization


% --- Executes during object creation, after setting all properties.
function pumNormalization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumNormalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRes_Callback(hObject, eventdata, handles)
% hObject    handle to editRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRes as text
%        str2double(get(hObject,'String')) returns contents of editRes as a double


% --- Executes during object creation, after setting all properties.
function editRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editIOD_Callback(hObject, eventdata, handles)
% hObject    handle to editIOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIOD as text
%        str2double(get(hObject,'String')) returns contents of editIOD as a double


% --- Executes during object creation, after setting all properties.
function editIOD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbSaveNormVideo.
function cbSaveNormVideo_Callback(hObject, eventdata, handles)
% hObject    handle to cbSaveNormVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSaveNormVideo


% --- Executes on button press in cbSaveNormLandmarks.
function cbSaveNormLandmarks_Callback(hObject, eventdata, handles)
% hObject    handle to cbSaveNormLandmarks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSaveNormLandmarks


% --- Executes on button press in cbSaveVideoLandmarks.
function cbSaveVideoLandmarks_Callback(hObject, eventdata, handles)
% hObject    handle to cbSaveVideoLandmarks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSaveVideoLandmarks


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%    set(handles.pumFeature,'String',['HOG';'SIFT']);
% x = get(handles.pumFeature,'String');
% x
[path name ext] = fileparts(mfilename('fullpath'));

inFiles = dir([path '\fet_norm*.m']);
tmp = {};
for i = 1:length(inFiles)
    tmp{i} = inFiles(i).name(10:end-2);
end
handles.norm_functions = tmp;
set(handles.pumNormalization,'String',tmp);

inFiles = dir([path '\fet_desc*.m']);
tmp = {};
for i = 1:length(inFiles)
    tmp{i} = inFiles(i).name(10:end-2);
end
handles.desc_functions = tmp;
set(handles.pumFeature,'String',tmp);



function editPatch_Callback(hObject, eventdata, handles)
% hObject    handle to editPatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPatch as text
%        str2double(get(hObject,'String')) returns contents of editPatch as a double


% --- Executes during object creation, after setting all properties.
function editPatch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editLMs_Callback(hObject, eventdata, handles)
% hObject    handle to editLMs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLMs as text
%        str2double(get(hObject,'String')) returns contents of editLMs as a double


% --- Executes during object creation, after setting all properties.
function editLMs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLMs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
