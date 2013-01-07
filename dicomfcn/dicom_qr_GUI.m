function varargout = dicom_qr_GUI(varargin)
% DICOM_QR_GUI MATLAB code for dicom_qr_GUI.fig
%      DICOM_QR_GUI, by itself, creates a new DICOM_QR_GUI or raises the existing
%      singleton*.
%
%      H = DICOM_QR_GUI returns the handle to a new DICOM_QR_GUI or the handle to
%      the existing singleton*.
%
%      DICOM_QR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOM_QR_GUI.M with the given input arguments.
%
%      DICOM_QR_GUI('Property','Value',...) creates a new DICOM_QR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dicom_qr_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dicom_qr_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dicom_qr_GUI

% Last Modified by GUIDE v2.5 03-Jan-2013 08:47:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dicom_qr_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @dicom_qr_GUI_OutputFcn, ...
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


% --- Executes just before dicom_qr_GUI is made visible.
function dicom_qr_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dicom_qr_GUI (see VARARGIN)

% Choose default command line output for dicom_qr_GUI
handles.output = hObject;

fid1 = -1;
if exist('DICOM_settings.txt')
    fid1 = fopen(which('DICOM_settings.txt'), 'r');    
elseif exist('D:\Work\Common Functions\DICOM_settings.txt')
    fid1 = fopen('D:\Work\Common Functions\DICOM_settings.txt');
elseif exist(fullfile(pwd, 'DICOM_settings.txt'))
    fid1 = fopen(fullfile(pwd, 'DICOM_settings.txt'), 'r');
end
if fid1>0
    set(handles.edit1, 'String', fgetl(fid1));
    set(handles.edit6, 'String', fgetl(fid1));
    set(handles.edit2, 'String', fgetl(fid1));
    set(handles.edit3, 'String', fgetl(fid1));
    set(handles.edit4, 'String', fgetl(fid1));
end
fclose(fid1);

set(handles.axes1, 'Units', 'pixels');
pos1 = get(handles.axes1, 'Position');

[handles.tree container] = uitree('v0', gcf, 'Root', [], 'Position', pos1);
set(container,'Parent',handles.figure1);
% [tree, container]= uitree('v0');
%     set(container,'Parent',handles);
import javax.swing.*
import javax.swing.tree.*;
root = uitreenode('v0','root','DICOM Server',[],false);
treeModel = DefaultTreeModel(root);    
handles.tree.setModel(treeModel);
set(handles.tree, 'NodeWillExpandCallback', {@nodeWillExpandFcn, handles});
set(handles.tree, 'NodeSelectedCallback', {@nodeWillExpandFcn, handles});
set(handles.tree, 'Visible', 0);    
handles.tree.setRoot(root);
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

function nodeWillExpandFcn(TreeH, EventData, DlgH, extra)
EventNodeH = EventData.getCurrentNode;
TreeH.expand(EventNodeH);
if isempty(get(EventNodeH, 'UserData'))
    return;
