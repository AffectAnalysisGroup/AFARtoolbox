function varargout = runPipelineGUI(varargin)
% RUNPIPELINEGUI MATLAB code for runPipelineGUI.fig
%      RUNPIPELINEGUI, by itself, creates a new RUNPIPELINEGUI or raises the existing
%      singleton*.
%
%      H = RUNPIPELINEGUI returns the handle to a new RUNPIPELINEGUI or the handle to
%      the existing singleton*.
%
%      RUNPIPELINEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNPIPELINEGUI.M with the given input arguments.
%
%      RUNPIPELINEGUI('Property','Value',...) creates a new RUNPIPELINEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before runPipelineGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to runPipelineGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help runPipelineGUI

% Last Modified by GUIDE v2.5 21-Jan-2019 13:49:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @runPipelineGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @runPipelineGUI_OutputFcn, ...
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


% --- Executes just before runPipelineGUI is made visible.
function runPipelineGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to runPipelineGUI (see VARARGIN)

% Choose default command line output for runPipelineGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes runPipelineGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = runPipelineGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
