function ROI_struct = DICOMRT_reader_match_image(filename, handles);%, zV, x1, y1, z1, x2, y2, z2)
zV = -fliplr(handles.zV_original);

dicom_hdr = dicominfo(filename);

names_field1 = fieldnames(dicom_hdr.ROIContourSequence);
names_field2 = fieldnames(dicom_hdr.StructureSetROISequence);

ROI_n = numel(names_field1);

name_list = {};
for idx = 1:ROI_n 
    current_ROI_obj = getfield(dicom_hdr.StructureSetROISequence, names_field2{idx});
    name_list{current_ROI_obj.ROINumber} = current_ROI_obj.ROIName;
end

% out1.x_location = out1.x_location/10;
% out1.y_location = out1.y_location/10;
% out1.z_location = out1.z_location/10;
% out1.original_x_location = out1.original_x_location/10;
% out1.original_y_location = out1.original_y_location/10;
% out1.original_z_location = out1.original_z_location/10;
% 
% handles.CT_img = out1.pixelData;
% 
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
% 





for idx = 1:ROI_n 
%     if idx == 10
%         display('here');
%     end
    current_ROI_obj                        = getfield(dicom_hdr.ROIContourSequence, names_field1{idx});
    ROI_struct(idx).roiNumber        = current_ROI_obj.ReferencedROINumber;
    ROI_struct(idx).structureName = name_list{current_ROI_obj.ReferencedROINumber};
    if isfield(current_ROI_obj, 'ContourSequence')
        temp1= align_contour_on_slices(current_ROI_obj.ContourSequence, handles.zV, handles.xV_original, handles.yV_original, fliplr(handles.zV_original), ...
            handles.xV, handles.yV, handles.zV);
        ROI_struct(idx).contour = temp1.contour;
    else
        ROI_struct(idx).contour.segments.points = [];
    end
end
return;
%ROI_struct(idx_list).contour(slice_now).segments(contour_index).points
% handles.ROI_structure = DICOM_contour_reader(series_filenames{1}.description{rs_series}.filename{1}, out1.z_location, ...
%     out1.original_x_location, out1.original_y_location, fliplr(out1.original_z_location), ...
%     out1.x_location, out1.y_location, out1.z_location);








fid = fopen(filename);
tol = 1e-4;

