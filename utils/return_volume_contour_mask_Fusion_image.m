function [contour_volume mask_volume first_slice last_slice] = return_volume_contour_mask_Fusion_image(contour, handles)
%NEEDS CLARIFICATION!!!!!!

contour_volume = zeros(length(handles.Fusion_image_obj.yV), length(handles.Fusion_image_obj.xV), length(handles.Fusion_image_obj.zV));
mask_volume = contour_volume;
first_slice = Inf; last_slice = 1;
for idx = 1:length(contour)
    if ~isempty(contour(idx).segments)
        n_segments = numel(contour(idx).segments);
        for idx2 = 1:n_segments
            point_mat = contour(idx).segments(idx2).points;
            if size(point_mat,1)>0
                [vox_ind contour_img mask] = convert_location_to_index(point_mat, handles.Fusion_image_obj.xV, handles.Fusion_image_obj.yV, handles.Fusion_image_obj.zV);
                %contour_img = edge(mask);
                contour_volume(:,:,idx) = contour_volume(:,:,idx) + contour_img;
                mask_volume(:,:,idx) = mask_volume(:,:,idx) +mask;
                if first_slice>idx
                    first_slice = idx;
                end
                if last_slice<idx
                    last_slice = idx;
                end
            end
        end
    end
end
%[first_slice last_slice]
return;