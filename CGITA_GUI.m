function varargout = CGITA_GUI(varargin)
% CGITA_GUI MATLAB code for CGITA_GUI.fig
%      CGITA_GUI, by itself, creates a new CGITA_GUI or raises the existing
%      singleton*.
%
%      H = CGITA_GUI returns the handle to a new CGITA_GUI or the handle to
%      the existing singleton*.
%
%      CGITA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CGITA_GUI.M with the given input arguments.
%
%      CGITA_GUI('Property','Value',...) creates a new CGITA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CGITA_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CGITA_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CGITA_GUI

% Last Modified by GUIDE v2.5 18-Jul-2012 08:33:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CGITA_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @CGITA_GUI_OutputFcn, ...
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


% --- Executes just before CGITA_GUI is made visible.
function CGITA_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CGITA_GUI (see VARARGIN)

% Choose default command line output for CGITA_GUI
handles.output = hObject;

%set(handles.figure1, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
axes(handles.axial_axes); axis off;
axes(handles.coronal_axes); axis off;
axes(handles.sagittal_axes); axis off;

load user_feature_settings.mat;
handles.primary_colormap_name = default_primary_colormap;
handles.fusion_colormap_name = default_fusion_colormap;

tempstr = get(handles.primary_color,'String');
found_flag = 0;
for idx = 1:length(tempstr)
    if strcmp(tempstr{idx}, handles.primary_colormap_name)
        set(handles.primary_color, 'Value', idx);
        found_flag = 1;
        break;
    end
end
if found_flag == 0
    tempstr{end+1} = handles.primary_colormap_name;
    set(handles.primary_color,'String', tempstr);
    set(handles.primary_color, 'Value', idx+1);
end

tempstr = get(handles.fusion_color,'String');
found_flag = 0;
for idx = 1:length(tempstr)
    if strcmp(tempstr{idx}, handles.fusion_colormap_name)
        set(handles.fusion_color, 'Value', idx);
        found_flag = 1;
        break;
    end
end
if found_flag == 0
    tempstr{end+1} = handles.fusion_colormap_name;
    set(handles.fusion_color,'String', tempstr);
    set(handles.fusion_color, 'Value', idx+1);
end

eval(['handles.primary_colormap = ' handles.primary_colormap_name '(65536);']);
eval(['handles.fusion_colormap = ' handles.fusion_colormap_name '(65536);']);

handles.digitization_flag = digitization_flag;
handles.default_digitization_min = default_digitization_min;
handles.default_digitization_max = default_digitization_max;
handles.digitization_bins = digitization_bins;


if digitization_bins <= 255
    handles.digitization_type = 'uint8';
elseif digitization_bins <= 65536
    handles.digitization_type = 'uint16';
else
    handles.digitization_type = 'uint32';
end

handles.Primary_images_loaded = 0; % a tag to identify whether the primary images have been loaded
handles.Fusion_images_loaded   = 0; % a tag to identify whether the fusion images have been loaded
handles.VOI_loaded                      = 0; % a tag to identify whether the VOIs have been loaded
handles.Primary_image_obj = [];         % Primary image object
handles.Fusion_image_obj = [];           % Fusion image object
handles.VOI_obj = [];                            % VOI object
handles.current_i = [];
handles.current_j = [];
handles.current_k = [];
handles.Let_VOI_decide_slice = 0;
handles.direction_text = [handles.text13 handles.text14 handles.text15 handles.text16];
handles.pmod_voi_flag = 1; % temporary flag. 

%handles.resample_n_values = handles.digitization_bins;

handles.axial_btndwn_fcn      = get(handles.axial_axes,'ButtonDownFcn');
handles.coronal_btndwn_fcn = get(handles.coronal_axes,'ButtonDownFcn');
handles.sagittal_btndwn_fcn = get(handles.sagittal_axes,'ButtonDownFcn');

axes(handles.axial_axes);
temp1 = get(handles.axial_axes, 'ButtonDownFcn');
handles.Img_axial = image([0 0;0 0]); colormap gray; axis off;
set(handles.Img_axial,'ButtonDownFcn',temp1);

axes(handles.coronal_axes);
temp1 = get(handles.coronal_axes, 'ButtonDownFcn');
handles.Img_coronal = image([0 0;0 0]); colormap gray; axis off;
set(handles.Img_coronal,'ButtonDownFcn',temp1);

axes(handles.sagittal_axes);
temp1 = get(handles.sagittal_axes, 'ButtonDownFcn');
handles.Img_sagittal = image([0 0;0 0]); colormap gray; axis off;
set(handles.Img_sagittal,'ButtonDownFcn',temp1);

set(handles.fusion_factor_slider, 'SliderStep', [0.01 0.01]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CGITA_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CGITA_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% % --- Executes on button press in pushbutton1.
% function pushbutton1_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% in_file = uigetfile( '*.mat', 'Select the .mat file saved by CERR');
% 
% if in_file == 0
%     return;
% else
%     temp1 = load(in_file, 'planC');
%     handles.planC = temp1.planC;
% end
% 
% field_length = length(handles.planC);
% 
% handles.CT_img = handles.planC{handles.planC{field_length}.scan}.scanArray;
% handles.ROI_structure = handles.planC{handles.planC{field_length}.structures};
% 
% [handles.xV, handles.yV, handles.zV] = getScanXYZVals(handles.planC{handles.planC{field_length}.scan}(1));
% 
% structure_length= length(handles.ROI_structure);
% 
% for idx = 1:structure_length
%     list{idx} =  handles.ROI_structure(idx).structureName;
% end
% 
% set(handles.listbox1, 'String', list);
% 
% pix_Z = handles.planC{handles.planC{field_length}.scan}.scanInfo(1).voxelThickness;
% pix_X  = handles.planC{handles.planC{field_length}.scan}.scanInfo(1).grid1Units;
% loc1 = get(handles.coronal_axes, 'Position');
% temp1 = pix_X * size(handles.CT_img,1)/pix_Z;
% loc1 = [loc1(1:3) temp1];
% set(handles.coronal_axes, 'Position', loc1);
% 
% loc1 = get(handles.sagittal_axes, 'Position');
% loc1 = [loc1(1:3) temp1];
% set(handles.sagittal_axes, 'Position', loc1);
% 
% %handles  = display_img_ROI(hObject, eventdata, handles);
% listbox1_Callback(hObject, eventdata, handles)
% 
% guidata(hObject, handles);
% return;
% 
% function handles = display_img_ROI(hObject, eventdata, handles)
% list_idx = get(handles.listbox1, 'Value');
% [handles.contour_volume handles.mask_volume first_slice last_slice] = return_volume_contour_mask(handles.ROI_structure(list_idx).contour, handles);
% 
% handles.current_slice = round(mean(first_slice,last_slice));
% 
% handles = refresh_img(handles);
% guidata(hObject, handles);
% return;
% 
% function handles =refresh_img(handles)
% img_color = overlay_img_with_contour(handles.CT_img(:,:,handles.current_slice), handles.contour_volume(:,:,handles.current_slice));
% axes(handles.axial_axes);
% imagesc(img_color); axis off;
% img_color = overlay_img_with_contour(squeeze(handles.CT_img(:,handles.current_x,:)), squeeze(handles.contour_volume(:,handles.current_x, :)));
% axes(handles.coronal_axes);
% imagesc(imrotate(img_color, -90)); axis off;
% 
% img_color = overlay_img_with_contour(squeeze(handles.CT_img(handles.current_y,:,:)), squeeze(handles.contour_volume(handles.current_y,:, :)));
% axes(handles.sagittal_axes);
% imagesc(imrotate(img_color, -90)); axis off;
% 
% return;

function img_color = overlay_img_with_contour(CT_slice, contour_slice)
% temp130 = round(temp128(:,:,idx)/18);
% temp130(find(temp130<64)) = 0;
if isinteger(CT_slice)
    I1 = ind2rgb(cast_double_to_int16(cast(CT_slice, 'double'), 'uint16'), bone(65536));
else
    I1 = ind2rgb(cast_double_to_int16(CT_slice, 'uint16'), bone(65536));
end
% temp129 = round(temp7(:,:,idx)/120);
% temp129(find(temp129<100)) = 0;
%temp129 = fliplr(temp129);
I2 = ind2rgb(contour_slice*150, hot(256));
img_color = I1;
for idx1 = 1:size(I1,1)
    for idx2 = 1:size(I1,2)
        if contour_slice(idx1,idx2) == 1
            img_color(idx1,idx2,:) = I2(idx1,idx2,:);
            if idx1>1
                img_color(idx1-1,idx2,:) = I2(idx1,idx2,:);
            end
            if idx1<size(I1,1)
                img_color(idx1+1,idx2,:) = I2(idx1,idx2,:);
            end
            if idx2>1
                img_color(idx1,idx2-1,:) = I2(idx1,idx2,:);
            end
            if idx2<size(I1,2)
                img_color(idx1,idx2+1,:) = I2(idx1,idx2,:);
            end
        end
    end
end
return;






% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
list_idx = get(handles.listbox1, 'Value');
[handles.contour_volume handles.mask_volume first_slice last_slice] = return_volume_contour_mask(handles.VOI_obj(list_idx).contour, handles);
%[first_slice last_slice]
if sum(handles.mask_volume(:)) == 0
    warndlg('No contour available for this structure');
    return;
end

if get(handles.change_location_check, 'Value') == 1
    handles.Let_VOI_decide_slice = 0;
else
    handles.Let_VOI_decide_slice = 1;
end
%handles = refresh_img(handles);
handles = refresh_display(handles);

handles.Let_VOI_decide_slice = 0;

guidata(hObject, handles);
return;


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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Let_VOI_decide_slice = 1;
handles = refresh_display(handles);
handles.Let_VOI_decide_slice = 0;

guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RT_dir = uigetdir;
if (RT_dir == 0)
    return;
end

[series_filenames series_names] = DICOM_parse_dir(RT_dir);

do_fields_table= [8 4158; 8 49; 8 32; 8 4144; 32 16; 8 8487; 16 16; 8 96];
dicomdict('set', 'dicom-dict_truncated');

for idx = 1:length(series_filenames{1}.description)
    temphdr =  dicominfo_Dean_rev(series_filenames{1}.description{idx}.filename{1}, do_fields_table);
    series_type{idx} = temphdr.Modality;
    switch temphdr.Modality
        case 'CT'
            series_identifier(idx)  = 1;
        case 'PET'
            series_identifier(idx)  = 2;
        case 'MRI'
            series_identifier(idx)  = 3;
        case 'RTDOSE'
            series_identifier(idx)  = 4;
        case 'RTPLAN'
            series_identifier(idx)  = 5;
        case 'RTSTRUCT'
            series_identifier(idx)  = 6;
    end
end

dicomdict('factory');

%toc
% Find the CT images
ct_series = find(series_identifier==1);
if length(ct_series)>1
    errordlg('More than one CT series. Cannot continue');
    return;
end

out1 = DICOM_volume_reader_COMKAT(series_filenames{1}.description{ct_series}.filename);

out1.x_location = out1.x_location/10;
out1.y_location = out1.y_location/10;
out1.z_location = out1.z_location/10;
out1.original_x_location = out1.original_x_location/10;
out1.original_y_location = out1.original_y_location/10;
out1.original_z_location = out1.original_z_location/10;

handles.CT_img = out1.pixelData;

rs_series = find(series_identifier==6);
if length(rs_series)>1
    errordlg('More than one RS structure. Cannot continue');
    return;
end

handles.ROI_structure = DICOM_contour_reader(series_filenames{1}.description{rs_series}.filename{1}, out1.z_location, ...
    out1.original_x_location, out1.original_y_location, fliplr(out1.original_z_location), ...
    out1.x_location, out1.y_location, out1.z_location);

structure_length= length(handles.ROI_structure);

for idx = 1:structure_length
    list{idx} =  handles.ROI_structure(idx).structureName;
end

set(handles.listbox1, 'String', list);

pix_Z = out1.pixelSpacing(3);
pix_X = out1.pixelSpacing(1);
loc1 = get(handles.coronal_axes, 'Position');
temp1 = pix_X * size(handles.CT_img,1)/pix_Z;
loc1 = [loc1(1:3) temp1];
set(handles.coronal_axes, 'Position', loc1);

loc1 = get(handles.sagittal_axes, 'Position');
loc1 = [loc1(1:3) temp1];
set(handles.sagittal_axes, 'Position', loc1);

handles.xV = out1.x_location;
handles.yV = out1.y_location;
handles.zV = out1.z_location;
%handles  = display_img_ROI(hObject, eventdata, handles);
set(handles.listbox1, 'Value', 1);
listbox1_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

%%%%%%% DONE UNTIL HERE!
% Find the RS file

% Read the CT volume

% Read the ROI contours from the RS file
% in_file = uigetfile( '*.mat', 'Select the .mat file saved by CERR');
%
% if in_file == 0
%     return;
% else
%     temp1 = load(in_file, 'planC');
%     handles.planC = temp1.planC;
% end
%
% field_length = length(handles.planC);
%
% handles.CT_img = handles.planC{handles.planC{field_length}.scan}.scanArray;
% handles.ROI_structure = handles.planC{handles.planC{field_length}.structures};
%
% [handles.xV, handles.yV, handles.zV] = getScanXYZVals(handles.planC{handles.planC{field_length}.scan}(1));
%
% structure_length= length(handles.ROI_structure);
%
% for idx = 1:structure_length
%     list{idx} =  handles.ROI_structure(idx).structureName;
% end
%
% set(handles.listbox1, 'String', list);
%
% pix_Z = handles.planC{handles.planC{field_length}.scan}.scanInfo(1).voxelThickness;
% pix_X  = handles.planC{handles.planC{field_length}.scan}.scanInfo(1).grid1Units;
% loc1 = get(handles.coronal_axes, 'Position');
% temp1 = pix_X * size(handles.CT_img,1)/pix_Z;
% loc1 = [loc1(1:3) temp1];
% set(handles.coronal_axes, 'Position', loc1);
%
% loc1 = get(handles.sagittal_axes, 'Position');
% loc1 = [loc1(1:3) temp1];
% set(handles.sagittal_axes, 'Position', loc1);
%
% %handles  = display_img_ROI(hObject, eventdata, handles);
% listbox1_Callback(hObject, eventdata, handles)
%
% guidata(hObject, handles);
return;


% --- Executes on button press in load_Primary_btn.
function load_Primary_btn_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to load_Primary_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if nargin == 3
    % Get the directory to load primary images from
    if exist('prev_dir.mat')
        load prev_dir.mat;
        default_dir = prev_in_dirname;
    else
        default_dir = cd;
    end
    %default_dir = 'E:\Research Data\Texture analysis\Data_NPC_painting';
    % Primary_dir = 'D:\Data\Textural analysis\Pre_data_PET\A0001\20091019_145433.00\PET';
    %Primary_dir = 'D:\Data\Dean_temp1\1515604\20090720';
    if ~isdir(default_dir)
        default_dir = '';
    end
    Primary_dir = uigetdir(default_dir);
    
    if Primary_dir == 0
        return;
    end
    if ~isdir(Primary_dir)
        return;
    else
        prev_in_dirname = Primary_dir;
        if exist('prev_dir.mat')
            save(which('prev_dir.mat'), 'prev_in_dirname', '-append');
        end
    end
else
    Primary_dir = varargin{1};
end
% Parse directory and determine how many studies/series are within this
% folder and the subfolders
[filelist fusion_filelist] = parse_directory_for_dicom(Primary_dir);
drawnow;

if isempty(filelist)
    return;
end

% If there are more than one study and series, prompt the user to select
% the set to import
out1 = DICOM_reader_CGITA(filelist);

handles.Primary_image_obj = make_image_obj_DICOM(out1);

handles.Primary_image_obj.metadata = dicominfo(filelist{1});

%handles.Primary_image_obj.color_map = hot(65536);
handles.Primary_images_loaded = 1;
%handles.Primary_image_obj.range = [min(min(min(handles.Primary_image_obj.image_volume_data))) max(max(max(handles.Primary_image_obj.image_volume_data)))];
handles.Primary_image_obj.range = [str2num(get(handles.Primary_min, 'String')) str2num(get(handles.Primary_max, 'String'))];

% set(handles.Primary_min, 'String', num2str(handles.Primary_image_obj.range(1)));
% set(handles.Primary_max, 'String', num2str(handles.Primary_image_obj.range(2)));
%May need to revise
handles.xV = handles.Primary_image_obj.xV; handles.xV_original = handles.Primary_image_obj.xV_original;
handles.yV = handles.Primary_image_obj.yV; handles.yV_original = handles.Primary_image_obj.yV_original;
handles.zV = handles.Primary_image_obj.zV; handles.zV_original = handles.Primary_image_obj.zV_original;

handles.Primary_image_obj.color_map = handles.primary_colormap;

if ~isempty(fusion_filelist)
    out2 = DICOM_reader_CGITA(fusion_filelist);
    handles.Fusion_image_obj = make_image_obj_DICOM(out2);
    handles.Fusion_image_obj.metadata = dicominfo(fusion_filelist{1});
    handles.Fusion_images_loaded = 1;
    
    [xi,yi,zi]   = meshgrid(handles.xV, handles.yV, handles.zV);
    [x,y,z] = meshgrid(handles.Fusion_image_obj.xV, handles.Fusion_image_obj.yV, handles.Fusion_image_obj.zV);
    interp_img = interp3(x,y,z, handles.Fusion_image_obj.image_volume_data, xi,yi,zi);
    
    
    %handles.Fusion_image_obj.range = [min(min(min(handles.Primary_image_obj.image_volume_data))) max(max(max(handles.Primary_image_obj.image_volume_data)))];
    handles.Fusion_image_obj.range = [str2num(get(handles.Fusion_min, 'String')) str2num(get(handles.Fusion_max, 'String'))];
%     set(handles.Fusion_min, 'String', num2str(handles.Fusion_image_obj.range(1)));
%     set(handles.Fusion_max, 'String', num2str(handles.Fusion_image_obj.range(2)));
    
    %handles.Fusion_image_obj.color_map = bone(65536);
    handles.Fusion_image_obj.color_map = handles.fusion_colormap;

    handles.Fusion_image_for_display = handles.Fusion_image_obj;    
    handles.Fusion_image_for_display.image_volume_data = interp_img; % The display image volume is for the fusion display
    handles.Fusion_image_for_display.pixel_spacing = handles.Fusion_image_obj.pixel_spacing;
    

end

handles = refresh_display(handles);
set(handles.load_VOI_btn, 'Enable', 'on');
set(handles.direction_text, 'Visible', 'on');
set(handles.load_Fusion_btn, 'Enable', 'on');
set(handles.load_DICOMRT_btn, 'Enable', 'on');

guidata(hObject, handles);

%%%%%%% DONE UNTIL HERE!

return;


% --- Executes on button press in load_VOI_btn.
function load_VOI_btn_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to load_VOI_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if nargin == 3
    % Get the directory to load primary images from
    if exist('prev_dir.mat')
        load prev_dir.mat;
        default_dir = prev_voi_dirname;
    else
        default_dir = cd;
    end
    %default_dir = 'E:\Research Data\Texture analysis\Data_NPC_painting';
    % Primary_dir = 'D:\Data\Textural analysis\Pre_data_PET\A0001\20091019_145433.00\PET';
    %Primary_dir = 'D:\Data\Dean_temp1\1515604\20090720';
    if ~isdir(default_dir)
        default_dir = '';
    end
    [filename, pathname] = uigetfile('*.voi', 'Select VOI file', default_dir);
    voi_file = fullfile(pathname, filename);

    if isdir(pathname)        
        prev_voi_dirname = pathname;
        if exist('prev_dir.mat')
            save(which('prev_dir.mat'), 'prev_voi_dirname', '-append');
        end
    end
else
    filename = varargin{1};
    voi_file = varargin{1};
end

 % voi_file = 'D:\Data\Textural analysis\Pre_data_PET\A0001\test_roi_0322_11630340.voi';
% voi_file = 'D:\Data\Dean_temp1\PAINTING\1515604_2.0_1ST.voi';
if filename == 0
    return;
end
handles.VOI_obj = PMOD_VOI_reader_match_image(voi_file, handles);
structure_length= length(handles.VOI_obj);

for idx = 1:structure_length
    list{idx} =  handles.VOI_obj(idx).structureName;
end

set(handles.listbox1, 'String', list);
set(handles.listbox1, 'Value', 1);

handles.VOI_loaded = 1;

handles.Let_VOI_decide_slice = 1;

handles = refresh_display(handles);

handles.Let_VOI_decide_slice = 0;

guidata(hObject, handles);

return;

% rs_series = find(series_identifier==6);
% if length(rs_series)>1
%     errordlg('More than one RS structure. Cannot continue');
%     return;
% end
% 
% handles.ROI_structure = DICOM_contour_reader(series_filenames{1}.description{rs_series}.filename{1}, out1.z_location, ...
%     out1.original_x_location, out1.original_y_location, fliplr(out1.original_z_location), ...
%     out1.x_location, out1.y_location, out1.z_location);
% 
% structure_length= length(handles.ROI_structure);
% 
% for idx = 1:structure_length
%     list{idx} =  handles.ROI_structure(idx).structureName;
% end
% 
% set(handles.listbox1, 'String', list);
% 
% %handles  = display_img_ROI(hObject, eventdata, handles);
% set(handles.listbox1, 'Value', 1);
% listbox1_Callback(hObject, eventdata, handles)



function VOI_dir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to VOI_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VOI_dir_edit as text
%        str2double(get(hObject,'String')) returns contents of VOI_dir_edit as a double


% --- Executes during object creation, after setting all properties.
function VOI_dir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VOI_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CT_dir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to CT_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CT_dir_edit as text
%        str2double(get(hObject,'String')) returns contents of CT_dir_edit as a double


% --- Executes during object creation, after setting all properties.
function CT_dir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CT_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in apply_TA_button.
function varargout = apply_TA_button_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to apply_TA_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Do the texture analysis
% First, find the VOI (this function is on single VOI
gui_flag = 1;
if nargin > 3
    if strcmp(varargin{1}, 'no_gui')
        gui_flag = 0;
    end
end
if ~handles.VOI_loaded
    return;
end
if ~handles.Primary_images_loaded
    return;
end

if nargout > 0
    [handles out_mat] = TA_Callback(handles, 'Single', gui_flag);
    varargout{1} = out_mat;
else
    [handles] = TA_Callback(handles, 'Single', gui_flag);
end
% 
% [feature_stats stats_vec stat_name_val] = compute_features_stats(segmented_image_small, handles.Primary_image_obj.pixel_spacing);
% 
% texture_stat_table_GUI(stat_name_val);
%feature_table(idx_subject+1,1:8) = num2cell(stats_vec);

% Fourth, make a table for the TA results
% Fifth, show the GUI of the final results and allow users to save it. 
guidata(hObject, handles);
return;

function varargout = TA_Callback(handles, analysis_type, gui_flag)
if strcmp(analysis_type, 'Single')
    list_idx = get(handles.listbox1, 'Value');
else
    list_idx = 1:length(handles.VOI_obj);
end

for voi_idx = 1:length(list_idx)
    [handles.contour_volume handles.mask_volume first_slice last_slice] = return_volume_contour_mask(handles.VOI_obj(list_idx(voi_idx)).contour, handles);
    mask = handles.mask_volume;
    [range extended_range] = determine_mask_range(mask);
    handles.range{1} = range;
    handles.image_vol_for_TA{1}{voi_idx} = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1}) .* mask(range{3}, range{2}, range{1});
    
    handles.mask_vol_for_TA{1}{voi_idx} = mask(range{3}, range{2}, range{1});
    handles.mask_vol_for_TA_extended{1}{voi_idx} = mask(extended_range{3}, extended_range{2}, extended_range{1});
    
    % Perform the digitization
    % First, determine the digitization parameters
    switch handles.digitization_flag
        case 0 % 0 - use the min and max within the masked volume for digitization (default)
            tempimg = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1}) .* mask(range{3}, range{2}, range{1});
            digitization_min = min(tempimg(find(mask(range{3}, range{2}, range{1}))));
            digitization_max = max(tempimg(find(mask(range{3}, range{2}, range{1}))));            
        case 1 % 1 - use the min and max within the rectangular cylinder volume 
            tempimg = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1});
            digitization_min = min(tempimg(:));
            digitization_max = max(tempimg(:));            
        case 2 % 2 - use 0 and max within the masked volume for digitization
            tempimg = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1}) .* mask(range{3}, range{2}, range{1});
            digitization_min = 0;
            digitization_max = max(tempimg(find(mask(range{3}, range{2}, range{1}))));        
        case 3 % 3 - use 0 and max within the rectangular cylinder volume 
            tempimg = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1});
            digitization_min = 0;
            digitization_max = max(tempimg(:));            
        case 4 % 4 - use preset min and max values (needs to assign both values)
            digitization_min = handles.default_digitization_min;
            digitization_max = handles.default_digitization_max;                
    end
    
    tempimg = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1}) .* mask(range{3}, range{2}, range{1});
    tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
    handles.resampled_image_vol_for_TA{1}{voi_idx} = tempimg;
    
    tempimg = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1});
    tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
    handles.resampled_image_vol_for_TA_unmasked{1}{voi_idx} = tempimg;
    
    switch handles.digitization_flag
        case 0 % 0 - use the min and max within the masked volume for digitization (default)
            tempimg = handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1})  .* mask(extended_range{3}, extended_range{2}, extended_range{1});
            digitization_min = min(tempimg(find(mask(extended_range{3}, extended_range{2}, extended_range{1}))));
            digitization_max = max(tempimg(find(mask(extended_range{3}, extended_range{2}, extended_range{1}))));            
        case 1 % 1 - use the min and max within the rectangular cylinder volume 
            tempimg = handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1});
            digitization_min = min(tempimg(:));
            digitization_max = max(tempimg(:));            
        case 2 % 2 - use 0 and max within the masked volume for digitization
            tempimg = handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1})  .* mask(extended_range{3}, extended_range{2}, extended_range{1});
            digitization_min = 0;
            digitization_max = max(tempimg(find(mask(extended_range{3}, extended_range{2}, extended_range{1}))));        
        case 3 % 3 - use 0 and max within the rectangular cylinder volume 
            tempimg = handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1});
            digitization_min = 0;
            digitization_max = max(tempimg(:));            
        case 4 % 4 - use preset min and max values (needs to assign both values)
            digitization_min = handles.default_digitization_min;
            digitization_max = handles.default_digitization_max;                
    end
    
    tempimg = handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1})  .* mask(extended_range{3}, extended_range{2}, extended_range{1});
    tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
    handles.resampled_image_vol_for_TA_extended{1}{voi_idx} = tempimg;
    
    tempimg = handles.Primary_image_obj.image_volume_data(extended_range{3}, extended_range{2}, extended_range{1});
    tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
    handles.resampled_image_vol_for_TA_unmasked_extended{1}{voi_idx} = tempimg;
    
    if handles.Fusion_images_loaded
        [handles.fusion_contour_volume handles.fusion_mask_volume] = return_volume_contour_mask_Fusion_image(handles.VOI_obj(list_idx(voi_idx)).contour, handles);
        % Second, get the masked voxels
        fusion_mask = handles.fusion_mask_volume;
        % Third, send the masked voxels for texturare analysis
        [fusion_range fusion_extended_range] = determine_mask_range(fusion_mask);
        handles.range{2} = fusion_range;
        
        handles.image_vol_for_TA{2}{voi_idx} = handles.Fusion_image_obj.image_volume_data(fusion_range{3}, fusion_range{2},fusion_range{1}) .* ...
            fusion_mask(fusion_range{3}, fusion_range{2}, fusion_range{1});
        
        handles.mask_vol_for_TA{2}{voi_idx} = fusion_mask(fusion_range{3}, fusion_range{2}, fusion_range{1});
        handles.mask_vol_for_TA_extended{2}{voi_idx} = mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
        
        switch handles.digitization_flag
            case 0 % 0 - use the min and max within the masked volume for digitization (default)
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_range{3}, fusion_range{2}, fusion_range{1}) .* fusion_mask(fusion_range{3}, fusion_range{2}, fusion_range{1});
                digitization_min = min(tempimg(find(fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}))));
                digitization_max = max(tempimg(find(fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}))));
            case 1 % 1 - use the min and max within the rectangular cylinder volume
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
                digitization_min = min(tempimg(:));
                digitization_max = max(tempimg(:));
            case 2 % 2 - use 0 and max within the masked volume for digitization
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}) .* fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
                digitization_min = 0;
                digitization_max = max(tempimg(find(fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}))));
            case 3 % 3 - use 0 and max within the rectangular cylinder volume
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
                digitization_min = 0;
                digitization_max = max(tempimg(:));
            case 4 % 4 - use preset min and max values (needs to assign both values)
                digitization_min = handles.default_digitization_min;
                digitization_max = handles.default_digitization_max;
        end
    
        tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}) .* fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
        tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
        handles.resampled_image_vol_for_TA{2}{voi_idx} = tempimg;
        
        tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
        tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
        handles.resampled_image_vol_for_TA_unmasked{2}{voi_idx} = tempimg;
        
        switch handles.digitization_flag
            case 0 % 0 - use the min and max within the masked volume for digitization (default)
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}) .* fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
                digitization_min = min(tempimg(find(fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}))));
                digitization_max = max(tempimg(find(fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}))));
            case 1 % 1 - use the min and max within the rectangular cylinder volume
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
                digitization_min = min(tempimg(:));
                digitization_max = max(tempimg(:));
            case 2 % 2 - use 0 and max within the masked volume for digitization
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}) .* fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
                digitization_min = 0;
                digitization_max = max(tempimg(find(fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}))));
            case 3 % 3 - use 0 and max within the rectangular cylinder volume
                tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
                digitization_min = 0;
                digitization_max = max(tempimg(:));
            case 4 % 4 - use preset min and max values (needs to assign both values)
                digitization_min = handles.default_digitization_min;
                digitization_max = handles.default_digitization_max;
        end
        
        tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1}) ...
            .* fusion_mask(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
        tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
        handles.resampled_image_vol_for_TA_extended{2}{voi_idx} = tempimg;
        
        tempimg = handles.Fusion_image_obj.image_volume_data(fusion_extended_range{3}, fusion_extended_range{2}, fusion_extended_range{1});
        tempimg = digitize_img(tempimg, handles.digitization_type, 1, handles.digitization_bins, digitization_min, digitization_max);
        handles.resampled_image_vol_for_TA_unmasked_extended{2 }{voi_idx} = tempimg;
    end
end

handles = Perform_TA_in_GUI(handles);

varargout{1} = handles;

if gui_flag == 0
    if nargout > 1
        varargout{2} = handles.Feature_display_cell;
        if nargout > 2
            varargout{3} = handles.Feature_table;
        end
    end
else
    Textural_results_display_GUI(handles.Feature_table, handles.Feature_display_cell);
end

return;

% --- Executes on button press in apply_TA_all_VOI.
function apply_TA_all_VOI_Callback(hObject, eventdata, handles)
% hObject    handle to apply_TA_all_VOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if ~handles.VOI_loaded
%     return;
% end
% if ~handles.Primary_images_loaded
%     return;
% end
% 
% handles = TA_Callback(handles, 'All');

gui_flag = 1;
if nargin > 3
    if strcmp(varargin{1}, 'no_gui')
        gui_flag = 0;
    end
end
if ~handles.VOI_loaded
    return;
end
if ~handles.Primary_images_loaded
    return;
end

if nargout > 0
    [handles out_mat] = TA_Callback(handles, 'All', gui_flag);
    varargout{1} = out_mat;
else
    [handles] = TA_Callback(handles, 'All', gui_flag);
end

guidata(hObject, handles);

% --- Executes on button press in load_Fusion_btn.
function load_Fusion_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_Fusion_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if nargin == 3
    % Get the directory to load primary images from
    if exist('prev_dir.mat')
        load prev_dir.mat;
        default_dir = prev_in_dirname;
    else
        default_dir = cd;
    end
    %default_dir = 'E:\Research Data\Texture analysis\Data_NPC_painting';
    % Primary_dir = 'D:\Data\Textural analysis\Pre_data_PET\A0001\20091019_145433.00\PET';
    %Primary_dir = 'D:\Data\Dean_temp1\1515604\20090720';
    if ~isdir(default_dir)
        default_dir = '';
    end
    Fusion_dir = uigetdir(default_dir);
    
    if Fusion_dir == 0
        return;
    end
    if ~isdir(Fusion_dir)
        return;
    else
        prev_in_dirname = Fusion_dir;
        if exist('prev_dir.mat')
            save(which('prev_dir.mat'), 'prev_in_dirname', '-append');
        end
    end
else
    Fusion_dir = varargin{1};
end
% Parse directory and determine how many studies/series are within this
% folder and the subfolders
[filelist fusion_filelist] = parse_directory_for_dicom(Fusion_dir);
drawnow;

if isempty(fusion_filelist)
    if isempty(filelist)
        return;
    else
        fusion_filelist = filelist;
        filelist = [];
    end
end

if ~isempty(fusion_filelist)
    out2 = DICOM_reader_CGITA(fusion_filelist);
    handles.Fusion_image_obj = make_image_obj_DICOM(out2);
    handles.Fusion_image_obj.metadata = dicominfo(fusion_filelist{1});
    handles.Fusion_images_loaded = 1;
    
    [xi,yi,zi]   = meshgrid(handles.xV, handles.yV, handles.zV);
    [x,y,z] = meshgrid(handles.Fusion_image_obj.xV, handles.Fusion_image_obj.yV, handles.Fusion_image_obj.zV);
    interp_img = interp3(x,y,z, handles.Fusion_image_obj.image_volume_data, xi,yi,zi);
    
    
    %handles.Fusion_image_obj.range = [min(min(min(handles.Primary_image_obj.image_volume_data))) max(max(max(handles.Primary_image_obj.image_volume_data)))];
    handles.Fusion_image_obj.range = [str2num(get(handles.Fusion_min, 'String')) str2num(get(handles.Fusion_max, 'String'))];
%     set(handles.Fusion_min, 'String', num2str(handles.Fusion_image_obj.range(1)));
%     set(handles.Fusion_max, 'String', num2str(handles.Fusion_image_obj.range(2)));
    
    handles.Fusion_image_obj.color_map = bone(65536);
    
    handles.Fusion_image_for_display = handles.Fusion_image_obj;    
    handles.Fusion_image_for_display.image_volume_data = interp_img; % The display image volume is for the fusion display
    handles.Fusion_image_for_display.pixel_spacing = handles.Fusion_image_obj.pixel_spacing;

end

handles = refresh_display(handles);
set(handles.load_VOI_btn, 'Enable', 'on');
set(handles.direction_text, 'Visible', 'on');
set(handles.load_Fusion_btn, 'Enable', 'on');
set(handles.load_DICOMRT_btn, 'Enable', 'on');

guidata(hObject, handles);


function PET_dir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to PET_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PET_dir_edit as text
%        str2double(get(hObject,'String')) returns contents of PET_dir_edit as a double


% --- Executes during object creation, after setting all properties.
function PET_dir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PET_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axial_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axial_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.axial_axes,'currentpoint');
handles.current_j = round(a(1,1));
handles.current_i = round(a(1,2));% / 248*89*4;
guidata(hObject, handles); 