else
    tempdata = get(EventNodeH, 'UserData');
    level = tempdata{1};
    handles = DlgH;
    dcmaet = get(handles.edit1, 'String');
    dcmaec = get(handles.edit2, 'String');
    dcmhost =get(handles.edit3, 'String');
    dcmport =get(handles.edit4, 'String');
    
    exe_loc = which('findscu.exe');

    switch level
        case 'patient'
            EventNodeH.removeAllChildren;
            selected_pid = tempdata{2};
            selected_pname = tempdata{3};
            
            command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ...
                ' -k 0010,0020=' selected_pid ' -k 0010,0030="' selected_pname '"  -k 0020,000D -k 0010,0010 -k 0010,0030 -k 0008,1030 -k 0008,0020 ' dcmhost ' ' dcmport];
            
            setptr(handles.figure1,'watch')
            [status, result] = system(command_str);
            setptr(handles.figure1,'arrow')
            [id_list name_list patients_list] = parse_dicom_qID(result, 2);
            
            for idx = 1:length(patients_list)
                StudyName = ['Date: ' patients_list{idx}.StudyDate '  |  Study: ' patients_list{idx}.StudyDescription];
                NodeTmp = uitreenode('v0', [], StudyName, [], false);
                set(NodeTmp, 'UserData', {'study', patients_list{idx}.PatientID, patients_list{idx}.StudyInstanceUID});
                EventNodeH.add(NodeTmp);
            end
            TreeH.reloadNode(EventNodeH);
            TreeH.expand(EventNodeH);
            handles.sid_list = id_list;
            handles.sname_list = name_list;
            handles.spatients_list = patients_list;
            
        case 'study'
            EventNodeH.removeAllChildren;
            selected_pid = tempdata{2};
            selected_study_ID = tempdata{3};
            command_str = ['"' exe_loc '" -v  --patient -k 0008,0052=SERIES -aet ' dcmaet ' -aec ' dcmaec ...
                ' -k 0010,0020=' selected_pid ' -k 0020,000D="' selected_study_ID '"  -k 0010,0010 -k 0010,0030 -k 0008,1030 -k 0008,0020 -k 0008,0021 -k 0020,000E  -k 0008,0031  -k 0008,103E   ' dcmhost ' ' dcmport];
            
            setptr(handles.figure1,'watch')
            [status, result] = system(command_str);
            setptr(handles.figure1,'arrow')
            [id_list name_list patients_list] = parse_dicom_qID(result, 3);
            
            for idx = 1:length(patients_list)
                SeriesName = ['Series: ' patients_list{idx}.SeriesDescription '  |  ' patients_list{idx}.SeriesDate '@' patients_list{idx}.SeriesTime];
                NodeTmp = uitreenode('v0', [], SeriesName, [], false);
                set(NodeTmp, 'UserData', {'series', patients_list{idx}.PatientID, patients_list{idx}.SeriesInstanceUID, ...
                    patients_list{idx}.SeriesDate, patients_list{idx}.SeriesDescription, patients_list{idx}.StudyInstanceUID});
                EventNodeH.add(NodeTmp);
            end
            TreeH.reloadNode(EventNodeH);
            TreeH.expand(EventNodeH);
            handles.series_id_list = id_list;
            handles.series_name_list = name_list;
            handles.series_patients_list = patients_list;
        case 'series'
            selected_pid = tempdata{2};
            selected_series_ID = tempdata{3};
%             handles.selected_pid = selected_pid;
%             handles.selected_series_ID = selected_series_ID;
            
            command_str = ['"' exe_loc '" -v  --patient -k 0008,0052=IMAGE -aet ' dcmaet ' -aec ' dcmaec ...
                ' -k 0010,0020=' selected_pid ' -k 0020,000E="' selected_series_ID '"  -k 0008,0018 ' dcmhost ' ' dcmport];

            setptr(handles.figure1,'watch')
            [status, result] = system(command_str);
            setptr(handles.figure1,'arrow');
            [id_list name_list patients_list] = parse_dicom_qID(result, 4);
            set(handles.pushbutton6, 'String', ['This series contains ' num2str(length(patients_list)) ' files. Click to get files.']);
%             handles.selected_series_ID = selected_series_ID;
%             handles.files_patients_list = patients_list;
            
            store_dir = fullfile(tempdir,tempdata{2}, tempdata{4}, tempdata{5});
            set(handles.edit7, 'String', store_dir);
            
            handles.to_retrieve.StudyInstanceUID = tempdata{6};
            handles.to_retrieve.SeriesInstanceUID = selected_series_ID;

    end
    DlgH = handles;
    guidata(DlgH.figure1, DlgH);
end
return;
%     if TreeH.isLoaded(EventNodeH)
%         NodeUD = get(EventNodeH, 'UserData');
%     end
%     stop;
%     
%     Nodo1 = uitreenode('v0','Nodo1','LEAF 1',[],false);
%     Nodo2 = uitreenode('v0','Nodo2','LEAF 2',[],true);
%     Nodo3 = uitreenode('v0','Nodo3','LEAF 3',[],true);
%     root.add(Nodo1);
%     root.add(Nodo2);
%     root.add(Nodo3);
%     treeModel = DefaultTreeModel(root);
%     handles.tree.setModel(treeModel);
%     handles.tree.setSelectedNode(Nodo1);
%     
% --- Outputs from this function are returned to the command line.
function varargout = dicom_qr_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(handles)
    varargout{1} = [];
end
if isfield(handles,'output')
    varargout{1} = handles.output;
else
    varargout{1} = [];
