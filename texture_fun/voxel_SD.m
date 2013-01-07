function feature_output = voxel_min(varargin)
global image_global;
global image_property;
global mask_for_TA;
% global image_global_ni;
% global mask_ni;

%image_property.pixel_spacing = img_obj.pixel_spacing;


if exist('image_global')==1
     temp1 = image_global(:);
    nonzero_voxels = temp1(find(mask_for_TA));
    feature_output = std(nonzero_voxels, 1);
%        feature_output = sum(image_global_ni(find(mask_ni>0))) / sum(mask_ni(:));

else
    error('The parent image must be computed first');
end

return;