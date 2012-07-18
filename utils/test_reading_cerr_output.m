clear all; close all;

load('D:\Work\Texture analysis\test1_0306.mat');


[xV, yV, zV] = getScanXYZVals(planC{3}(1));

temp1 = planC{1,4}(39);

contour_all_slices = temp1.contour;
 
for idx1 = 1:length(contour_all_slices)
    if ~isempty(contour_all_slices(idx1).segments)
        stop;
    end
end

%%
point_mat = contour_all_slices(idx1).segments.points;

[vox_ind contour_img mask] = convert_location_to_index(point_mat, xV, yV, zV);

CT_img = planC{1,3}.scanArray;