end
if isfield(handles, 'figure1')
    delete(handles.figure1);
end
return;


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
%return;
dcmaet = get(handles.edit1, 'String');
dcmaec = get(handles.edit2, 'String');
dcmhost =get(handles.edit3, 'String');
dcmport =get(handles.edit4, 'String');

exe_loc = which('findscu.exe');
command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0010,0010 -k 0010,0030 ' dcmhost ' ' dcmport];
import javax.swing.*
import javax.swing.tree.*;

setptr(handles.figure1,'watch')
[status, result] = system(command_str);
setptr(handles.figure1,'arrow')
[id_list name_list patients_list] = parse_dicom_qID(result,1);
root = get(handles.tree, 'Root');
root.removeAllChildren;

for idx = 1:length(id_list)
    %patient_table{idx, 1} = false;
    patient_table{idx, 1} = id_list{idx};
    patient_table{idx, 2} = name_list{idx};
    patient_table{idx, 3} = patients_list{idx}.PatientBD;
    if get(handles.checkbox1, 'Value')
        PatientInfo = ['ID: ' id_list{idx} '; Name: ' name_list{idx}];
    else
        PatientInfo = [id_list{idx}];
    end
    Nodo = uitreenode('v0',['Nodo' num2str(idx)],PatientInfo,[],false);
    set(Nodo,  'UserData', {'patient', id_list{idx}, name_list{idx}});
    root.add(Nodo);
end

treeModel = DefaultTreeModel(root);
handles.tree.setModel(treeModel);
handles.tree.expand(root);
set(handles.tree, 'Visible', 1);
handles.id_list = id_list;
handles.name_list = name_list;
handles.patients_list = patients_list;

guidata(hObject, handles);
%command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0008,0020 ' dcmhost ' ' dcmport];
%opcommand1 = 'findscu.exe -v -P -k 0010,0020="182501" -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104';
%-v --patient -k 0008,0052=PATIENT -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104

%opcommand1 = ['findscu.exe -v "(0010,0020)=2158*"'  ' -aet ', dcmaet,' -aec ',dcmaec, ...
%    dcmhost,' ',dcmport];
%  Nodo = uitreenode('v0','Nodo1','LEAF 1',[],false);
%     Nodo2 = uitreenode('v0','Nodo2','LEAF 2',[],true);
%     Nodo3 = uitreenode('v0','Nodo3','LEAF 3',[],true);
%     root.add(Nodo1);
%     root.add(Nodo2);
%     root.add(Nodo3);
%     treeModel = DefaultTreeModel(root);
%     handles.tree.setModel(treeModel);
% set(handles.uitable1, 'Data', patient_table, 'ColumnEditable', [false false false], ...
%     'ColumnName',{'Patient ID', 'Patient Name', 'Patient Birthdate'}, 'ColumnWidth', {'auto' 200 'auto'});
% 
% set(handles.uitable2, 'Data', {});
% set(handles.uitable3, 'Data', {});


return;

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
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
dcmaet = get(handles.edit1, 'String');
dcmaec = get(handles.edit2, 'String');
dcmhost =get(handles.edit3, 'String');
dcmport =get(handles.edit4, 'String');

exe_loc = which('findscu.exe');
command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0010,0010 -k 0010,0030 ' dcmhost ' ' dcmport];
import javax.swing.*
import javax.swing.tree.*;

setptr(handles.figure1,'watch')
[status, result] = system(command_str);
setptr(handles.figure1,'arrow')
[id_list name_list patients_list] = parse_dicom_qID(result,1);
root = get(handles.tree, 'Root');
root.removeAllChildren;

for idx = 1:length(id_list)
    %patient_table{idx, 1} = false;
    patient_table{idx, 1} = id_list{idx};
    patient_table{idx, 2} = name_list{idx};
    patient_table{idx, 3} = patients_list{idx}.PatientBD;
    Nodo = uitreenode('v0',['Nodo' num2str(idx)],id_list{idx},[],false);
    set(Nodo,  'UserData', {'patient', id_list{idx}, name_list{idx}});
    root.add(Nodo);
end

treeModel = DefaultTreeModel(root);
handles.tree.setModel(treeModel);
set(handles.tree, 'Visible', 1);
handles.id_list = id_list;
handles.name_list = name_list;
handles.patients_list = patients_list;

