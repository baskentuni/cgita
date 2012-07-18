function feature_output = voxel_corrected_Skewness(varargin)
global image_global;
global image_property;
%image_property.pixel_spacing = img_obj.pixel_spacing;



if exist('image_global')==1
   % vox_vec = image_global(:);
   temp1 = image_global(:);
    vox_vec = temp1(find(temp1~=0));
    n = length(vox_vec);
    feature_output = mean((vox_vec-mean(vox_vec)).^3)/(var(vox_vec,1))^1.5;
    feature_output = feature_output / (n-2) * sqrt(n*(n-1));
    
else
    error('The parent image must be computed first');
end

return;