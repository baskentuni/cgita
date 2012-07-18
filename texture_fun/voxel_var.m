function feature_output = voxel_min(varargin)
global image_global;
global image_property;
%image_property.pixel_spacing = img_obj.pixel_spacing;


if exist('image_global')==1
    temp1 = image_global(:);
    nonzero_voxels = temp1(find(temp1~=0));
    
    feature_output = var(nonzero_voxels);
    
else
    error('The parent image must be computed first');
end

return;