function varargout = DICOM_selection_GUI(varargin)
% DICOM_SELECTION_GUI MATLAB code for DICOM_selection_GUI.fig
%      DICOM_SELECTION_GUI, by itself, creates a new DICOM_SELECTION_GUI or raises the existing
%      singleton*.
%
%      H = DICOM_SELECTION_GUI returns the handle to a new DICOM_SELECTION_GUI or the handle to
%      the existing singleton*.
%
%      DICOM_SELECTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOM_SELECTION_GUI.M with the given input arguments.
%
%      DICOM_SELECTION_GUI('Property','Value',...) creates a new DICOM_SELECTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DICOM_selection_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DICOM_selection_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DICOM_selection_GUI

% Last Modified by GUIDE v2.5 21-Mar-2012 10:45:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DICOM_selection_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DICOM_selection_GUI_OutputFcn, ...
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


% --- Executes just before DICOM_selection_GUI is made visible.
function DICOM_selection_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DICOM_selection_GUI (see VARARGIN)

% Choose default command line output for DICOM_selection_GUI
handles.output = hObject;
axes(handles.axes1);
axis off;

datatable = varargin{1};
table_content = varargin{2};
fileinfo = varargin{3};
study_ID = varargin{4};
study_description = varargin{5};

%columnname = {'Select to save', 'Paitent ID', 'Last name','Given Name','Study ID', 'Series Description', 'Date', 'NumFiles', 'Select to preview'};
%columnformat = {'logical', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'logical'};
%columneditable = [true false false false false false true];
set(handles.property_table, 'Units', 'characters', 'Data', table_content);%, 'ColumnName', columnname, 'ColumnFormat', columnformat, 'ColumnEditable', columneditable);

% figure;
% t = uitable('Parent', 'Data', datatable);
handles.datatable = datatable;
handles.fileinfo = fileinfo;
handles.study_ID = study_ID;
handles.study_description = study_description;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DICOM_selection_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = DICOM_selection_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles, 'output')
    varargout{1} = handles.output;
    if isfield(handles, 'fusion_filelist')
        varargout{2} = handles.fusion_filelist;
    else
        varargout{2} = '';
    end    
end
delete(handles.figure1);
drawnow;
return;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value1 = get(handles.property_table, 'Data');
value2 = handles.datatable(:,2);

for idx = 1: size(value1,1)
    if cell2mat(value1(idx,1)) == 1
        Date = value1{idx,5};
        Time = value2{idx};
    end
end
if sum(cell2mat(value1(:,1))) == 0
    if sum(cell2mat(value1(:,2))) == 0
        warndlg('None of the studies were selected. Select at least one study.', '!! Warning !!');
        return;
    end
    
elseif sum(cell2mat(value1(:,1))) >1
    warndlg('More than one study was selected. Select only one study.', '!! Warning !!');
    return;
end

handles.output = cell(1000,1);
counter = 0;
for i = 1:size(value1, 1)
    if cell2mat(value1(i,1)) == 1
        ctfiles = handles.datatable{i,1};
        for j = 1:size(ctfiles, 2)
            counter = counter+1;            
            handles.output{counter} = ctfiles{1,j};
        end
    end
end
if counter == 0;
    handles.output = [];
else
    handles.output = handles.output(1:counter);
end

if sum(cell2mat(value1(:,2))) > 0
    if sum(cell2mat(value1(:,1))) >1
        warndlg('More than one study was selected for fusion images. Select only one study.', '!! Warning !!');
        guidata(hObject, handles);
        uiresume;
        return;
    end
else
    guidata(hObject, handles);
    uiresume;
    return;
end

handles.fusion_filelist = cell(1000,1);
counter = 0;
for i = 1:size(value1, 1)
    if cell2mat(value1(i,2)) == 1
        ctfiles = handles.datatable{i,1};
        for j = 1:size(ctfiles, 2)
            counter = counter+1;            
            handles.fusion_filelist{counter} = ctfiles{1,j};
        end
    end
