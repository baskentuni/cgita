function varargout = parametric_img_GUI(varargin)
% PARAMETRIC_IMG_GUI MATLAB code for parametric_img_GUI.fig
%      PARAMETRIC_IMG_GUI, by itself, creates a new PARAMETRIC_IMG_GUI or raises the existing
%      singleton*.
%
%      H = PARAMETRIC_IMG_GUI returns the handle to a new PARAMETRIC_IMG_GUI or the handle to
%      the existing singleton*.
%
%      PARAMETRIC_IMG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETRIC_IMG_GUI.M with the given input arguments.
%
%      PARAMETRIC_IMG_GUI('Property','Value',...) creates a new PARAMETRIC_IMG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before parametric_img_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to parametric_img_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help parametric_img_GUI

% Last Modified by GUIDE v2.5 03-Jul-2012 14:54:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parametric_img_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @parametric_img_GUI_OutputFcn, ...
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


% --- Executes just before parametric_img_GUI is made visible.
function parametric_img_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parametric_img_GUI (see VARARGIN)

% Choose default command line output for parametric_img_GUI
handles.output = hObject;

load user_feature_settings.mat;

n_textural_features = 0;
for idx = 1:length(feature_structure)
    n_textural_features = n_textural_features + length(feature_structure{idx});
end

n_parent = length(feature_structure);

Feature_table = {};

Feature_display_cell = {};
handles.Function_list_cell = {};

table_row_now_idx = 0;
for idx_parent = 1:n_parent
    n_features_in_parent = length(feature_structure{idx_parent});
    for idx_feature = 1:n_features_in_parent
        table_row_now_idx = table_row_now_idx+1;
            Feature_display_cell{table_row_now_idx, 1} = feature_structure{idx_parent}{idx_feature}.parent;
            Feature_display_cell{table_row_now_idx, 2} = feature_structure{idx_parent}{idx_feature}.name;
            handles.Function_list_cell{table_row_now_idx, 1} = feature_structure{idx_parent}{idx_feature}.parentfcn;
            handles.Function_list_cell{table_row_now_idx, 2} = feature_structure{idx_parent}{idx_feature}.matlab_fun;
    end
end

set(handles.uitable1, 'Data', Feature_display_cell);

handles.main_handles = varargin{3};

if handles.main_handles.VOI_loaded == 0
    set(handles.popupmenu2, 'String', 'Whole image volume')
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes parametric_img_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = parametric_img_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close(handles.figure1);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.edit1, 'String'))
    %warndlg('The output file has not been specified yet. The next window will prompt you for it.');
    [filename, pathname] = uiputfile( ...
        {'*.*'}, ...
        'Save results as');
    if filename~=0
        set(handles.edit1, 'String', fullfile(pathname, filename));
    else
        warndlg('Output filename unspecified');
    end
end
if ~isfield(handles, 'feature_to_do')
    warndlg('Click on the desired feature first');
    return;
end
texture_index = handles.feature_to_do.Indices(1);

parent_fcn  = [handles.Function_list_cell{texture_index, 1} '_parametric_img'];
feature_fcn = handles.Function_list_cell{texture_index, 2};

a=get(handles.popupmenu2, 'String');
if strcmp(a{get(handles.popupmenu2, 'Value')}, 'Current VOI range')
    para_img_flag = 1;
else
    para_img_flag = 2;
end

main_handles = handles.main_handles;

n_pix = 2*get(handles.popupmenu1, 'Value') + 1;
pixs = get(handles.popupmenu1, 'Value');

%%
if para_img_flag == 1
    list_idx = get(main_handles.listbox1, 'Value');
    [main_handles.contour_volume main_handles.mask_volume first_slice last_slice] = return_volume_contour_mask(main_handles.VOI_obj(list_idx).contour, main_handles);
    mask = main_handles.mask_volume;
else
    mask = ones(size(main_handles.Primary_image_obj.image_volume_data));
