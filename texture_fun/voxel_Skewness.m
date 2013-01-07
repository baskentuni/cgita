function feature_output = voxel_Skewness(varargin)
global image_global;
global image_property;
global mask_for_TA;
%image_property.pixel_spacing = img_obj.pixel_spacing;



if exist('image_global')==1
     temp1 = image_global(:);
    vox_vec = temp1(find(mask_for_TA));
    %vox_vec = image_global(:);
    feature_output = mean((vox_vec-mean(vox_vec)).^3)/(var(vox_vec,1))^1.5;
    
else
    error('The parent image must be computed first');
end

return;