end
if counter == 0;
    handles.fusion_filelist = [];
else
    handles.fusion_filelist = handles.fusion_filelist(1:counter);
end
guidata(hObject, handles);
uiresume;

return;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = {};
guidata(hObject, handles);
uiresume;


% --- Executes during object creation, after setting all properties.
function property_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to property_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function property_table_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to property_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when selected cell(s) is changed in property_table.
function property_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to property_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

 % --- Executes when entered data in editable cell(s) in property_table.
function property_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to property_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% Tick one checkbox once only; if user ticks more than one checkbox, the error message will be diplayed 
value = get(hObject,'Data');
[r c] = size(value);
if eventdata.Indices(2) == c
    if sum(cell2mat(value(:,end))) >= 2
        for idx1 = 1:size(value,1)
            value{idx1,eventdata.Indices(2)} = false;
        end
        value{eventdata.Indices(1), eventdata.Indices(2)} = true;
    end
    axes(handles.axes1);
    img_idx = ceil(value{eventdata.Indices(1), eventdata.Indices(2)-1}/2);
    ctfiles = handles.datatable{eventdata.Indices(1),1};
    img = dicomread(ctfiles{1,img_idx});
    if length(size(img))>2
        img = img(:,:, ceil(size(img,3)/2));       
    end
     imagesc(img); axis off;
end

set(hObject, 'Data', value);

% if sum(cell2mat(value(:,1))) >= 2
%     errordlg('Please tick one checkbox once only !!');
% end
guidata(hObject, handles);
% num = size(value, 1);
% for k = 1:num
%     if value{k,1}
%           value{k,1} = value{k,1} + 1;
%           if value{k,1} >= 2
%               errordlg('Please tick one checkbox once only !!');
%           end
%     end
% end


