function ROI_struct = make_VOI_obj_from_mask(handles, mask_vol, voi_name);%, zV, x1, y1, z1, x2, y2, z2)

n_slices = size(handles.Primary_image_obj.image_volume_data,3);

idx_list = 1;
out_struct = {};
tempvar.segments = struct('points',{});

for idx = 1:n_slices
    empty_struct.contour(idx) = tempvar;
end

ROI_struct(idx_list).contour = empty_struct.contour;

ROI_struct(idx_list).structureName = voi_name;

xV2 = (handles.xV);
yV2 = (handles.yV);

for slice_now = 1:n_slices
    if sum(sum(mask_vol(:,:,slice_now))) >1  
        if max(max(bwlabel(mask_vol(:,:,slice_now)))) == 1
            contour_index = 1;
            %[r c] = mask2poly(mask_vol(:,:,slice_now));
            [r c] = mask2poly(mask_vol(:,:,slice_now));
            pos_vertices = zeros(length(r), 3);
            for idx = 1:length(r)
                %pos_vertices(idx, :) = [handles.xV(c(idx))  handles.yV(r(idx)) handles.zV(slice_now)];
                %pos_vertices(idx, :) = [handles.xV(r(idx))  handles.yV(c(idx)) handles.zV(slice_now)];
                pos_vertices(idx, :) = [xV2(r(idx)) yV2(c(idx))        handles.zV(slice_now)];
            end
            ROI_struct(idx_list).contour(slice_now).segments(contour_index).points = pos_vertices;
        else
            label_img = bwlabel(mask_vol(:,:,slice_now));
            for contour_index = 1:max(label_img(:))
                [r c] = mask2poly(label_img == contour_index);
                pos_vertices = zeros(length(r), 3);
                for idx = 1:length(r)
                    %pos_vertices(idx, :) = [handles.xV(c(idx))  handles.yV(r(idx)) handles.zV(slice_now)];
                    %pos_vertices(idx, :) = [handles.xV(r(idx))  handles.yV(c(idx)) handles.zV(slice_now)];
                    pos_vertices(idx, :) = [xV2(r(idx)) yV2(c(idx))          handles.zV(slice_now)];
                end
                ROI_struct(idx_list).contour(slice_now).segments(contour_index).points = pos_vertices;
            end
        end
    end
end



return;