handles = refresh_display(handles);
guidata(handles.axial_axes, handles); 


% --- Executes on mouse press over axes background.
function coronal_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to coronal_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.coronal_axes,'currentpoint');
handles.current_j = round(a(1,1));
handles.current_k = round(a(1,2));% / 248*89*4;
guidata(hObject, handles); 

handles = refresh_display(handles);
guidata(handles.coronal_axes, handles); 

% --- Executes on mouse press over axes background.
function sagittal_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sagittal_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.sagittal_axes,'currentpoint');
XData = get(hObject, 'XData');
temp1 = XData(2):-1:XData(1);
handles.current_i = temp1(round(a(1,1)));
handles.current_k = round(a(1,2));% / 248*89*4;
guidata(hObject, handles); 

handles = refresh_display(handles);
guidata(handles.sagittal_axes, handles); 


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in change_location_check.
function change_location_check_Callback(hObject, eventdata, handles)
% hObject    handle to change_location_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of change_location_check


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
pointer_pos = get(hObject, 'currentpoint');
pos_panel = get(handles.uipanel6, 'Position');

axial_axes_pos = get(handles.axial_axes, 'Position');            pos1(1:2) =pos_panel(1:2) + axial_axes_pos(1:2).*pos_panel(3:4); pos1(3:4) = axial_axes_pos(3:4).*pos_panel(3:4); 
if sum(pointer_pos>pos1(1:2))==2 && sum(pointer_pos<(pos1(1:2)+pos1(3:4)))==2
    if handles.Primary_images_loaded || handles.Fusion_images_loaded
        handles.current_k = handles.current_k+eventdata.VerticalScrollCount;
        if handles.current_k < 1
            handles.current_k = 1;
        elseif handles.current_k > size(handles.Primary_image_obj.image_volume_data,3)
            handles.current_k = size(handles.Primary_image_obj.image_volume_data,3);
        end
        try
            handles = refresh_display(handles);
        catch ME
            display(ME);
        end
    end
