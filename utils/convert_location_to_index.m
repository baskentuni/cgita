function [vox_ind c_img mask mask_ni] = convert_location_to_index(point_mat, xV, yV, zV, handles)

vox_ind = zeros(size(point_mat));

c_img = zeros(length(xV), length(yV));

%mask_ = c_img;

for idx1 = 1:size(point_mat, 1)
    [dummy vox_ind(idx1,1)] = min(abs(xV-point_mat(idx1,1)));
    [dummy vox_ind(idx1,2)] = min(abs(yV-point_mat(idx1,2)));
    [dummy vox_ind(idx1,3)] = min(abs(zV-point_mat(idx1,3)));    
    %c_img(vox_ind(idx1,2), vox_ind(idx1,1)) = 1;
    c_img(vox_ind(idx1,1), vox_ind(idx1,2)) = 1;
end

mask = roipoly(c_img, vox_ind(:,1), vox_ind(:,2));
mask(find(c_img==1)) = 1; % because roipoly sometimes would skip some voxels on the contour

% xV = handles.Primary_image_obj.pmod_xV_2/10;
% yV = handles.Primary_image_obj.pmod_yV_2/10;
% zV = handles.Primary_image_obj.pmod_zV_2/10;

% dx = (diff(xV(1:2)));
% dy = (diff(yV(1:2)));
% point_mat2(:,1) = (point_mat(:,1) - (xV(1)))/dx  ;
% point_mat2(:,2) = (point_mat(:,2) - (yV(1)))/dy  ;

%mask_ni = roipoly_modified(c_img, point_mat2(:,1), point_mat2(:,2));
mask_ni = mask;
%mask_ni = roipoly_modified(c_img, vox_ind(:,1), vox_ind(:,2));
% mask_ni(find(mask_ni<0.5)) = 0;
% mask_ni(find(mask_ni>0)) = 1;

% if isfield(handles, 'pmod_voi_flag')
%     if handles.pmod_voi_flag == 1
%     end
% end
%mask = imfill(mask, 'holes');
%mask = poly2mask( vox_ind(:,1), vox_ind(:,2),size(c_img,1),size(c_img,2));
return;