%     n_voi = get_value_from_text(text_list, '# number_of_vois', '%d ');
%     
%     if round(n_voi)~=n_voi
%         error('VOI number not integer; stopped');
%     end
%     if n_voi > 1
%         error('This function does not support multiple VOIs within a VOI');
%     end
%     voi_des_begin_pos = strfind(text_list, '#TIME VOI NUMBER');
%     text_voi = text_list(voi_des_begin_pos:end);
%     % determine number of slices within the VOI
%     n_roi = get_value_from_text(text_voi, '# number_of_rois', '%d ');
%     if n_roi > 0
%         contour_name = {};
%         roi_des_begin_pos = strfind(text_voi, '#ROI ON SLICE');
%         for idx_roi = 1:n_roi
%             if idx_roi == n_roi
%                 text_roi = text_voi(roi_des_begin_pos(idx_roi):end);
%             else
%                 text_roi = text_voi(roi_des_begin_pos(idx_roi):roi_des_begin_pos(idx_roi+1)-1);
%             end
%             InputText=textscan(text_roi, '%s', 'delimiter', '\n');
%             slice_info = sscanf(InputText{1}{2}, '%d %d');
%             % The slice location should be matched to the images. So the
%             % slice number here should not be trusted.
%             %slice_now=slice_info(1)+1; % slice 0 means slice #1, etc.
%             n_contour=slice_info(2);
%             idx_temp = 1;
%             while idx_temp<=numel(InputText{1})
%                 if ~isempty(strfind(InputText{1}{idx_temp}, '# number_of_vertices'));
%                     double_quote_pos = find(InputText{1}{idx_temp}=='"');
%                     now_contour_name = InputText{1}{idx_temp}(double_quote_pos(1)+2:double_quote_pos(2)-2);
%                     if isempty(find(strcmp(InputText{1}{idx_temp}, contour_name)))
%                         contour_name{end+1} =now_contour_name;
%                         contour_index = length(contour_name);
%                     else
%                         contour_index =find(strcmp(InputText{1}{idx_temp}, contour_name));
%                     end
%                     n_vertices = sscanf(InputText{1}{idx_temp}, '%d '); %13 137.0 -137.0 false 0 " Contour 1 " 
%                     n_vertices = n_vertices(1);
%                     pos_vertices = [];
%                     for idx_vertices = 1:n_vertices-1
%                         pos_vertices(idx_vertices, :) = sscanf(InputText{1}{idx_temp + idx_vertices}, '%f %f %f');
%                     end
%                     [dummy slice_now] = min(abs(zV-pos_vertices(1,3)));
%                     %slice_now
%                     ROI_struct(idx_list).contour(slice_now).segments(contour_index).points = pos_vertices / 10;
%                     idx_temp = idx_temp + idx_vertices;                    
%                 else
%                     idx_temp = idx_temp +1;
%                 end
%                 
%             end
%         end
%     end
% 
% end
%     if idx_list == n_list
%         text_list = text1(list_des_begin_pos(idx_list):end);
%     else
%         text_list = text1(list_des_begin_pos(idx_list):list_des_begin_pos(idx_list+1)-1);
%     end
% 
% 
% % dicom_hdr = dicominfo(filename);
% % 
% % 
% % 
% % names_field1 = fieldnames(dicom_hdr.ROIContourSequence);
% % names_field2 = fieldnames(dicom_hdr.StructureSetROISequence);
% % 
% % ROI_n = numel(names_field1);
% % 
% % name_list = {};
% % for idx = 1:ROI_n 
% %     current_ROI_obj = getfield(dicom_hdr.StructureSetROISequence, names_field2{idx});
% %     name_list{current_ROI_obj.ROINumber} = current_ROI_obj.ROIName;
% % end
% % 
% % for idx = 1:ROI_n 
% %     if idx == 10
% %         display('here');
% %     end
% %     current_ROI_obj                        = getfield(dicom_hdr.ROIContourSequence, names_field1{idx});
% %     ROI_struct(idx).roiNumber        = current_ROI_obj.ReferencedROINumber;
% %     ROI_struct(idx).structureName = name_list{current_ROI_obj.ReferencedROINumber};
% %     if isfield(current_ROI_obj, 'ContourSequence')
% %         temp1= align_contour_on_slices(current_ROI_obj.ContourSequence, zV, x1, y1, z1, x2, y2, z2);
% %         ROI_struct(idx).contour = temp1.contour;
% %     else
% %         ROI_struct(idx).contour.segments.points = [];
% %     end
% % end
% % 
% % only support PMOD VOI on static images
% % only support ROI drawn on axial slices
% % does support multiple contours on the same slice
% % zV = -fliplr(handles.zV_original)*10;
% % 
% % fid = fopen(filename);
% % tol = 1e-4;
% % 
% % %fid = fopen('C:\Users\USER\Desktop\ROI2_07852673.voi', 'r');
% % text1 = fread(fid);
% % text1 = char(text1');
% % fclose(fid);
% % 
% % n_slices = get_value_from_text(text1, '# number_of_slices_z', '%d ');
% % 
% % %%%%%
% % out_struct = {};
% % tempvar.segments = struct('points',{});
% % 
% % for idx = 1:n_slices
% %     empty_struct.contour(idx) = tempvar;
% % end
% % 
% % %%%%%
% % 
% % 
% % k = strfind(text1, '#NUMBER OF VOI TIME LISTS:');
% % n_list = sscanf(text1(k+27:end)','%d ');
% % 
% % list_des_begin_pos = strfind(text1,'#VOI TIME LIST NUMBER');
% % 
% % if length(list_des_begin_pos) ~= n_list
% %     error('Number of VOIs do not equal the sections describing the VOIs');
% % end
% % % 
% % % function outvar = get_value_from_text(str1, str2, str3)
% % % InputText=textscan(str1, '%s', 10, 'delimiter', '\n');
% % % 
% % % for idx = 1:numel(InputText{1})
% % %     if ~isempty(strfind(InputText{1}{idx}, str2))
% % %         outvar = sscanf(InputText{1}{idx}, str3);
% % %         break;
% % %     end
% % % end
% % % return;