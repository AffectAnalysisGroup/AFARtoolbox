function varargout = pipelineRunning(varargin)
% PIPELINERUNNING MATLAB code for pipelineRunning.fig
%      PIPELINERUNNING, by itself, creates a new PIPELINERUNNING or raises the existing
%      singleton*.
%
%      H = PIPELINERUNNING returns the handle to a new PIPELINERUNNING or the handle to
%      the existing singleton*.
%
%      PIPELINERUNNING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIPELINERUNNING.M with the given input arguments.
%
%      PIPELINERUNNING('Property','Value',...) creates a new PIPELINERUNNING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pipelineRunning_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pipelineRunning_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pipelineRunning

% Last Modified by GUIDE v2.5 21-Jan-2019 20:06:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pipelineRunning_OpeningFcn, ...
                   'gui_OutputFcn',  @pipelineRunning_OutputFcn, ...
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


% --- Executes just before pipelineRunning is made visible.
function pipelineRunning_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pipelineRunning (see VARARGIN)

% Choose default command line output for pipelineRunning
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pipelineRunning wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pipelineRunning_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
