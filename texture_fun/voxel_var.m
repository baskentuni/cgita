function feature_output = voxel_min(varargin)
global image_global;
global image_property;
global mask_for_TA;
%image_property.pixel_spacing = img_obj.pixel_spacing;


if exist('image_global')==1
    temp1 = image_global(:);
    nonzero_voxels = temp1(find(mask_for_TA));
    
    feature_output = var(nonzero_voxels);
    
else
    error('The parent image must be computed first');
end

return;