end
[out_border extended_range] = determine_mask_range_2(mask, n_pix);

load user_feature_settings.mat;
main_handles.digitization_flag = digitization_flag;
main_handles.default_digitization_min = default_digitization_min;
main_handles.default_digitization_max = default_digitization_max;
main_handles.digitization_bins = digitization_bins;

switch main_handles.digitization_flag
    case 0 % 0 - use the min and max within the masked volume for digitization (default)
        tempimg = main_handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1})  .* mask(extended_range{3}, extended_range{2}, extended_range{1});
        digitization_min = min(tempimg(find(mask(extended_range{3}, extended_range{2}, extended_range{1}))));
        digitization_max = max(tempimg(find(mask(extended_range{3}, extended_range{2}, extended_range{1}))));
    case 1 % 1 - use the min and max within the rectangular cylinder volume
        tempimg = main_handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1});
        digitization_min = min(tempimg(:));
        digitization_max = max(tempimg(:));
    case 2 % 2 - use 0 and max within the masked volume for digitization
        tempimg = main_handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1})  .* mask(extended_range{3}, extended_range{2}, extended_range{1});
        digitization_min = 0;
        digitization_max = max(tempimg(find(mask(extended_range{3}, extended_range{2}, extended_range{1}))));
    case 3 % 3 - use 0 and max within the rectangular cylinder volume
        tempimg = main_handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1});
        digitization_min = 0;
        digitization_max = max(tempimg(:));
    case 4 % 4 - use preset min and max values (needs to assign both values)
        digitization_min = main_handles.default_digitization_min;
        digitization_max = main_handles.default_digitization_max;
end

tempimg_original = main_handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1});
tempimg_resampled = digitize_img(tempimg_original, main_handles.digitization_type, 1, main_handles.digitization_bins, digitization_min, digitization_max);
main_handles.resampled_image_vol_for_TA_unmasked_extended{1}{1} = tempimg_resampled;

%[out_border extended_range] = determine_mask_range( handles.mask_vol_for_TA{1}{1});
para_img = zeros(size(main_handles.resampled_image_vol_for_TA_unmasked_extended{1}{1}) - 2*[pixs pixs pixs]);

for idx1 = pixs+1:size(main_handles.resampled_image_vol_for_TA_unmasked_extended{1}{1}, 1)-pixs
    %tic
    for idx2 = pixs+1:size(main_handles.resampled_image_vol_for_TA_unmasked_extended{1}{1}, 2)-pixs
        for idx3 = pixs+1:size(main_handles.resampled_image_vol_for_TA_unmasked_extended{1}{1}, 3)-pixs
            img1 = tempimg_original(idx1-pixs:idx1+pixs, idx2-pixs:idx2+pixs, idx3-pixs:idx3+pixs);
            img2 = tempimg_resampled(idx1-pixs:idx1+pixs, idx2-pixs:idx2+pixs, idx3-pixs:idx3+pixs);

            feval(parent_fcn, img1, img2, main_handles.Primary_image_obj);

            eval(['feature_output = ' feature_fcn ';']);
            para_img(idx1-pixs, idx2-pixs, idx3-pixs) = feature_output;
        end
    end
    %toc
end


%%
handles.output = para_img;
filename = get(handles.edit1, 'String');
write_binary(filename, 'float', para_img);
guidata(hObject, handles);

% UIWAIT makes parametric_img_GUI wait for user response (see UIRESUME)
uiresume(handles.figure1);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( ...
       {'*.*'}, ...
        'Save results as');
if filename~=0
    set(handles.edit1, 'String', fullfile(pathname, filename));
end
return;
    
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = [];
guidata(hObject, handles);

% UIWAIT makes parametric_img_GUI wait for user response (see UIRESUME)
uiresume(handles.figure1);


% --------------------------------------------------------------------
function uitable1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.feature_to_do = eventdata(1);

guidata(hObject, handles);