% % --- Executes on button press in dicomdir.
% function dicomdir_Callback(hObject, eventdata, handles)
% % hObject    handle to dicomdir (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of dicomdir
% 
% % loaddcmdir();
% % function [dcmSeries, dcmPatient, SeriesList, SeriesListNumInfo, ImageInfos, SeriesInfos] = loaddcmdir(dicomdirpath);
% % try
%     hm = [];
%     dcmSeries = []; dcmPatient = []; SeriesList = [];  SeriesListNumInfo = []; ImageInfos = []; SeriesInfos = [];
%     ImgPrcTlbx = ver('images');
%     ImgPrcTlbxVersion = str2double(ImgPrcTlbx.Version(1));
%     if ImgPrcTlbxVersion < 4
%         disp('The required minimum version of ImgProc. Toolbox is 4!');
%         return; 
%     end
%     
% % 	if nargin == 0 | strcmp(dicomdirpath,'')  
%          dicomdirpath = uigetdir('','Select DICOMDIR folder');
%          if dicomdirpath == 0
%              return;
%          end
% %     end
%     filename1mat = fullfile(dicomdirpath,'dicomdir.mat');  
%     dirres1mat = dir(filename1mat);
%     filename1 = fullfile(dicomdirpath,'dicomdir');
%     dirres1 = dir(filename1);
%     filename2 = fullfile(dicomdirpath,'DICOMDIR');
%     dirres2 = dir(filename2);
%     if ~isempty(dirres1mat)
%         % if the dicomdir mat structure was saved on the first time
%         % open it. It is much faster than reading the DICOMDIR dicom file
%         load(filename1mat);
%         SeriesListNumInfo = dcmdir.SeriesListNumInfo;
%         SeriesList = dcmdir.SeriesList;
%         dcmPatient = dcmdir.dcmPatient;
%         dcmSeries = dcmdir.dcmSeries;
%         clear dcmdir;
%         disp(' ');
%         disp('load dicomdir.mat');
%         disp(' ');
%     else
%         if ~isempty(dirres1)
%             dcmdir_path = filename1;
%         elseif ~isempty(dirres2) 
%             dcmdir_path = filename2;
%         else
%             hm = msgbox('No DICOMDIR in the selected folder !','MIA Info','warn' );
%             disp('No DICOMDIR in the selected folder !')
%             return;
%         end
% 
% 
%         % Show up message window and set the cursor type to "watch"  
%         hm = msgbox('Reading the DICOMDIR structure. It takes time. Please wait!','MIA Info' );
%         set(hm, 'tag', 'Msgbox_MIA Info');
%         SetData=setptr('watch');set(hm,SetData{:});
%         hmc = (get(hm,'children'));
%         set(hmc(2),'enable','inactive');
%         pause(1);
% 
%         % open DICOMDIR file & read DirectoryRecordSequence structure 
%         dcmhdr = dicominfo(dcmdir_path);
%         delete(hm);
% 
%         % Read the DirectoryRecordSequence structure until end,
%         % and read the all included DirectoryRecordType item sequentially
%         DirRecords = dcmhdr.DirectoryRecordSequence;
%         DirRecordsFieldNames = fieldnames(DirRecords);
%         NumOfField = size(DirRecordsFieldNames,1);
%         CurrentPatient = 0;
%         SeriesListNum = 0;
%         waitbar_h = waitbar(0,'Scanning the DICOM files....');
%         table_content2 = {};                                 %%%%%%%%%%%%%%%%
%         for i = 1: NumOfField
%             CurrentItem = getfield(DirRecords,DirRecordsFieldNames{i});
%             CurrentItemType = getfield(CurrentItem,'DirectoryRecordType');
%             if strcmp(CurrentItemType,'PATIENT')
%                 CurrentPatient = CurrentPatient + 1;
%                 CurrentStudy = 0;
%                 if ImgPrcTlbxVersion > 4
%                     if isfield(CurrentItem,'PatientName')
%                         dcmPatient(CurrentPatient,1).PatientName = ...
%                             CurrentItem.PatientName.FamilyName;
%                     else
%                         dcmPatient(CurrentPatient,1).PatientName = 'No value available';
%                     end
%                 elseif ImgPrcTlbxVersion == 4
%                     if isfield(CurrentItem,'PatientsName')
%                         dcmPatient(CurrentPatient,1).PatientName = ...
%                             CurrentItem.PatientsName.FamilyName;
%                     else
%                         dcmPatient(CurrentPatient,1).PatientName = 'No value available';
%                     end
%                 end
%             elseif strcmp(CurrentItemType,'STUDY')
%                 CurrentStudy = CurrentStudy + 1; 
%                 CurrentSeries = 0;
%                 if isfield(CurrentItem,'StudyDescription')
%                     dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).StudyDescription = ...
%                         CurrentItem.StudyDescription;
%                 else
%                     dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).StudyDescription = '';
%                 end
%             elseif strcmp(CurrentItemType,'SERIES')
%                 if CurrentSeries > 0 % create summary about the previous read series for popupmenu
%                     SeriesListNum = SeriesListNum + 1;
%                     Pname = dcmPatient(CurrentPatient,1).PatientName;
%                     Modality = dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1).Modality;
%                     SeriesDescription = dcmPatient(CurrentPatient,1).Study(CurrentStudy,1). ...
%                         Series(CurrentSeries,1).SeriesDescription;
% %                     StudyDate = dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).StudyDate;   %%
% %                     StudyID = dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).StudyID;   %%
%                     
%                     StudyDescription = dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).StudyDescription;
%                     NumOfImages = num2str(CurrentImage);
%                     SeriesList{SeriesListNum} = [Pname,',  ',Modality,',  SeriesDescr: ', SeriesDescription, ...
%                         ',  StudyDesc: ', StudyDescription, ',  Number of Images: ',NumOfImages];
%                     SeriesListNumInfo(SeriesListNum).PatientNum = CurrentPatient;
%                     SeriesListNumInfo(SeriesListNum).StudyNum = CurrentStudy;
%                     SeriesListNumInfo(SeriesListNum).SeriesNum = CurrentSeries;
%                 end
%                 CurrentSeries = CurrentSeries + 1;
%                 CurrentImage = 0;
%                 dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1).Modality = ...
%                     CurrentItem.Modality;
%                 if isfield(CurrentItem,'SeriesDescription')
%                     dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1). ...
%                         SeriesDescription = CurrentItem.SeriesDescription;
%                 else
%                     dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1). ...
%                         SeriesDescription = '';
%                 end
%                 %%%
%                 if isfield(CurrentItem,'SeriesInstanceUID')
%                     SeriesInfos{CurrentSeries,1} = CurrentItem.SeriesInstanceUID;
%                 else
%                     SeriesInfos{CurrentSeries,1} = '';
%                 end
%                 if isfield(CurrentItem,'SeriesNumber')
%                     SeriesInfos{CurrentSeries,2} = CurrentItem.SeriesNumber;
%                 else
%                     SeriesInfos{CurrentSeries,2} = 0;
%                 end
%                 %%%
%             elseif strcmp(CurrentItemType,'IMAGE')
%                 CurrentImage = CurrentImage + 1;
%                 [pathstr, dcmfname, ext] = fileparts(CurrentItem.ReferencedFileID);
%                 if CurrentImage == 1
%                     dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1). ...
%                         ImagePath = pathstr;
%                 end
%                 if ispc 
%                     dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1). ...
%                         ImageNames{CurrentImage,1} = CurrentItem.ReferencedFileID;
%                 else
%                     dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1). ...
%                         ImageNames{CurrentImage,1} = strrep(CurrentItem.ReferencedFileID,'\','/');
%                 end
%                 %ImageNames{CurrentImage,1} = dcmfname;
%                 dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1). ...
%                     ReferencedSOPInstanceUIDInFile{CurrentImage,1} = CurrentItem.ReferencedSOPInstanceUIDInFile;
%                 %%%
%                 ImageInfos{i,1} = [pathstr,filesep,dcmfname];
%                 if isfield(CurrentItem,'InstanceNumber')
%                     ImageInfos{i,2} = CurrentItem.InstanceNumber;
%                 else
%                     ImageInfos{i,2} = 0;
%                 end
%                 if isfield(CurrentItem,'ImageType')
%                     ImageInfos{i,3} = CurrentItem.ImageType;
%                 else
%                     ImageInfos{i,3} = '';
%                 end
%                 ImageInfos{i,4} = CurrentItem.ReferencedSOPInstanceUIDInFile;
%                 ImageInfos{i,5} = SeriesInfos{CurrentSeries,1};
%                 ImageInfos{i,6} = CurrentSeries;
%                 ImageInfos{i,7} = SeriesInfos{CurrentSeries,2};
%                 %%%%
%             end
%             waitbar(i/NumOfField,waitbar_h);
%             drawnow;
%         end
%         close(waitbar_h);
%         % create summary about the last read series for popupmenu
%         SeriesListNum = SeriesListNum + 1;
%         Pname = dcmPatient(CurrentPatient,1).PatientName;
%         Modality = dcmPatient(CurrentPatient,1).Study(CurrentStudy,1).Series(CurrentSeries,1).Modality;
%         SeriesDescription = dcmPatient(CurrentPatient,1).Study(CurrentStudy,1). ...
%             Series(CurrentSeries,1).SeriesDescription;
%         NumOfImages = num2str(CurrentImage);
%         SeriesList{SeriesListNum} = [Pname,',  ',Modality,',  SeriesDesc: ', SeriesDescription, ...
%             ',  StudyDesc: ', StudyDescription,',  Number of Images: ',NumOfImages];
%         SeriesListNumInfo(SeriesListNum).PatientNum = CurrentPatient;
%         SeriesListNumInfo(SeriesListNum).StudyNum = CurrentStudy;
%         SeriesListNumInfo(SeriesListNum).SeriesNum = CurrentSeries;
%         
%        
%         table_content2(SeriesListNum,:) = {false, Modality{SeriesListNum}, SeriesDescription{SeriesListNum}, Pname{SeriesListNum}, StudyDescription{SeriesListNum}};      %%%%
%         columnname = {'Available', 'Study ID', 'Series Description', 'Patient Name', 'Date'};
%         columnformat = {'logical', 'numeric', 'numeric', 'numeric', 'numeric'};
%         columneditable = [true false false false false];
%         set(handles.property_table, 'Units', 'characters', 'Data', table_content2, 'ColumnName', columnname, 'ColumnFormat', columnformat, 'ColumnEditable', columneditable);
%         try
%             dcmdir.SeriesListNumInfo = SeriesListNumInfo;
%             dcmdir.SeriesList = SeriesList;
%             dcmdir.dcmPatient = dcmPatient;
%             dcmdir.dcmSeries = dcmSeries;
%             save(filename1mat,'dcmdir');
%         catch
%             % Unable to write file 'filename1mat' permission denied.
%         end
%         
%     end
%     
% %     table_content2 = {};
% % 
% %     for i = 1:length(SeriesListNum)
% %         for j = 1:length(study_description_name{i}.description)
% %             fileinfo2 = dicominfo(study_description{i}.description{j}.filename{1});
% %             table_content2(end+1,:) = {false, Modality, SeriesDescription, Pname, StudyDescription};
% %         end
% %     end
% % %     table_content2 = {false, dcmhdr.StudyID, dcmhdr.SeriesDescription, dcmhdr.PatientName.FamilyName, dcmhdr.StudyDate};
% %     
% 
% 
%     % create popupmenu for dicomseries
% %     global dcmdirlistVal;
% %     dcmdirlistVal = 0;
% %     dcmdirlistfh = figure('menubar','none','NumberTitle','off','name','DICOMDIR info','position',[250   400   760   520]);
% %     lbh = uicontrol('Style','listbox','Position',[10 60 720 440],'tag','dcmdirlist_popupmenu');
% %     set(lbh,'string',SeriesList);
% %     OKCallback = 'global dcmdirlistVal; dcmdirlistVal = get(findobj(''tag'',''dcmdirlist_popupmenu''),''value''); delete(findobj(''name'',''DICOMDIR info''));';
% %     CancelCallback = 'delete(findobj(''name'',''DICOMDIR info''));';
% %     OK_h = uicontrol('Style', 'pushbutton', 'String', 'OK','Position', [440 10 80 30], 'Callback', OKCallback);
% %     Cancel_h = uicontrol('Style', 'pushbutton', 'String', 'Cancel','Position', [340 10 80 30], 'Callback', CancelCallback);
% %     
% %     uiwait(dcmdirlistfh);
% %     
% %     if dcmdirlistVal == 0;
% %         disp('No DICOM Series was selected!');
% %         return;
% %     end
%     
% %     % create the outputs
% %     dcmSeriesPath = dcmPatient(SeriesListNumInfo(dcmdirlistVal).PatientNum). ...
% %         Study(SeriesListNumInfo(dcmdirlistVal).StudyNum). ...
% %         Series(SeriesListNumInfo(dcmdirlistVal).SeriesNum). ...
% %         ImagePath;
% %     dcmSeries.Path = [dicomdirpath,filesep];
% %     dcmSeries.dicomdirpath = [dicomdirpath, filesep, dcmSeriesPath, filesep];
% %     %dcmSeries.Path = [dicomdirpath, filesep, dcmSeriesPath, filesep];
% %     %dcmSeries.dicomdirpath = dicomdirpath;
% %     dcmSeries.Images = dcmPatient(SeriesListNumInfo(dcmdirlistVal).PatientNum). ...
% %         Study(SeriesListNumInfo(dcmdirlistVal).StudyNum). ...
% %         Series(SeriesListNumInfo(dcmdirlistVal).SeriesNum). ...
% %         ImageNames;
% 
% guidata(hObject, handles);
