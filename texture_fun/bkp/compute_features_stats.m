  function [SUVstats SUVvec SUV_name_val] = compute_features_stats(segmented_image_small, voxel_spacing)

num_voxels = length(find(segmented_image_small>0));

SUVstats.tumor_vol = num_voxels * prod(voxel_spacing) /1000; % in mL

SUVstats.SUVmean = sum(segmented_image_small(:)) / num_voxels;

SUVstats.SUVmax = max(max(max(segmented_image_small)));

tempimg = segmented_image_small;
tempimg = cast(tempimg/max(tempimg(:))*256, 'uint8');

glm_3d = glcm_Dean_3d(tempimg);

stats = graycoprops_Dean(glm_3d);

SUVstats.contrast = stats.Contrast;
SUVstats.correlation = stats.Correlation;
SUVstats.energy = stats.Energy;
SUVstats.homogeneity = stats.Homogeneity;
SUVstats.entropy = stats.Entropy;

cell_name = fieldnames(stats);
for idx = 1:numel(fieldnames(stats))
    SUV_name_val{idx, 1} = cell_name{idx}; 
    SUV_name_val{idx, 2} = getfield(stats, cell_name{idx}); 
    
end
SUVvec = [SUVstats.tumor_vol SUVstats.SUVmean SUVstats.SUVmax SUVstats.contrast  SUVstats.correlation SUVstats.energy SUVstats.homogeneity SUVstats.entropy];

return;
    
    
    %     display('');
%     display('');
%     display('with the 3d volume:');
%     display(['contrast: ' num2str(stats.contrast)]);
%     display(['correlation: ' num2str()]);
%     display(['energy:  ' num2str()]);
%     display(['homogeneity: '  num2str(stats.homogeneity)]);
%     display(['entropy: '  num2str(stats.entropy)]);
