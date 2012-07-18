function varargout = texture_stat_table_GUI(varargin)
% TEXTURE_STAT_TABLE_GUI MATLAB code for texture_stat_table_GUI.fig
%      TEXTURE_STAT_TABLE_GUI, by itself, creates a new TEXTURE_STAT_TABLE_GUI or raises the existing
%      singleton*.
%
%      H = TEXTURE_STAT_TABLE_GUI returns the handle to a new TEXTURE_STAT_TABLE_GUI or the handle to
%      the existing singleton*.
%
%      TEXTURE_STAT_TABLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEXTURE_STAT_TABLE_GUI.M with the given input arguments.
%
%      TEXTURE_STAT_TABLE_GUI('Property','Value',...) creates a new TEXTURE_STAT_TABLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before texture_stat_table_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to texture_stat_table_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help texture_stat_table_GUI

% Last Modified by GUIDE v2.5 27-Mar-2012 16:28:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @texture_stat_table_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @texture_stat_table_GUI_OutputFcn, ...
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


% --- Executes just before texture_stat_table_GUI is made visible.
function texture_stat_table_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to texture_stat_table_GUI (see VARARGIN)

% Choose default command line output for texture_stat_table_GUI
handles.output = hObject;
handles.data_table = varargin{1};
set(handles.texture_table,  'Data', handles.data_table);%, 'ColumnName', columnname, 'ColumnFormat', columnformat, 'ColumnEditable', columneditable);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes texture_stat_table_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = texture_stat_table_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close(handles.figure1);

% --- Executes on button press in save_excel_button.
function save_excel_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_excel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[outfile outpath] = uiputfile;
xlswrite(fullfile(outpath, outfile), handles.data_table);
return;

% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
