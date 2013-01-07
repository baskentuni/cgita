function feature_output = voxel_TLG(varargin)
global image_global;
global image_property;
global mask_for_TA;
%image_property.pixel_spacing = img_obj.pixel_spacing;


if exist('image_global')==1
    temp1 = image_global(:);
    nonzero_voxels = temp1(find(mask_for_TA));
    feature_output = mean(nonzero_voxels) * length(nonzero_voxels) * prod(image_property.pixel_spacing) / 1e3; % convert to mL
    
else
    error('The parent image must be computed first');
end

return;