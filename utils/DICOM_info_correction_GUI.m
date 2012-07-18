function varargout = DICOM_info_correction_GUI(varargin)
% DICOM_INFO_CORRECTION_GUI MATLAB code for DICOM_info_correction_GUI.fig
%      DICOM_INFO_CORRECTION_GUI, by itself, creates a new DICOM_INFO_CORRECTION_GUI or raises the existing
%      singleton*.
%
%      H = DICOM_INFO_CORRECTION_GUI returns the handle to a new DICOM_INFO_CORRECTION_GUI or the handle to
%      the existing singleton*.
%
%      DICOM_INFO_CORRECTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOM_INFO_CORRECTION_GUI.M with the given input arguments.
%
%      DICOM_INFO_CORRECTION_GUI('Property','Value',...) creates a new DICOM_INFO_CORRECTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DICOM_info_correction_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DICOM_info_correction_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DICOM_info_correction_GUI

% Last Modified by GUIDE v2.5 01-Jun-2012 12:58:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DICOM_info_correction_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DICOM_info_correction_GUI_OutputFcn, ...
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


% --- Executes just before DICOM_info_correction_GUI is made visible.
function DICOM_info_correction_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DICOM_info_correction_GUI (see VARARGIN)

% Choose default command line output for DICOM_info_correction_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DICOM_info_correction_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DICOM_info_correction_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in_dir = uigetdir;
if isempty(in_dir) | in_dir == 0;
    return
end
filelist = parse_directory_for_dicom(in_dir);
study_header = dicominfo(filelist{1});

if ~isfield(study_header, 'PatientID')
    study_header.PatientID = 'N/A';
end
if ~isfield(study_header, 'PatientName')
    study_header.PatientName.FamilyName = 'N/A';
elseif ~isfield(study_header.PatientName, 'FamilyName')
    study_header.PatientName.FamilyName = 'N/A';
end
if ~isfield(study_header, 'PatientBirthDate')
    study_header.PatientBirthDate = 'N/A';
end
if ~isfield(study_header, 'StudyDate')
    study_header.StudyDate = 'N/A';
end
if ~isfield(study_header, 'PatientID')
    study_header.Units = 'N/A';
end

str1 = ['Subject information' 10 '---------------------------------' 10 ...
    'Patient ID: ' study_header.PatientID ' ' 10 ...
    'Patient Name: ' study_header.PatientName.FamilyName ' ' 10 ...
    'Birthdate: ' study_header.PatientBirthDate ' ' 10 ... 
    'Study Date: ' study_header.StudyDate ' ' 10 ...
    'Units: ' study_header.Units ' ' 10];

set(handles.text1, 'String', str1);

set([handles.dosetime handles.doseact handles.halflife handles.weight handles.seriestime], 'BackgroundColor', [0.895 0.5,  0]);

if isfield(study_header, 'RadiopharmaceuticalInformationSequence')
    if isfield(study_header.RadiopharmaceuticalInformationSequence.Item_1, 'RadiopharmaceuticalStartTime')
        set(handles.dosetime, 'String', study_header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime);
        if isnumeric(str2num(study_header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime)) && ~isempty(study_header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime)
            set(handles.dosetime, 'BackgroundColor', [1 1 1]);
        end
    else
        study_header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime = 'N/A';
    end
    if isfield(study_header.RadiopharmaceuticalInformationSequence.Item_1, 'RadionuclideTotalDose')
        set(handles.doseact, 'String', study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose);
        if isnumeric(study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose) && ~isempty(study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose)
            set(handles.doseact, 'BackgroundColor', [1 1 1]);
        end
    else
        study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose = 'N/A';
    end
    if isfield(study_header.RadiopharmaceuticalInformationSequence.Item_1, 'RadionuclideHalfLife')
        set(handles.halflife, 'String', study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife);
        if isnumeric(study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife) && ~isempty(study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife)
            set(handles.halflife, 'BackgroundColor', [1 1 1]);
        end
    else
        study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife = 'N/A';
    end
else
    study_header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime = 'N/A';
    study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose = 'N/A';
    study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife = 'N/A';
end
if isfield(study_header, 'PatientWeight')
    set(handles.weight, 'String', study_header.PatientWeight);
    if isnumeric((study_header.PatientWeight)) && ~isempty(study_header.PatientWeight)
        set(handles.weight, 'BackgroundColor', [1 1 1]);
    end
else
    study_header.PatientWeight = 'N/A';
end
if isfield(study_header, 'SeriesTime')
    set(handles.seriestime, 'String', study_header.SeriesTime);
    if isnumeric(str2num(study_header.SeriesTime)) && ~isempty(study_header.SeriesTime)
        set(handles.seriestime, 'BackgroundColor', [1 1 1]);
    end
else
    study_header.SeriesTime = 'N/A';
end

handles.filelist = filelist;

handles.study_header = study_header;