%fid = fopen('C:\Users\USER\Desktop\ROI2_07852673.voi', 'r');
text1 = fread(fid);
text1 = char(text1');
fclose(fid);

n_slices = get_value_from_text(text1, '# number_of_slices_z', '%d ');

%%%%%
out_struct = {};
tempvar.segments = struct('points',{});

for idx = 1:n_slices
    empty_struct.contour(idx) = tempvar;
end

%%%%%


k = strfind(text1, '#NUMBER OF VOI TIME LISTS:');
n_list = sscanf(text1(k+27:end)','%d ');

list_des_begin_pos = strfind(text1,'#VOI TIME LIST NUMBER');

if length(list_des_begin_pos) ~= n_list
    error('Number of VOIs do not equal the sections describing the VOIs');
end

nx = get_value_from_text(text1, '# number_of_columns_x', '%d # number_of_columns_x');
ny = get_value_from_text(text1, '# number_of_rows_y', '%d # number_of_rows_y');
nz = get_value_from_text(text1, '# number_of_slices_z', '%d # number_of_slices_z');
spacing_x = get_value_from_text(text1, '# x_pixel_size', '%f # x_pixel_size');
spacing_y = get_value_from_text(text1, '# y_pixel_size', '%f # y_pixel_size');
spacing_z = get_value_from_text(text1, '# z_pixel_size', '%f # z_pixel_size');

origin_x = get_value_from_text(text1(strfind(text1,'#ORIGIN LOCATION IN MM:'):end), '# x_origin_location', '%f # x_origin_location');
origin_y = get_value_from_text(text1(strfind(text1,'#ORIGIN LOCATION IN MM:'):end), '# y_origin_location', '%f # y_origin_location');
origin_z = get_value_from_text(text1(strfind(text1,'#ORIGIN LOCATION IN MM:'):end), '# z_origin_location', '%f # z_origin_location');

header.xV = -origin_x : spacing_x : -origin_x+(nx)*spacing_x;
header.yV = -origin_y : spacing_y : -origin_y+(ny)*spacing_y;
header.zV = -origin_z : spacing_z : -origin_z+(nz)*spacing_z;

% %out.original_x_location = (out.x_location); % Not sure why this has to be flipped...
% 
% out.y_location = metainfo{idx,1}.ImagePositionPatient(2) : metainfo{idx,1}.PixelSpacing(2): metainfo{idx,1}.ImagePositionPatient(2)+(ny-1)*metainfo{idx,1}.PixelSpacing(2);
% out.y_location = -(out.y_location);
% out.original_y_location = (out.y_location); % Not sure why this has to be flipped...
% out.pmod_y_location = metainfo{idx,1}.ImagePositionPatient(2) : metainfo{idx,1}.PixelSpacing(2) : metainfo{idx,1}.ImagePositionPatient(2)+(ny)*metainfo{idx,1}.PixelSpacing(2);
% out.pmod_y_location = -(out.pmod_y_location);
% out.pmod_y_location_2 = out.pmod_y_location(1): (out.pmod_y_location(end)-out.pmod_y_location(1))/(ny-1): out.pmod_y_location(end);


for idx_list = 1:n_list
    
    ROI_struct(idx_list).contour = empty_struct.contour;
    if idx_list == n_list
        text_list = text1(list_des_begin_pos(idx_list):end);
    else
        text_list = text1(list_des_begin_pos(idx_list):list_des_begin_pos(idx_list+1)-1);
    end
    
    ROI_struct(idx_list).structureName = get_value_from_text(text_list, '# voi_name', '%s# voi_name');
    
    n_voi = get_value_from_text(text_list, '# number_of_vois', '%d ');
    
    if round(n_voi)~=n_voi
        error('VOI number not integer; stopped');
    end
    if n_voi > 1
        error('This function does not support multiple VOIs within a VOI');
    end
    voi_des_begin_pos = strfind(text_list, '#TIME VOI NUMBER');
    text_voi = text_list(voi_des_begin_pos:end);
    % determine number of slices within the VOI
    n_roi = get_value_from_text(text_voi, '# number_of_rois', '%d ');
    if n_roi > 0
        contour_name = {};
        roi_des_begin_pos = strfind(text_voi, '#ROI ON SLICE');
        for idx_roi = 1:n_roi
            if idx_roi == n_roi
                text_roi = text_voi(roi_des_begin_pos(idx_roi):end);
            else
                text_roi = text_voi(roi_des_begin_pos(idx_roi):roi_des_begin_pos(idx_roi+1)-1);
            end
            InputText=textscan(text_roi, '%s', 'delimiter', '\n');
            slice_info = sscanf(InputText{1}{2}, '%d %d');
            % The slice location should be matched to the images. So the
            % slice number here should not be trusted.
            %slice_now=slice_info(1)+1; % slice 0 means slice #1, etc.
            n_contour=slice_info(2);
            idx_temp = 1;
            while idx_temp<=numel(InputText{1})
                if ~isempty(strfind(InputText{1}{idx_temp}, '# number_of_vertices'));
                    double_quote_pos = find(InputText{1}{idx_temp}=='"');
                    now_contour_name = InputText{1}{idx_temp}(double_quote_pos(1)+2:double_quote_pos(2)-2);
                    if isempty(find(strcmp(InputText{1}{idx_temp}, contour_name)))
                        contour_name{end+1} =now_contour_name;
                        contour_index = length(contour_name);
                    else
                        contour_index =find(strcmp(InputText{1}{idx_temp}, contour_name));
                    end
                    n_vertices = sscanf(InputText{1}{idx_temp}, '%d '); %13 137.0 -137.0 false 0 " Contour 1 "
                    n_vertices = n_vertices(1);
                    
                    pos_vertices = [];
                    for idx_vertices = 1:n_vertices-1
                        pos_vertices(idx_vertices, :) = sscanf(InputText{1}{idx_temp + idx_vertices}, '%f %f %f');
                    end
                    if numel(pos_vertices) > 1
                        [dummy slice_now] = min(abs(zV-pos_vertices(1,3)));
                        %slice_now
                        corrected_vertices = process_pmod_vertices_new(pos_vertices, handles, header);
                        
                        ROI_struct(idx_list).contour(slice_now).segments(contour_index).points = corrected_vertices/10;
                    end
                    idx_temp = idx_temp + idx_vertices;
                    
                else
                    idx_temp = idx_temp +1;
                end
                
            end
        end
    end
    
end
% dicom_hdr = dicominfo(filename);
%
%
%
% names_field1 = fieldnames(dicom_hdr.ROIContourSequence);
% names_field2 = fieldnames(dicom_hdr.StructureSetROISequence);
%
% ROI_n = numel(names_field1);
%
% name_list = {};
% for idx = 1:ROI_n
%     current_ROI_obj = getfield(dicom_hdr.StructureSetROISequence, names_field2{idx});
%     name_list{current_ROI_obj.ROINumber} = current_ROI_obj.ROIName;
% end
%
% for idx = 1:ROI_n
%     if idx == 10
%         display('here');
%     end
%     current_ROI_obj                        = getfield(dicom_hdr.ROIContourSequence, names_field1{idx});
%     ROI_struct(idx).roiNumber        = current_ROI_obj.ReferencedROINumber;
%     ROI_struct(idx).structureName = name_list{current_ROI_obj.ReferencedROINumber};
%     if isfield(current_ROI_obj, 'ContourSequence')
%         temp1= align_contour_on_slices(current_ROI_obj.ContourSequence, zV, x1, y1, z1, x2, y2, z2);
%         ROI_struct(idx).contour = temp1.contour;
%     else
%         ROI_struct(idx).contour.segments.points = [];
%     end
% end
%
return;

function outvar = get_value_from_text(str1, str2, str3)
InputText=textscan(str1, '%s', 10, 'delimiter', '\n');

for idx = 1:numel(InputText{1})
    if ~isempty(strfind(InputText{1}{idx}, str2))
        outvar = sscanf(InputText{1}{idx}, str3);
        break;
    end
end
return;