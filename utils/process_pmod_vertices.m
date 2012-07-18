function corrected_vertices = process_pmod_vertices(point_mat, handles, header);%, pmod_info);
                        
vox_ind = zeros(size(point_mat));

xV = handles.Primary_image_obj.pmod_xV;
yV = handles.Primary_image_obj.pmod_yV;
zV = handles.Primary_image_obj.pmod_zV;
xV_2 = handles.Primary_image_obj.pmod_xV_2;
yV_2 = handles.Primary_image_obj.pmod_yV_2;
zV_2 = handles.Primary_image_obj.pmod_zV_2;
xV_3 = handles.Primary_image_obj.xV * 10;
yV_3 = handles.Primary_image_obj.yV * 10;
zV_3 = handles.Primary_image_obj.zV * 10;
xV_4 = header.xV;
yV_4 = fliplr(header.yV);
zV_4 = header.zV;

% pmod_xV = pmod_info.xV;
% pmod_yV = pmod_info.yV;
% pmod_zV = pmod_info.zV;


c_img = zeros(length(xV_2), length(yV_2));

%vox_ind2 = [];
for idx1 = 1:size(point_mat, 1)
     %[dummy vox_ind(idx1,1)] = min(abs(xV-point_mat(idx1,1)));
     %[dummy vox_ind(idx1,2)] = min(abs(yV-point_mat(idx1,2)));
    [dummy vox_ind(idx1,1)] = min(abs(xV-point_mat(idx1,1)));
    [dummy vox_ind(idx1,2)] = min(abs(yV-point_mat(idx1,2)));    
end

mask = poly2mask(vox_ind(:,1)-1, vox_ind(:,2)-1, length(xV)-1, length(yV)-1);
for idx1 = 1:size(vox_ind,1)
    mask(vox_ind(idx1,2), vox_ind(idx1,1))=1;
end
%mask = poly2mask(vox_ind(:,1), vox_ind(:,2), length(xV_2), length(yV_2));

%mask = roipoly(c_img, vox_ind(:,1), vox_ind(:,2));

se = strel('disk',1);
mask2 = imerode(mask, se);
mask3 = mask2 - imerode(mask2, se);
%mask3 = mask-mask2;
% for idx1 = 1:size(vox_ind,1)
%     mask3(vox_ind(idx1,2), vox_ind(idx1,1))=1;
% end
B=bwboundaries(mask3);

if length(B) <1
    corrected_vertices = [];
else
    B = B{1};
    
    corrected_vertices = zeros(size(B,1),2);
    
    for i = 1:size(B,1)
        %corrected_vertices(i, :) = [xV_3(B(i,2)) yV_3(B(i,1))];
        corrected_vertices(i, :) = [xV_2(B(i,2)) yV_2(B(i,1))];
    end
    corrected_vertices(:,3) = point_mat(1,3);
    %[dummy z_ind] = min(abs(zV - point_mat(1,3)));
    %corrected_vertices(:,3) = zV_3(z_ind);
end
return;

% 
% for idx1 = 1:size(point_mat, 1)
%      %[dummy vox_ind(idx1,1)] = min(abs(xV-point_mat(idx1,1)));
%      %[dummy vox_ind(idx1,2)] = min(abs(yV-point_mat(idx1,2)));
%     [dummy vox_ind(idx1,1)] = min(abs(xV-point_mat(idx1,1)));
%     [dummy vox_ind(idx1,2)] = min(abs(yV-point_mat(idx1,2)));
% end
% 
% %mask = poly2mask(vox_ind(:,1)-1, vox_ind(:,2)-1, length(xV)-1, length(yV)-1);
% mask = poly2mask(vox_ind(:,1), vox_ind(:,2), length(xV_2), length(yV_2));
% 
% se = strel('disk',1);
% mask2 = imerode(mask, se);
% B=bwboundaries(mask-mask2);
% 
% if length(B) <1
%     corrected_vertices = [];
% else
%     B = B{1};
%     
%     corrected_vertices = zeros(size(B,1),2);
%     
%     for i = 1:size(B,1)
%         %corrected_vertices(i, :) = [xV_3(B(i,2)) yV_3(B(i,1))];
%         corrected_vertices(i, :) = [xV_3(B(i,2)) yV_3(B(i,1))];
%     end
%     corrected_vertices(:,3) = point_mat(1,3);
%     %[dummy z_ind] = min(abs(zV - point_mat(1,3)));
%     %corrected_vertices(:,3) = zV_3(z_ind-1);
% end
% mask = roipoly(c_img, vox_ind(:,1), vox_ind(:,2));
% mask(find(c_img==1)) = 1; % because roipoly sometimes would skip some voxels on the contour
% mask = imfill(mask, 'holes');