end
    %display('within axial');

coronal_axes_pos = get(handles.coronal_axes, 'Position');            pos1(1:2) =pos_panel(1:2) + coronal_axes_pos(1:2).*pos_panel(3:4); pos1(3:4) = coronal_axes_pos(3:4).*pos_panel(3:4); 
if sum(pointer_pos>pos1(1:2))==2 && sum(pointer_pos<(pos1(1:2)+pos1(3:4)))==2
    if handles.Primary_images_loaded || handles.Fusion_images_loaded
        handles.current_i = handles.current_i+eventdata.VerticalScrollCount;
        if handles.current_i < 1
            handles.current_i= 1;
        elseif handles.current_i > size(handles.Primary_image_obj.image_volume_data,1)
            handles.current_i = size(handles.Primary_image_obj.image_volume_data,1);
        end
        try
            handles = refresh_display(handles);
        catch ME
            display(ME);
        end
    end
end

sagittal_axes_pos = get(handles.sagittal_axes, 'Position');            pos1(1:2) =pos_panel(1:2) + sagittal_axes_pos(1:2).*pos_panel(3:4); pos1(3:4) = sagittal_axes_pos(3:4).*pos_panel(3:4); 
if sum(pointer_pos>pos1(1:2))==2 && sum(pointer_pos<(pos1(1:2)+pos1(3:4)))==2
    if handles.Primary_images_loaded || handles.Fusion_images_loaded
        handles.current_j = handles.current_j+eventdata.VerticalScrollCount;
        if handles.current_j < 1
            handles.current_j= 1;
        elseif handles.current_j > size(handles.Primary_image_obj.image_volume_data,2)
            handles.current_j = size(handles.Primary_image_obj.image_volume_data,2);
        end
        try
            handles = refresh_display(handles);
        catch ME
            display(ME);
        end
    end
