function varargout = parse_directory_for_dicom(dirname);

all_files_list = list_all_files(dirname, {}, '');

%cd(handles.dicom_folder);

% % Alternative option
% dirname = get(handles.original_dir,'String');
% if ~isdir(dirname)
%     errordlg('This is not a valid folder');
%     return;
% end

%a = dir(dirname);
study_ID = [];  % create empty cell array
study_description_name = {};
% description_location = {};
%b = ls(dirname);
%dirlen = length(b)-2; % must subtract "." & ".." 2 elements
dirlen = length(all_files_list);
filelist = {};
if dirlen ==0
    return;
end

do_fields_table= [8 4158; 8 49; 8 32; 8 4144; 32 16; 8 8487; 16 16; 8 16];
dicomdict('set', 'dicom-dict_truncated');

%tic
timing_n = floor(dirlen/20);

h = waitbar(0,'Parsing the directory for DICOM files. Please wait...');
steps = dirlen;

for i = 1:dirlen
    %dicomread = fullfile(handles.dicom_folder, a(i+2).name);
    %info = dicominfo(all_files_list{i});
    if mod(i, timing_n) == 0
        waitbar(i / steps);
    end
    if exist('dcmreadfile')
        info = dcmreadfile(all_files_list{i});
    else
        info = dicominfo_Dean_rev(all_files_list{i}, do_fields_table);
    end
    
    if ~isempty(info) && isfield(info, 'StudyID')
        %warndlg('No dicom files found');
    %else
        find_location = strcmp(study_ID, info.StudyID);  % "find(study_ID == info.StudyID)" is unavailable because info.StudyID is a string
        if sum(find_location) == 0
            % new ID for the ID List
            study_ID{end+1} = info.StudyID;
            find_location = length(study_ID);
            study_description_name{find_location}.description{1} = info.SeriesDescription;
            study_description{find_location}.description{1}.filename{1} = all_files_list{i};
        else
            % ID already exists in list
            if isfield(study_description{find_location}, 'description')
                description_location = find(strcmp(study_description_name{find_location}.description, info.SeriesDescription));
                if isempty(description_location)
                    study_description_name{find_location}.description{end+1} = info.SeriesDescription;
                    study_description{find_location}.description{end+1}.filename{1} = all_files_list{i};
                else
                    study_description{find_location}.description{description_location}.filename{end+1} = all_files_list{i};
%                     study_description_name{find_location}.description{description_location} = info.SeriesDescription;
                end
            else
                study_description_name{find_location}.description{1} = info.SeriesDescription;
                study_description{find_location}.description{1}.filename{1} = all_files_list{i};
            end
        end
    end
    
end
close(h)

dicomdict('factory');

table_content = {};
datatable = {};
for i = 1:length(study_ID)
    for j = 1:length(study_description_name{i}.description)
        if exist('dcmreadfile')
            fileinfo = dcmreadfile(study_description{i}.description{j}.filename{1});
        else
            fileinfo = dicominfo(study_description{i}.description{j}.filename{1});
        end
        if ~isfield(fileinfo.PatientName, 'GivenName')
            fileinfo.PatientName.GivenName = 'N/A';
        end
        if ~isfield(fileinfo.PatientName, 'FamilyName')
            fileinfo.PatientName.FamilyName = 'N/A';
        end
        
        if ~isfield(fileinfo, 'SeriesTime')
            datatable(end+1,:) = {study_description{i}.description{j}.filename, []};
            fileinfo.SeriesTime = 'N/A';
        else
            datatable(end+1,:) = {study_description{i}.description{j}.filename, fileinfo.SeriesTime};
        end
        
        table_content(end+1,:) = {false, false, fileinfo.PatientID, fileinfo.PatientName.FamilyName, fileinfo.PatientName.GivenName, study_ID{i}, study_description_name{i}.description{j}, fileinfo.StudyDate, fileinfo.SeriesTime, ...
            length(study_description{i}.description{j}.filename), false};
        
    end
end

if size(datatable,1) == 1
    % simple case. Return the list.
    filelist = study_description{1}.description{1}.filename;
else
    [filelist fusion_filelist] = DICOM_selection_GUI(datatable, table_content, fileinfo, study_ID, study_description);
end

varargout{1} = filelist;
if exist('fusion_filelist')
    varargout{2} = fusion_filelist;
else
    varargout{2} = '';
end

return;