guidata(hObject, handles);
return;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'patients_list')
    return;
end
if isempty(handles.patients_list)
    return;
end
data= get(handles.uitable1, 'Data');
if sum(cell2mat(data(:,1))) > 1
    errordlg('Select only one patient');
end
selected_idx = find(cell2mat(data(:,1))==1);
selected_pid = data{selected_idx,2};
selected_pname = data{selected_idx,3};
dcmaet = get(handles.edit1, 'String');
dcmaec = get(handles.edit2, 'String');
dcmhost =get(handles.edit3, 'String');
dcmport =get(handles.edit4, 'String');

exe_loc = which('findscu.exe');
%command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0008,0020 ' dcmhost ' ' dcmport];
command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ...
    ' -k 0010,0020=' selected_pid ' -k 0010,0030="' selected_pname '"  -k 0020,000D -k 0010,0010 -k 0010,0030 -k 0008,1030 -k 0008,0020 ' dcmhost ' ' dcmport];
%opcommand1 = 'findscu.exe -v -P -k 0010,0020="182501" -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104';
%-v --patient -k 0008,0052=PATIENT -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104

%opcommand1 = ['findscu.exe -v "(0010,0020)=2158*"'  ' -aet ', dcmaet,' -aec ',dcmaec, ...
%    dcmhost,' ',dcmport];

setptr(handles.figure1,'watch')
[status, result] = system(command_str);
setptr(handles.figure1,'arrow')
[id_list name_list patients_list] = parse_dicom_qID(result, 2);

for idx = 1:length(patients_list)
    %patient_table{idx, 1} = false;
    patient_table{idx, 1} = patients_list{idx}.PatientID;
    patient_table{idx, 2} = patients_list{idx}.PatientName;
    patient_table{idx, 3} = patients_list{idx}.StudyDate;
    patient_table{idx, 4} = patients_list{idx}.StudyDescription;
    %patient_table{idx, 4} = patients_list{idx}.PatientBD;
end
set(handles.uitable2, 'Data', patient_table, 'ColumnEditable', [true false false false false], ...
    'ColumnName',{ 'Patient ID', 'Patient Name', 'Study Date', 'Study Description'}, 'ColumnWidth', {'auto' 200 'auto' 'auto'});

return;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

%eventdata
if numel(eventdata.Indices)==0
    return;
end
if ~isfield(handles, 'patients_list')
    return;
end
if isempty(handles.patients_list)
    return;
end
data= get(handles.uitable1, 'Data');
% if sum(cell2mat(data(:,1))) > 1
%     errordlg('Select only one patient');
% end
selected_idx =  eventdata.Indices(1);
selected_pid = data{selected_idx,1};
selected_pname = data{selected_idx,2};
dcmaet = get(handles.edit1, 'String');
dcmaec = get(handles.edit2, 'String');
dcmhost =get(handles.edit3, 'String');
dcmport =get(handles.edit4, 'String');

exe_loc = which('findscu.exe');
%command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0008,0020 ' dcmhost ' ' dcmport];
command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ...
    ' -k 0010,0020=' selected_pid ' -k 0010,0030="' selected_pname '"  -k 0020,000D -k 0010,0010 -k 0010,0030 -k 0008,1030 -k 0008,0020 ' dcmhost ' ' dcmport];
%opcommand1 = 'findscu.exe -v -P -k 0010,0020="182501" -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104';
%-v --patient -k 0008,0052=PATIENT -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104

%opcommand1 = ['findscu.exe -v "(0010,0020)=2158*"'  ' -aet ', dcmaet,' -aec ',dcmaec, ...
%    dcmhost,' ',dcmport];

setptr(handles.figure1,'watch')
[status, result] = system(command_str);
setptr(handles.figure1,'arrow')
[id_list name_list patients_list] = parse_dicom_qID(result, 2);

for idx = 1:length(patients_list)
    %patient_table{idx, 1} = false;
    %patient_table{idx, 1} = patients_list{idx}.PatientID;
    %patient_table{idx, 2} = patients_list{idx}.PatientName;
    patient_table{idx, 1} = patients_list{idx}.StudyDate;
    patient_table{idx, 2} = patients_list{idx}.StudyDescription;
    %patient_table{idx, 4} = patients_list{idx}.PatientBD;
