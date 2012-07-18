function [vox_ind c_img mask] = convert_location_to_index(point_mat, xV, yV, zV, handles)

vox_ind = zeros(size(point_mat));

c_img = zeros(length(xV), length(yV));

mask_ = c_img;

for idx1 = 1:size(point_mat, 1)
    [dummy vox_ind(idx1,1)] = min(abs(xV-point_mat(idx1,1)));
    [dummy vox_ind(idx1,2)] = min(abs(yV-point_mat(idx1,2)));
    [dummy vox_ind(idx1,3)] = min(abs(zV-point_mat(idx1,3)));    
    c_img(vox_ind(idx1,2), vox_ind(idx1,1)) = 1;
end

mask = roipoly(c_img, vox_ind(:,1), vox_ind(:,2));
% if isfield(handles, 'pmod_voi_flag')
%     if handles.pmod_voi_flag == 1
        mask(find(c_img==1)) = 1; % because roipoly sometimes would skip some voxels on the contour
%     end
% end
mask = imfill(mask, 'holes');
%mask = poly2mask( vox_ind(:,1), vox_ind(:,2),size(c_img,1),size(c_img,2));
return;