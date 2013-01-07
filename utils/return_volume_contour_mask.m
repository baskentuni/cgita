function [contour_volume mask_volume first_slice last_slice] = return_volume_contour_mask(contour, handles)
%NEEDS CLARIFICATION!!!!!!

%contour_volume = zeros(length(handles.yV), length(handles.xV), length(handles.zV));
contour_volume = zeros(length(handles.xV), length(handles.yV), length(handles.zV));
mask_volume = contour_volume;
first_slice = Inf; last_slice = 1;
for idx = 1:length(contour)
    if ~isempty(contour(idx).segments)
        n_segments = numel(contour(idx).segments);
        for idx2 = 1:n_segments
            point_mat = contour(idx).segments(idx2).points;
            if size(point_mat,1)>0
                [vox_ind contour_img mask mask_ni] = convert_location_to_index(point_mat, handles.xV, handles.yV, handles.zV, handles);
                %[vox_ind contour_img mask mask_ni] = convert_location_to_index(point_mat, handles.yV, handles.xV, handles.zV, handles);
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
contour_volume(find(contour_volume>1)) = 1;
mask_volume(find(mask_volume>1)) = 1;
%[first_slice last_slice]
return;