end
set(handles.uitable2, 'Data', patient_table, 'ColumnEditable', [false false false false], ...
    'ColumnName',{'Study Date', 'Study Description'}, 'ColumnWidth', { 'auto' 300 });

handles.sid_list = id_list;
handles.sname_list = name_list;
handles.spatients_list = patients_list;
set(handles.uitable3, 'Data',{});

guidata(hObject, handles);
return;

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
%eventdata
if numel(eventdata.Indices)==0
    return;
end
if ~isfield(handles, 'spatients_list')
    return;
end
if isempty(handles.spatients_list)
    return;
end
data= get(handles.uitable2, 'Data');
% if sum(cell2mat(data(:,1))) > 1
%     errordlg('Select only one patient');
% end
selected_idx =  eventdata.Indices(1);
selected_pid = handles.spatients_list{selected_idx}.PatientID;
selected_study_ID = handles.spatients_list{selected_idx}.StudyInstanceUID;
dcmaet = get(handles.edit1, 'String');
dcmaec = get(handles.edit2, 'String');
dcmhost =get(handles.edit3, 'String');
dcmport =get(handles.edit4, 'String');

exe_loc = which('findscu.exe');
%command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0008,0020 ' dcmhost ' ' dcmport];
command_str = ['"' exe_loc '" -v  --patient -k 0008,0052=SERIES -aet ' dcmaet ' -aec ' dcmaec ...
    ' -k 0010,0020=' selected_pid ' -k 0020,000D="' selected_study_ID '"  -k 0020,000D -k 0010,0010 -k 0010,0030 -k 0008,1030 -k 0008,0020 -k 0008,0021 -k 0020,000E  -k 0008,0021  -k 0008,103E ' dcmhost ' ' dcmport];
%opcommand1 = 'findscu.exe -v -P -k 0010,0020="182501" -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104';
%-v --patient -k 0008,0052=PATIENT -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104

%opcommand1 = ['findscu.exe -v "(0010,0020)=2158*"'  ' -aet ', dcmaet,' -aec ',dcmaec, ...
%    dcmhost,' ',dcmport];

setptr(handles.figure1,'watch')
[status, result] = system(command_str);
setptr(handles.figure1,'arrow')
[id_list name_list patients_list] = parse_dicom_qID(result, 3);

for idx = 1:length(patients_list)
    %patient_table{idx, 1} = false;
    %patient_table{idx, 1} = patients_list{idx}.PatientID;
    %patient_table{idx, 2} = patients_list{idx}.PatientName;
    %patient_table{idx, 1} = patients_list{idx}.StudyDate;
    %patient_table{idx, 2} = patients_list{idx}.StudyDescription;
    patient_table{idx, 1} = patients_list{idx}.SeriesDate;
    patient_table{idx, 2} = patients_list{idx}.SeriesDescription;
    %patient_table{idx, 4} = patients_list{idx}.PatientBD;
end
set(handles.uitable3, 'Data', patient_table, 'ColumnEditable', [false false], ...
    'ColumnName',{'Series Date', 'Series Description'}, 'ColumnWidth', { 'auto' 300 });

handles.series_id_list = id_list;
handles.series_name_list = name_list;
handles.series_patients_list = patients_list;

guidata(hObject, handles);


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dcmaet = get(handles.edit1, 'String');
dcmaec = get(handles.edit2, 'String');
dcmhost =get(handles.edit3, 'String');
dcmport =get(handles.edit4, 'String');
dcmaet_port = get(handles.edit6, 'String');
exe_loc = which('movescu.exe');

%command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0008,0020 ' dcmhost ' ' dcmport];
% command_str = ['"' exe_loc '" --study -k 0008,0052=SERIES -aet ' dcmaet ' -aec ' dcmaec ' -aec ' dcmaec...
%      ' -k 0020,000D=' handles.series_patients_list{1}.StudyInstanceUID ' ' ...
%      ' -k 0020,000E=' handles.series_patients_list{1}.SeriesInstanceUID '  -k 0008,0018 -v ' dcmhost ' ' dcmport];