guidata(hObject, handles);

return;


function weight_Callback(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weight as text
%        str2double(get(hObject,'String')) returns contents of weight as a double


% --- Executes during object creation, after setting all properties.
function weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dosetime_Callback(hObject, eventdata, handles)
% hObject    handle to dosetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dosetime as text
%        str2double(get(hObject,'String')) returns contents of dosetime as a double


% --- Executes during object creation, after setting all properties.
function dosetime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dosetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seriestime_Callback(hObject, eventdata, handles)
% hObject    handle to seriestime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seriestime as text
%        str2double(get(hObject,'String')) returns contents of seriestime as a double


% --- Executes during object creation, after setting all properties.
function seriestime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seriestime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function doseact_Callback(hObject, eventdata, handles)
% hObject    handle to doseact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of doseact as text
%        str2double(get(hObject,'String')) returns contents of doseact as a double


% --- Executes during object creation, after setting all properties.
function doseact_CreateFcn(hObject, eventdata, handles)
% hObject    handle to doseact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function halflife_Callback(hObject, eventdata, handles)
% hObject    handle to halflife (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of halflife as text
%        str2double(get(hObject,'String')) returns contents of halflife as a double


% --- Executes during object creation, after setting all properties.
function halflife_CreateFcn(hObject, eventdata, handles)
% hObject    handle to halflife (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outdir = uigetdir;
if isempty(outdir) | outdir==0
    return;
elseif isdir(outdir)
    set(handles.text12, 'String', ['Output dir: ' outdir]);
    handles.outdir = outdir;
end
guidata(hObject, handles);
return;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'outdir')
    errordlg('Select the output folder first');
    return;
end
% Check if all fields are entered with data
if ~isnumeric(str2num(get(handles.weight, 'String'))) || ...
        ~isnumeric(str2num(get(handles.weight, 'String'))) || ...
        ~isnumeric(str2num(get(handles.dosetime, 'String'))) || ...
        ~isnumeric(str2num(get(handles.seriestime, 'String'))) || ...
        ~isnumeric(str2num(get(handles.doseact, 'String'))) || ...
        ~isnumeric(str2num(get(handles.halflife, 'String')))
    answer = questdlg('Some of the fields may not be accurately entered. Continue?', 'Please confirm', 'Yes', 'No', 'Yes');
    if strcmp(answer, 'No')
        return;
    end
end
anony_flag = 0;
weight_flag = 0;
dosetime_flag = 0;
seriestime_flag = 0;
doseact_flag = 0;
halflife_flag = 0;

% Check if the anonymization function is checked
if get(handles.radiobutton1, 'Value')
    anony_flag = 1;
end
if str2num(get(handles.weight, 'String')) ~= handles.study_header.PatientWeight
    weight_flag = 1;
end
if isempty(handles.study_header.PatientWeight)
    weight_flag = 1;
end
if ~strcmp(get(handles.dosetime, 'String'), handles.study_header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime )
    dosetime_flag = 1;
end
if isempty(handles.study_header.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime )
    dosetime_flag = 1;
end
if ~strcmp(get(handles.seriestime, 'String'), handles.study_header.SeriesTime)
    seriestime_flag = 1;
end
if isempty(handles.study_header.SeriesTime)
    seriestime_flag = 1;
end
if str2num(get(handles.doseact, 'String')) ~= handles.study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose
    doseact_flag = 1;
end
if isempty(handles.study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose)
    doseact_flag = 1;
end
    
if str2num(get(handles.halflife, 'String'))~= handles.study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife
    halflife_flag = 1;
end
if isempty(handles.study_header.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife)
    halflife_flag = 1;
end

filelist = handles.filelist;
for idx = 1:length(filelist)
    [PATHSTR,NAME,EXT] = fileparts(filelist{idx});
    outfilename = fullfile(handles.outdir, NAME, EXT);
    X = dicomread(filelist{idx});
    if anony_flag
        dicomanon(filelist{idx}, outfilename);
        metadata = dicominfo(outfilename);        
        metadata.SeriesDescription = handles.study_header.SeriesDescription;
    else
        metadata = dicominfo(filelist{idx});
    end
    if weight_flag
        metadata.PatientWeight = str2num(get(handles.weight, 'String'));
    end
    
    if seriestime_flag
        metadata.SeriesTime = get(handles.seriestime, 'String');
    end
    
    if dosetime_flag
        metadata.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime = get(handles.dosetime, 'String');
    end
    if doseact_flag
        metadata.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose = str2num(get(handles.doseact, 'String'));
    end
    if halflife_flag
        metadata.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife = str2num(get(handles.halflife, 'String'));
    end
    dicomwrite(X, outfilename, metadata, 'CreateMode', 'copy');

end

h = msgbox('File modification has been completed.');
return;
% Perform the file correction

% Hint: get(hObject,'Value') returns toggle state of pushbutton3
