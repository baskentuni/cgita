function varargout = DICOM_parse_dir(varargin)
% DICOM_parse_dir: Parse the directory for DICOM files; NOTE: It does the
% subfolders too! 
% The dicom_Dean_rev reads only a subset of the header so it's much faster
% than dicominfo
% varargin: first input should be a directory containing DICOM files
if nargin == 0
    dir_in = uigetdir;
else
    dir_in = varargin{1};
end

if isempty(dir_in) || ~isdir(dir_in)
    display('Not a folder');
    return;
end

all_files_list = list_all_files(dir_in, {}, '');
dirlen = length(all_files_list);

do_fields_table= [8 4158; 8 49; 8 32; 8 4144; 32 16; 8 8487; 16 16; 8 96];
dicomdict('set', 'dicom-dict_truncated');

study_ID = [];  % create empty cell array
study_description_name = {};


for i = 1:dirlen
    
    info = dicominfo_Dean_rev(all_files_list{i}, do_fields_table);
    
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

dicomdict('factory');

varargout{1} = study_description;
varargout{2} = study_description_name;

return;