store_dir = get(handles.edit7, 'String');
command_str = ['"' exe_loc '" --study -k 0008,0052=SERIES -od "' store_dir '" -aet ' dcmaet ' -aec ' dcmaec  ' -aem ' dcmaet ...
     ' -k 0020,000D=' handles.to_retrieve.StudyInstanceUID ' ' ...
     ' -k 0020,000E=' handles.to_retrieve.SeriesInstanceUID '  -k 0008,0018 -v ' dcmhost ' ' dcmport '  +P ' dcmaet_port];
[status, result] = system(command_str);
cd1 = cd;
if ~isdir(store_dir)
    [success message1] = mkdir(store_dir);
    if ~success
        errordlg(['Enable to make a new director for storing the DICOM images' 10 'Message: ' 10 message1]);
        return;
    end
end
cd(store_dir);
dir_result = dir(store_dir);
if length(dir_result)<3
    warndlg(['No files were retrived.' 10 'Message:' 10 result]);
    return;
end
dir_result = dir_result(3:end);
for idx = 1:length(dir_result)
    filelist{idx} = fullfile(store_dir, dir_result(idx).name);
end
cd(cd1);
handles.output = filelist;
guidata(hObject, handles);
uiresume(handles.figure1);
%result
%  command_str
%  
% [status, result] = system(' storescp -v 104 --output-directory D:\tmp2\ -xf storescp.cfg Default -sp ');
return;

% --- Executes when selected cell(s) is changed in uitable3.
function uitable3_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if numel(eventdata.Indices)==0
    return;
end
if ~isfield(handles, 'spatients_list')
    return;
end
if isempty(handles.spatients_list)
    return;
end
%data= get(handles.uitable2, 'Data');
% if sum(cell2mat(data(:,1))) > 1
%     errordlg('Select only one patient');
% end
selected_idx =  eventdata.Indices(1);
selected_pid = handles.series_patients_list{selected_idx}.PatientID;
selected_study_ID = handles.series_patients_list{selected_idx}.StudyInstanceUID;
selected_series_ID = handles.series_patients_list{selected_idx}.SeriesInstanceUID;
dcmaet = get(handles.edit1, 'String');
dcmaec = get(handles.edit2, 'String');
dcmhost =get(handles.edit3, 'String');
dcmport =get(handles.edit4, 'String');
exe_loc = which('findscu.exe');
%command_str = ['"' exe_loc '" -v --patient -k 0008,0052=STUDY -aet ' dcmaet ' -aec ' dcmaec ' -k 0010,0020=' get(handles.edit5, 'String')  '*  -k 0020,000D -k 0008,0020 ' dcmhost ' ' dcmport];
command_str = ['"' exe_loc '" -v  --patient -k 0008,0052=IMAGE -aet ' dcmaet ' -aec ' dcmaec ...
    ' -k 0010,0020=' selected_pid ' -k 0020,000E="' selected_series_ID '"  -k 0008,0018 ' dcmhost ' ' dcmport];
%opcommand1 = 'findscu.exe -v -P -k 0010,0020="182501" -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104';
%-v --patient -k 0008,0052=PATIENT -aet PMODAMIC214 -aec CGMHAEA1  -k 0010,0010 -k 0010,0020 -k 0010,0030 -k 0010,0040 10.30.129.126 104

%opcommand1 = ['findscu.exe -v "(0010,0020)=2158*"'  ' -aet ', dcmaet,' -aec ',dcmaec, ...
%    dcmhost,' ',dcmport];

setptr(handles.figure1,'watch')
[status, result] = system(command_str);
setptr(handles.figure1,'arrow');
[id_list name_list patients_list] = parse_dicom_qID(result, 4);
set(handles.pushbutton6, 'String', [num2str(length(patients_list)) ' files. Get them!']);
handles.selected_series_ID = selected_series_ID;
handles.files_patients_list = patients_list;

store_dir = fullfile(tempdir,handles.series_patients_list{selected_idx}.PatientID, handles.series_patients_list{selected_idx}.StudyDate, handles.series_patients_list{selected_idx}.SeriesDescription);
%store_dir
%idx = 1;
%for idx = 1:length(store_dir)-1
% while(idx<length(store_dir))
%     if store_dir(idx) == ' '
%         store_dir = [store_dir(1:idx-1) store_dir(idx+1:end)];
%     end
%     idx = idx+1;
% end
%store_dir
set(handles.edit7, 'String', store_dir);
guidata(hObject, handles);

return;



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
