function feature_output = voxel_Volume(varargin)
global image_global;
global image_property;
global mask_for_TA;
% global image_global_ni;
% global mask_ni;

%image_property.pixel_spacing = img_obj.pixel_spacing;


if exist('image_global')==1
    temp1 = image_global(:);
    nonzero_voxels = length(temp1(find(mask_for_TA)));
    %nonzero_voxels = sum(mask_ni(:));
    feature_output = nonzero_voxels  * prod(image_property.pixel_spacing) / 1e3; % convert to mL
    
else
    error('The parent image must be computed first');
end

return;