end

% set(handles.Img_axial, 'ButtonDownFcn', handles.axial_btndwn_fcn );
% set(handles.Img_coronal, 'ButtonDownFcn', handles.coronal_btndwn_fcn);
% set(handles.Img_sagittal, 'ButtonDownFcn', handles.sagittal_btndwn_fcn);

guidata(hObject, handles); 

return;





% --- Executes during object creation, after setting all properties.
function Primary_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Primary_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fusion_min_Callback(hObject, eventdata, handles)
% hObject    handle to Fusion_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fusion_min as text
%        str2double(get(hObject,'String')) returns contents of Fusion_min as a double
handles.Fusion_image_for_display.range = [str2num(get(handles.Fusion_min, 'String')) str2num(get(handles.Fusion_max, 'String'))];
handles = refresh_display(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Fusion_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fusion_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Primary_max_Callback(hObject, eventdata, handles)
% hObject    handle to Primary_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Primary_max as text
%        str2double(get(hObject,'String')) returns contents of Primary_max as a double
handles.Primary_image_obj.range = [str2num(get(handles.Primary_min, 'String')) str2num(get(handles.Primary_max, 'String'))];
handles = refresh_display(handles);
guidata(hObject, handles);

function Primary_min_Callback(hObject, eventdata, handles)
% hObject    handle to Primary_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Primary_min as text
%        str2double(get(hObject,'String')) returns contents of Primary_min as a double
handles.Primary_image_obj.range = [str2num(get(handles.Primary_min, 'String')) str2num(get(handles.Primary_max, 'String'))];
handles = refresh_display(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Primary_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Primary_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fusion_max_Callback(hObject, eventdata, handles)
% hObject    handle to Fusion_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fusion_max as text
%        str2double(get(hObject,'String')) returns contents of Fusion_max as a double
handles.Fusion_image_for_display.range = [str2num(get(handles.Fusion_min, 'String')) str2num(get(handles.Fusion_max, 'String'))];
handles = refresh_display(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Fusion_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fusion_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in range_contrast_checkbox.
function range_contrast_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to range_contrast_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of range_contrast_checkbox


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function fusion_factor_slider_Callback(hObject, eventdata, handles)
% hObject    handle to fusion_factor_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = refresh_display(handles);

% --- Executes during object creation, after setting all properties.
function fusion_factor_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fusion_factor_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in segment_suv_growing.
function segment_suv_growing_Callback(hObject, eventdata, handles)
% hObject    handle to segment_suv_growing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axial_axes);
[x y] = ginput(1);
seed_I =round(y);
seed_J = round(x);
seed_K = handles.current_k;
SUV_threshold = str2num(get(handles.suv_thresh, 'String'));
if isempty(SUV_threshold) 
    return;
end
L = bwlabeln(handles.Primary_image_obj.image_volume_data > SUV_threshold, 6);

slice_now = L(:,:,seed_K);

found_voxel = 0;
for idx = 1:max(slice_now(:))
    temp1 = imfill((slice_now==idx), 'holes');
    if temp1(seed_I, seed_J) == 1
        label_idx = idx;
        found_voxel = 1;
        break;
    end
end

if found_voxel == 0 
    warndlg('The segmentation could not generate a mask with this SUV. No VOI generated.');
    return;
end
%tic;
segmented_mask = zeros(size(L));
for idx = 1:size(L,3)
    slice_now = L(:,:,idx);
    if sum(sum(slice_now==label_idx)) > 1
        mask_slice = imfill((slice_now==label_idx), 'holes');
        segmented_mask(:,:,idx) = mask_slice;
    end
end

% if get(handles.strip_brain_checkbox, 'Value')
%     voi_name = ['VOI_SUV_' get(handles.suv_thresh, 'String') '_brain_removed'];
%     load spm_PET_template.mat;
%     
%     ResliceVol = img_PET_template ;
%     ResliceVol = flipdim(ResliceVol,3);
%     slice_1 = str2num(get(handles.brain_slice_start, 'String'));
%     slice_end = str2num(get(handles.brain_slice_end, 'String'));
%     
%     StandardVol = handles.Primary_image_obj.image_volume_data(:,:,slice_1:slice_end);
%     StandardVOX = handles.Primary_image_obj.pixel_spacing;
%     ResliceVOX   =  [2 2 2];
%     [Volume_out, warp_file] = SPM_Warp_3D_temp1( StandardVol, StandardVOX, ResliceVol, ResliceVOX );
%     
%     mask_PET_template = img_PET_template>100;
%     mask_PET_template = flipdim(mask_PET_template, 3);
%     img1 = apply_warping(mask_PET_template, warp_file, ResliceVOX);
%     mask_brain = (img1>0);
%     segmented_mask2 = segmented_mask;
%     segmented_mask2(:,:,slice_1:slice_end) = segmented_mask2(:,:,slice_1:slice_end)-mask_brain;
%     segmented_mask2(find(segmented_mask2<0))=0;
%     img_labeled = bwlabeln(segmented_mask2);
%     img_labeled(find(img_labeled==0)) = NaN;
%     max_label = mode(img_labeled(:));
%     segmented_mask2 = img_labeled==max_label;
% 
%     segmented_mask = segmented_mask2;
%     
% else
%     
% end
voi_name = ['VOI_SUV_' get(handles.suv_thresh, 'String')];
if length(handles.VOI_obj) < 1
    handles.VOI_obj = make_VOI_obj_from_mask(handles, segmented_mask, voi_name);
else
    handles.VOI_obj(end+1) = make_VOI_obj_from_mask(handles, segmented_mask, voi_name);
end
for idx = 1:length(handles.VOI_obj)
    a{idx} = handles.VOI_obj(idx).structureName;
end
set(handles.listbox1, 'String', a);
set(handles.listbox1, 'Value', length(handles.VOI_obj));

handles.VOI_loaded = 1;
%toc;
handles = refresh_display(handles);

guidata(hObject, handles);

return;
%seed_K = handles.current_K

%handles.current_J = 256-round(i/2)*2;
%handles.current_K = round(j/2)*2;% / 248*89*4;
% set(handles.text1, 'String', 'Performing segmentation');
% color1 = get(handles.text1, 'BackgroundColor');
% set(handles.text1, 'BackgroundColor', [1 0 0]);
% drawnow;
% handles.text1_color = color1;
% 
% seg_ratio = str2num(get(handles.edit3, 'String'));
% [P, J] = regionGrowing(handles.smoothed_pixel_data, [seed_K seed_I seed_J], handles.smoothed_pixel_data(seed_K, seed_I, seed_J)/seg_ratio);%, maxDist, tfMean, tfFillHoles, tfSimplify)
% 
% handles.current_mask = J;
% 
% handles = refresh_mask(handles.axes1, eventdata, handles);
% 
% set(handles.text1,'String', 'Segmentation completed!');
% set(handles.text1, 'BackgroundColor', color1);



function suv_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to suv_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of suv_thresh as text
%        str2double(get(hObject,'String')) returns contents of suv_thresh as a double


% --- Executes during object creation, after setting all properties.
function suv_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suv_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in project_saver.
function project_saver_Callback(hObject, eventdata, handles)
% hObject    handle to project_saver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [filename, pathname] = uiputfile('*.mat', 'Save current subject as a .mat file');
 save(fullfile(pathname, filename), 'handles');
 


% --- Executes on button press in segment_fcm.
function segment_fcm_Callback(hObject, eventdata, handles)
% hObject    handle to segment_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%
axes(handles.axial_axes);
[x y] = ginput(1);
seed_I =round(y);
seed_J = round(x);
seed_K = handles.current_k;
SUV_threshold = str2num(get(handles.suv_thresh, 'String'));
if isempty(SUV_threshold) 
    return;
end
L = bwlabeln(handles.Primary_image_obj.image_volume_data > SUV_threshold, 6);

slice_now = L(:,:,seed_K);

found_voxel = 0;
for idx = 1:max(slice_now(:))
    temp1 = imfill((slice_now==idx), 'holes');
    if temp1(seed_I, seed_J) == 1
        label_idx = idx;
        found_voxel = 1;
        break;
    end
end

if found_voxel == 0 
    warndlg('The segmentation could not generate a mask with this SUV. No VOI generated.');
    return;
end
%tic;
segmented_mask = zeros(size(L));
first_slice = Inf;
last_slice = 0;
for idx = 1:size(L,3)
    slice_now = L(:,:,idx);
    if sum(sum(slice_now==label_idx)) > 1
        mask_slice = imfill((slice_now==label_idx), 'holes');
        segmented_mask(:,:,idx) = mask_slice;
        if idx < first_slice
            first_slice = idx;
        end
        if idx > last_slice
            last_slice = idx;
        end
    end
end

first_slice = first_slice-5;
first_slice = max([1 first_slice]);

last_slice = last_slice+5;
last_slice = min([last_slice  size(handles.Primary_image_obj.image_volume_data,3)]);

%img_to_segment = zeros(size(handles.Primary_image_obj.image_volume_data));
img_to_segment = handles.Primary_image_obj.image_volume_data(:,:,first_slice:last_slice);

% prompt = {'Number of clusters:','Max number of iteration:','Iteration tolerance'};
% dlg_title = 'Input for Fuzzy C-mean';
% num_lines = 1;
% def = {'4', '40', '1e-5'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);

%n_clusters =  str2num(answer{1});
n_clusters =  str2num(get(handles.edit20, 'String'));
%[center,U,obj_fcn] = fcm(reshape(blurred, [128*128*257 1]), n_clusters);

%[center,member]=fcm(reshape(img_to_segment, [prod(size(img_to_segment)) 1]),n_clusters, [2  str2num(answer{2})  str2num(answer{3}) 1]);
[center,member]=fcm(reshape(img_to_segment, [prod(size(img_to_segment)) 1]),n_clusters, [2  40  1e-5 1]);

[center,cidx]=sort(center);
member=member';
member=member(:,cidx);
[maxmember,label]=max(member,[],2);

temp2 = zeros(size(handles.Primary_image_obj.image_volume_data));
temp2(:,:,first_slice:last_slice) = reshape(label, size(img_to_segment));

label_of_tumor = temp2(seed_I, seed_J, seed_K);

label_img2 = bwlabeln((temp2 == label_of_tumor), 6);

label_of_tumor_again = label_img2(seed_I, seed_J, seed_K);

segmented_mask = label_img2 == label_of_tumor_again;

voi_name = ['VOI_FCM'];
if length(handles.VOI_obj) < 1
    handles.VOI_obj = make_VOI_obj_from_mask(handles, segmented_mask, voi_name);
else
    handles.VOI_obj(end+1) = make_VOI_obj_from_mask(handles, segmented_mask, voi_name);
end
for idx = 1:length(handles.VOI_obj)
    a{idx} = handles.VOI_obj(idx).structureName;
end
set(handles.listbox1, 'String', a);
set(handles.listbox1, 'Value', length(handles.VOI_obj));

handles.VOI_loaded = 1;
%toc;
handles = refresh_display(handles);

guidata(hObject, handles);



%%%%%%%%%%%%%%%%%%%


return;
% --- Executes on button press in strip_brain_checkbox.
function strip_brain_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to strip_brain_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of strip_brain_checkbox



function brain_slice_start_Callback(hObject, eventdata, handles)
% hObject    handle to brain_slice_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of brain_slice_start as text
%        str2double(get(hObject,'String')) returns contents of brain_slice_start as a double


% --- Executes during object creation, after setting all properties.
function brain_slice_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brain_slice_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function brain_slice_end_Callback(hObject, eventdata, handles)
% hObject    handle to brain_slice_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of brain_slice_end as text
%        str2double(get(hObject,'String')) returns contents of brain_slice_end as a double


% --- Executes during object creation, after setting all properties.
function brain_slice_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brain_slice_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in snap_screen_btn.
function snap_screen_btn_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to snap_screen_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if nargin > 3
    foldername = varargin{1};
    filename_prefix = varargin{2};
else
    foldername = uigetdir;
    filename_prefix = 'screenshot';
end

if isempty(foldername) || ~isdir(foldername)
    return;
end
drawnow;
pause(3);
I = getframe(gcf);

imwrite(I.cdata, fullfile(foldername, [filename_prefix '.png']), 'WriteMode', 'overwrite');


% --- Executes on button press in parametric_img_btn.
function parametric_img_btn_Callback(hObject, eventdata, handles)
% hObject    handle to parametric_img_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%temp1 = parametric_FC(handles.Primary_image_obj.image_volume_data(:, :, 1:60));
%if handles.VOI_loaded
if handles.Primary_images_loaded 
    paraimg_out = parametric_img_GUI(hObject, eventdata, handles);
else
    warndlg('The primary images have not been loaded yet.');
end

return;
% mask_volume = handles.mask_volume;
% mask_small = handles.mask_vol_for_TA{1}{1};
% 
% resampled_vol = handles.resampled_image_vol_for_TA{1}{1};
%     
% tempimg = handles.Primary_image_obj.image_volume_data(range{3}, range{2}, range{1}) .* mask(range{3}, range{2}, range{1});
% 


%assignin('base', 'var1', var1)


% --- Executes on button press in load_DICOMRT_btn.
function load_DICOMRT_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_DICOMRT_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% RT_dir = uigetdir;
% if (RT_dir == 0)
%     return;
% end

if exist('prev_dir.mat')
    load prev_dir.mat;
    default_dir = prev_voi_dirname;
else
    default_dir = cd;
end
%default_dir = 'E:\Research Data\Texture analysis\Data_NPC_painting';
% Primary_dir = 'D:\Data\Textural analysis\Pre_data_PET\A0001\20091019_145433.00\PET';
%Primary_dir = 'D:\Data\Dean_temp1\1515604\20090720';
if ~isdir(default_dir)
    default_dir = '';
end
[filename, pathname] = uigetfile('*.*', 'Select DICOM-RT file', default_dir);
RT_filename = fullfile(pathname, filename);
if isdir(pathname)
    prev_voi_dirname = pathname;
    if exist('prev_dir.mat')
        save(which('prev_dir.mat'), 'prev_voi_dirname', '-append');
    end
end

series_filenames{1} = RT_filename;
% [series_filenames series_names] = DICOM_parse_dir(RT_dir);
do_fields_table= [8 4158; 8 49; 8 32; 8 4144; 32 16; 8 8487; 16 16; 8 96];
dicomdict('set', 'dicom-dict_truncated');

for idx = 1:length(series_filenames)
    temphdr =  dicominfo(series_filenames{idx}, do_fields_table);
    series_type{idx} = temphdr.Modality;
    switch temphdr.Modality
        case 'CT'
            series_identifier(idx)  = 1;
        case 'PET'
            series_identifier(idx)  = 2;
        case 'MRI'
            series_identifier(idx)  = 3;
        case 'RTDOSE'
            series_identifier(idx)  = 4;
        case 'RTPLAN'
            series_identifier(idx)  = 5;
        case 'RTSTRUCT'
            series_identifier(idx)  = 6;
    end
end

dicomdict('factory');

rs_series = find(series_identifier==6);
if length(rs_series)>1
    errordlg('More than one RS structure. Cannot continue');
    return;
elseif length(rs_series)<1
    errordlg('No RT structure found in this file');
    return;
end

%handles.VOI_obj = PMOD_VOI_reader_match_image(voi_file, handles);
handles.VOI_obj = DICOMRT_reader_match_image(series_filenames{1}, handles);

structure_length= length(handles.VOI_obj);

for idx = 1:structure_length
    list{idx} =  handles.VOI_obj(idx).structureName;
end

set(handles.listbox1, 'String', list);
set(handles.listbox1, 'Value', 1);

handles.VOI_loaded = 1;

handles.Let_VOI_decide_slice = 1;

handles = refresh_display(handles);

handles.Let_VOI_decide_slice = 0;
% handles.ROI_structure = DICOM_contour_reader(series_filenames{1}.description{rs_series}.filename{1}, out1.z_location, ...
%     out1.original_x_location, out1.original_y_location, fliplr(out1.original_z_location), ...
%     out1.x_location, out1.y_location, out1.z_location);

% structure_length= length(handles.ROI_structure);
% 
% for idx = 1:structure_length
%     list{idx} =  handles.ROI_structure(idx).structureName;
% end
% 
% set(handles.listbox1, 'String', list);
% 
% pix_Z = out1.pixelSpacing(3);
% pix_X = out1.pixelSpacing(1);
% loc1 = get(handles.coronal_axes, 'Position');
% temp1 = pix_X * size(handles.CT_img,1)/pix_Z;
% loc1 = [loc1(1:3) temp1];
% set(handles.coronal_axes, 'Position', loc1);
% 
% loc1 = get(handles.sagittal_axes, 'Position');
% loc1 = [loc1(1:3) temp1];
% set(handles.sagittal_axes, 'Position', loc1);
% 
% handles.xV = out1.x_location;
% handles.yV = out1.y_location;
% handles.zV = out1.z_location;
% %handles  = display_img_ROI(hObject, eventdata, handles);
% set(handles.listbox1, 'Value', 1);
% listbox1_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setting_button.
function setting_button_Callback(hObject, eventdata, handles)
% hObject    handle to setting_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load user_feature_settings.mat;

prompt={['Digitization settings' 10 10 10 'Digitization method:' 10 '0 - use the min and max within the masked volume for digitization' ...
    10 '1 - use the min and max within the rectangular cylinder volume' 10 '2 - use 0 and max within the masked volume for digitization',...
    10 '3 - use 0 and max within the rectangular cylinder volume ' ...
    10 '4 - use preset min and max values (needs to assign both values)'], ...
    'Preset min:', 'Preset max:', 'Digitization bins', [10 'Display settins:' 10 'Default colormap for Primary'], 'Default colormap for Fusion'};

name='CGITA seetings';
numlines=1;

defaultanswer={num2str(digitization_flag), num2str(default_digitization_min), num2str(default_digitization_max), num2str(digitization_bins), ...
    default_primary_colormap, default_fusion_colormap};

answer=inputdlg(prompt,name,numlines,defaultanswer);

if  (round(str2num(answer{1}))-str2num(answer{1}))==0 &&  str2num(answer{1})<5
    digitization_flag =  str2num(answer{1});
end
default_digitization_min = str2num(answer{2});
default_digitization_max = str2num(answer{3});
digitization_bins = str2num(answer{4});
default_primary_colormap = answer{5};
default_fusion_colormap = answer{6};

save user_feature_settings.mat digitization_flag default_digitization_min default_digitization_max digitization_bins -append;
save user_feature_settings.mat default_fusion_colormap default_primary_colormap -append;

handles.digitization_flag = digitization_flag;
handles.default_digitization_min = default_digitization_min;
handles.default_digitization_max = default_digitization_max;
handles.digitization_bins = digitization_bins;

%handles.primary_colormap_name = default_primary_colormap;
%handles.fusion_colormap_name = default_fusion_colormap;

guidata(hObject, handles);

return;



% --- Executes on button press in cgita_web_btn.
function cgita_web_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cgita_web_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stat = web('http://code.google.com/p/cgita', '-browser');
if stat > 0
    stat = web('http://code.google.com/p/cgita');
end


% --- Executes on selection change in primary_color.
function primary_color_Callback(hObject, eventdata, handles)
% hObject    handle to primary_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns primary_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from primary_color
tempstr = get(handles.primary_color, 'String');
handles.primary_colormap_name = tempstr{get(handles.primary_color, 'Value')};
tempstr = get(handles.fusion_color, 'String');
handles.fusion_colormap_name = tempstr{get(handles.fusion_color, 'Value')};

eval(['handles.primary_colormap = ' handles.primary_colormap_name '(65536);']);
eval(['handles.fusion_colormap = ' handles.fusion_colormap_name '(65536);']);

handles.Primary_image_obj.color_map = handles.primary_colormap;
handles.Fusion_image_obj.color_map = handles.fusion_colormap;
handles.Fusion_image_for_display.color_map = handles.fusion_colormap;

handles = refresh_display(handles);

guidata(hObject, handles);
return;

% --- Executes during object creation, after setting all properties.
function primary_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to primary_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fusion_color.
function fusion_color_Callback(hObject, eventdata, handles)
% hObject    handle to fusion_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fusion_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fusion_color
tempstr = get(handles.primary_color, 'String');
handles.primary_colormap_name = tempstr{get(handles.primary_color, 'Value')};
tempstr = get(handles.fusion_color, 'String');
handles.fusion_colormap_name = tempstr{get(handles.fusion_color, 'Value')};

eval(['handles.primary_colormap = ' handles.primary_colormap_name '(65536);']);
eval(['handles.fusion_colormap = ' handles.fusion_colormap_name '(65536);']);

handles.Primary_image_obj.color_map = handles.primary_colormap;
handles.Fusion_image_obj.color_map = handles.fusion_colormap;
handles.Fusion_image_for_display.color_map = handles.fusion_colormap;

handles = refresh_display(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fusion_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fusion_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
