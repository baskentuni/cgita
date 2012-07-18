function varargout = Textural_results_display_GUI(varargin)
% TEXTURAL_RESULTS_DISPLAY_GUI MATLAB code for Textural_results_display_GUI.fig
%      TEXTURAL_RESULTS_DISPLAY_GUI, by itself, creates a new TEXTURAL_RESULTS_DISPLAY_GUI or raises the existing
%      singleton*.
%
%      H = TEXTURAL_RESULTS_DISPLAY_GUI returns the handle to a new TEXTURAL_RESULTS_DISPLAY_GUI or the handle to
%      the existing singleton*.
%
%      TEXTURAL_RESULTS_DISPLAY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEXTURAL_RESULTS_DISPLAY_GUI.M with the given input arguments.
%
%      TEXTURAL_RESULTS_DISPLAY_GUI('Property','Value',...) creates a new TEXTURAL_RESULTS_DISPLAY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Textural_results_display_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Textural_results_display_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Textural_results_display_GUI

% Last Modified by GUIDE v2.5 09-Apr-2012 12:10:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Textural_results_display_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Textural_results_display_GUI_OutputFcn, ...
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


% --- Executes just before Textural_results_display_GUI is made visible.
function Textural_results_display_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Textural_results_display_GUI (see VARARGIN)

% Choose default command line output for Textural_results_display_GUI
handles.output = hObject;
handles.Feature_table = varargin{1};
handles.Feature_display_cell = varargin{2};
set(handles.feature_uitable,  'Data', handles.Feature_display_cell);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Textural_results_display_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Textural_results_display_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;

% --- Executes on button press in save_excel_btn.
function save_excel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_excel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.xls', 'Save texture table as:');
if ~isempty(filename)
    [success message]=xlswrite(fullfile(pathname, filename), handles.Feature_display_cell);
end
return;

% --- Executes on button press in copy2clilboard.
function copy2clilboard_Callback(hObject, eventdata, handles)
% hObject    handle to copy2clilboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text_to_clipboard = '';
for idx1 = 1:size(handles.Feature_display_cell,1)
    for idx2 = 1:size(handles.Feature_display_cell,2)
        if idx2 < size(handles.Feature_display_cell,2)
            if isnumeric(handles.Feature_display_cell{idx1,idx2})
                text_to_clipboard = [text_to_clipboard sprintf('%s\t', num2str(handles.Feature_display_cell{idx1,idx2}))];
            else
            text_to_clipboard = [text_to_clipboard sprintf('%s\t', handles.Feature_display_cell{idx1,idx2})];
            end
        else
            if isnumeric(handles.Feature_display_cell{idx1,idx2})
                text_to_clipboard = [text_to_clipboard sprintf('%s\t', num2str(handles.Feature_display_cell{idx1,idx2}))];
            else
                text_to_clipboard = [text_to_clipboard sprintf('%s', handles.Feature_display_cell{idx1,idx2})];
            end
        end
    end
    text_to_clipboard = [text_to_clipboard sprintf('\n')];
end
clipboard('copy', text_to_clipboard);
return
% --- Executes on button press in close_and_return.
function close_and_return_Callback(hObject, eventdata, handles)
% hObject    handle to close_and_return (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;
delete(handles.figure1);
return;


% --- Executes on button press in copy_numeric_data.
function copy_numeric_data_Callback(hObject, eventdata, handles)
% hObject    handle to copy_numeric_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text_to_clipboard = '';
for idx1 = 2:size(handles.Feature_display_cell,1)
    for idx2 = 3:size(handles.Feature_display_cell,2)
        if idx2 < size(handles.Feature_display_cell,2)
            if isnumeric(handles.Feature_display_cell{idx1,idx2})
                text_to_clipboard = [text_to_clipboard sprintf('%s\t', num2str(handles.Feature_display_cell{idx1,idx2}))];
            else
            text_to_clipboard = [text_to_clipboard sprintf('%s\t', handles.Feature_display_cell{idx1,idx2})];
            end
        else
            if isnumeric(handles.Feature_display_cell{idx1,idx2})
                text_to_clipboard = [text_to_clipboard sprintf('%s\t', num2str(handles.Feature_display_cell{idx1,idx2}))];
            else
                text_to_clipboard = [text_to_clipboard sprintf('%s', handles.Feature_display_cell{idx1,idx2})];
            end
        end
    end
    text_to_clipboard = [text_to_clipboard sprintf('\n')];
end
clipboard('copy', text_to_clipboard);
return;
