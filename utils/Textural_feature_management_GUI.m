function varargout = Textural_feature_management_GUI(varargin)
% TEXTURAL_FEATURE_MANAGEMENT_GUI MATLAB code for Textural_feature_management_GUI.fig
%      TEXTURAL_FEATURE_MANAGEMENT_GUI, by itself, creates a new TEXTURAL_FEATURE_MANAGEMENT_GUI or raises the existing
%      singleton*.
%
%      H = TEXTURAL_FEATURE_MANAGEMENT_GUI returns the handle to a new TEXTURAL_FEATURE_MANAGEMENT_GUI or the handle to
%      the existing singleton*.
%
%      TEXTURAL_FEATURE_MANAGEMENT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEXTURAL_FEATURE_MANAGEMENT_GUI.M with the given input arguments.
%
%      TEXTURAL_FEATURE_MANAGEMENT_GUI('Property','Value',...) creates a new TEXTURAL_FEATURE_MANAGEMENT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Textural_feature_management_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Textural_feature_management_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Textural_feature_management_GUI

% Last Modified by GUIDE v2.5 29-Mar-2012 09:14:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Textural_feature_management_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Textural_feature_management_GUI_OutputFcn, ...
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


% --- Executes just before Textural_feature_management_GUI is made visible.
function Textural_feature_management_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Textural_feature_management_GUI (see VARARGIN)

% Choose default command line output for Textural_feature_management_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Textural_feature_management_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Textural_feature_management_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in add_feature_button.
function add_feature_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_feature_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_feature_button.
function remove_feature_button_Callback(hObject, eventdata, handles)
% hObject    handle to remove_feature_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in default_button.
function default_button_Callback(hObject, eventdata, handles)
% hObject    handle to default_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in return_button.
function return_button_Callback(hObject, eventdata, handles)
% hObject    handle to return_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
