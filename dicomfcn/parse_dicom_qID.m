function [patient_id_list patient_name_list patients_list] = parse_dicom_qID(result, flag)

loc1 = strfind(result, 'Find Response: ');
loc1(end+1) = length(result)+1;

if length(loc1) == 0
    patients_list = [];
    return;
end
for idx = 1:length(loc1)-1
    str_part = result(loc1(idx):loc1(idx+1)-1);
    if flag>3
        patients_list{idx}.SOPUID = retrieve_str(str_part, '(0008,0018) UI ', ']');
        %         patients_list{idx}.SeriesDate = retrieve_str(str_part, '(0008,0021) DA ',']');
        %         patients_list{idx}.SeriesInstanceUID = retrieve_str(str_part, '(0020,000e) UI ', ']');
        %
    else
        patients_list{idx}.PatientName = retrieve_str(str_part, '(0010,0010) PN ', ']');
        patients_list{idx}.PatientID = retrieve_str(str_part, '(0010,0020) LO ', ']');
        if patients_list{idx}.PatientID(end) == ' '
            patients_list{idx}.PatientID = patients_list{idx}.PatientID(1:end-1);
        end
        patients_list{idx}.PatientBD = retrieve_str(str_part, '(0010,0030) DA ', ']');
        patients_list{idx}.StudyInstanceUID = retrieve_str(str_part, '(0020,000d) UI ', ']');
        if flag>1
            patients_list{idx}.StudyDescription = retrieve_str(str_part, '(0008,1030) LO ', ']');
            if patients_list{idx}.StudyDescription(end) == ' '
                patients_list{idx}.StudyDescription = patients_list{idx}.StudyDescription(1:end-1);
            end
            patients_list{idx}.StudyDate = retrieve_str(str_part, '(0008,0020) DA ',']');
        end
        if flag>2
            patients_list{idx}.SeriesDescription = retrieve_str(str_part, '(0008,103e) LO ', ']');
            if patients_list{idx}.SeriesDescription(end) == ' '
                patients_list{idx}.SeriesDescription = patients_list{idx}.SeriesDescription(1:end-1);
            end
            patients_list{idx}.SeriesDate = retrieve_str(str_part, '(0008,0021) DA ',']');
            patients_list{idx}.SeriesTime = retrieve_str(str_part, '(0008,0031) TM ',']');
            patients_list{idx}.SeriesInstanceUID = retrieve_str(str_part, '(0020,000e) UI ', ']');
        end
    end
end
if flag>3
    patient_id_list = [];
    patient_name_list = [];
    return;
end
patient_id_list{1} = patients_list{1}.PatientID;
patient_name_list{1} = patients_list{1}.PatientName;

if length(loc1)-1>1
    for idx = 2:length(loc1)-1
        found = 0;
        for idx2 = 1:length(patient_id_list)
            if strcmp(patient_id_list{idx2}, patients_list{idx}.PatientID)
                if strcmp(patient_name_list{idx2}, patients_list{idx}.PatientName)
                    found = 1;
                    break;
                end
            end
        end
        if found == 0
            patient_id_list{end+1} = patients_list{idx}.PatientID;
            patient_name_list{end+1} = patients_list{idx}.PatientName;
        end
    end
end

return;

function str_out = retrieve_str(str1, str2, str3)
loc1 = strfind(str1, str2);
loc1 = loc1(1);
if str1(loc1+length(str2)) == '('
    str3 = ')';
end
str_temp = str1(loc1+length(str2)+1:end);
loc2 = strfind(str_temp, str3);
loc2 = loc2(1);
str_out = str_temp(1:loc2-1);
return;