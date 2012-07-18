function img_color = overlay_images(handles)
case_tag = handles.VOI_loaded + 10*handles.Primary_images_loaded + 100*handles.Fusion_images_loaded;
current_ijk = [handles.current_i handles.current_j handles.current_k];
list_idx = get(handles.listbox1, 'Value');
if case_tag > 1 && handles.VOI_loaded
    [handles.contour_volume handles.mask_volume] = return_volume_contour_mask(handles.VOI_obj(list_idx).contour, handles);
end

fusion_factor = get(handles.fusion_factor_slider, 'Value');

switch case_tag
    case 1  % only VOI loaded
        % Do nothing
        img_color = [];
    case 11% VOI and Primary
        img_color = deal_with_1_image_voi(handles.Primary_image_obj, handles.contour_volume, current_ijk);
    case 111 % VOI, Primay and Fusion
        img_color = deal_with_2_image_voi(handles.Primary_image_obj, handles.Fusion_image_for_display, handles.contour_volume, current_ijk, fusion_factor);
    case 10 % Primary
        img_color = deal_with_1_image(handles.Primary_image_obj, current_ijk);
    case 110 % Primary and Fusion
        img_color = deal_with_2_images(handles.Primary_image_obj, handles.Fusion_image_for_display, current_ijk, fusion_factor);
%     case 100 % Fusion
%         img_color = deal_with_1_image(handles.Fusion_image_for_display, current_ijk );
%     case 101 % Fusion and VOI
%         img_color = deal_with_1_image_voi(handles.Fusion_image_for_display, handles.contour_volume, current_ijk);
end    
return;

function img_color = deal_with_1_image(image_obj, current_ijk)
range = image_obj.range;
imgtemp = apply_range(fliplr(imrotate(squeeze(image_obj.image_volume_data(current_ijk(1), :, :)), -90)), range);
img_color{1} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), range,  'uint16'), image_obj.color_map);
imgtemp = apply_range((imrotate(squeeze(image_obj.image_volume_data(:,current_ijk(2),:)), -90)), range);
img_color{2} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), range,  'uint16'), image_obj.color_map);

img_color{3} = ind2rgb(cast_double_to_int16(cast(apply_range(image_obj.image_volume_data(:,:,current_ijk(3)), range), 'double'),range,  'uint16'), image_obj.color_map);
return;

function img_color = deal_with_1_image_voi(image_obj, contour, current_ijk)
% imgtemp = fliplr(imrotate(squeeze(image_obj.image_volume_data(current_ijk(1), :, :)), -90));
% img_color{1} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), 'uint16'), image_obj.color_map);
% imgtemp = (imrotate(squeeze(image_obj.image_volume_data(:,current_ijk(2),:)), -90));
% img_color{2} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), 'uint16'), image_obj.color_map);
range = image_obj.range;
contour_img = contour(:,:,current_ijk(3)); volume_img = apply_range(image_obj.image_volume_data(:,:,current_ijk(3)) , range);
img1 = ind2rgb(cast_double_to_int16(cast(volume_img, 'double'), range, 'uint16'), image_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(contour_img, 'double'), [0 1], 'uint16'), winter(65535)); 
img_color{3} = img1.*(1-repmat(contour_img, [1 1 3])) + img2.*(repmat(contour_img, [1 1 3]));
%img_color{3} = img_color{3}/max(max(max(img_color{3})));

contour_img = fliplr(imrotate(squeeze(contour(current_ijk(1),:,:)), -90)); volume_img = apply_range(fliplr(imrotate(squeeze(image_obj.image_volume_data(current_ijk(1),:,:)), -90)) , range);
img1 = ind2rgb(cast_double_to_int16(cast(volume_img, 'double'), range, 'uint16'), image_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(contour_img, 'double'), [0 1], 'uint16'), winter(65535)); 
img_color{1} = img1.*(1-repmat(contour_img, [1 1 3])) + img2.*(repmat(contour_img, [1 1 3]));
%img_color{1} = img_color{1}/max(max(max(img_color{1})));

contour_img = imrotate(squeeze(contour(:,current_ijk(2),:,:)), -90); volume_img = apply_range(imrotate(squeeze(image_obj.image_volume_data(:,current_ijk(2),:)), -90), range);
img1 = ind2rgb(cast_double_to_int16(cast(volume_img, 'double'), range,  'uint16'), image_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(contour_img, 'double'), [0 1],  'uint16'), winter(65535)); 
img_color{2} = img1.*(1-repmat(contour_img, [1 1 3])) + img2.*(repmat(contour_img, [1 1 3]));

%img_color{2} = img_color{2}/max(max(max(img_color{2})));
return;

function img_color = deal_with_2_image_voi(image1_obj, image2_obj, contour, current_ijk, fusion_factor)
% imgtemp = fliplr(imrotate(squeeze(image_obj.image_volume_data(current_ijk(1), :, :)), -90));
% img_color{1} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), 'uint16'), image_obj.color_map);
% imgtemp = (imrotate(squeeze(image_obj.image_volume_data(:,current_ijk(2),:)), -90));
% img_color{2} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), 'uint16'), image_obj.color_map);
range1 = image1_obj.range;
range2 = image2_obj.range;

volume1_img = apply_range(image1_obj.image_volume_data(:,:,current_ijk(3)), range1);
volume2_img = apply_range(image2_obj.image_volume_data(:,:,current_ijk(3)), range2);
contour_img = contour(:,:,current_ijk(3)); 
img1 = ind2rgb(cast_double_to_int16(cast(volume1_img, 'double'), range1, 'uint16'), image1_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(volume2_img, 'double'), range2, 'uint16'), image2_obj.color_map); 
img3 = ind2rgb(cast_double_to_int16(cast(contour_img, 'double'), [0 1], 'uint16'), winter(65535)); 
img_color{3} = (img1 * fusion_factor + img2 * (1-fusion_factor)).*(1-repmat(contour_img, [1 1 3])) + img3.*(repmat(contour_img, [1 1 3]));

contour_img = fliplr(imrotate(squeeze(contour(current_ijk(1),:,:)), -90));
volume1_img = apply_range(fliplr(imrotate(squeeze(image1_obj.image_volume_data(current_ijk(1),:,:)), -90)), range1);
volume2_img = apply_range(fliplr(imrotate(squeeze(image2_obj.image_volume_data(current_ijk(1),:,:)), -90)), range2);
img1 = ind2rgb(cast_double_to_int16(cast(volume1_img, 'double'), range1, 'uint16'), image1_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(volume2_img, 'double'), range2, 'uint16'), image2_obj.color_map); 
img3 = ind2rgb(cast_double_to_int16(cast(contour_img, 'double'), [0 1], 'uint16'), winter(65535)); 

img_color{1} = (img1 * fusion_factor + img2 * (1-fusion_factor)).*(1-repmat(contour_img, [1 1 3])) + img3.*(repmat(contour_img, [1 1 3]));

contour_img = imrotate(squeeze(contour(:,current_ijk(2),:,:)), -90);
volume1_img = apply_range(imrotate(squeeze(image1_obj.image_volume_data(:,current_ijk(2),:)), -90), range1);
volume2_img = apply_range(imrotate(squeeze(image2_obj.image_volume_data(:,current_ijk(2),:)), -90), range2);
img1 = ind2rgb(cast_double_to_int16(cast(volume1_img, 'double'), range1, 'uint16'), image1_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(volume2_img, 'double'), range2, 'uint16'), image2_obj.color_map); 
img3 = ind2rgb(cast_double_to_int16(cast(contour_img, 'double'), [0 1], 'uint16'), winter(65535)); 
img_color{2} = (img1 * fusion_factor + img2 * (1-fusion_factor)).*(1-repmat(contour_img, [1 1 3])) + img3.*(repmat(contour_img, [1 1 3]));

return;

function img_color = deal_with_2_images(image1_obj, image2_obj, current_ijk, fusion_factor)
% imgtemp = fliplr(imrotate(squeeze(image_obj.image_volume_data(current_ijk(1), :, :)), -90));
% img_color{1} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), 'uint16'), image_obj.color_map);
% imgtemp = (imrotate(squeeze(image_obj.image_volume_data(:,current_ijk(2),:)), -90));
% img_color{2} = ind2rgb(cast_double_to_int16(cast(imgtemp, 'double'), 'uint16'), image_obj.color_map);
range1 = image1_obj.range;
range2 = image2_obj.range;

volume1_img = apply_range(image1_obj.image_volume_data(:,:,current_ijk(3)), range1);
volume2_img = apply_range(image2_obj.image_volume_data(:,:,current_ijk(3)), range2);
img1 = ind2rgb(cast_double_to_int16(cast(volume1_img, 'double'), range1, 'uint16'), image1_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(volume2_img, 'double'), range2, 'uint16'), image2_obj.color_map); 
img_color{3} = img1 * fusion_factor + img2 * (1-fusion_factor);

volume1_img = apply_range(fliplr(imrotate(squeeze(image1_obj.image_volume_data(current_ijk(1),:,:)), -90)), range1);
volume2_img = apply_range(fliplr(imrotate(squeeze(image2_obj.image_volume_data(current_ijk(1),:,:)), -90)), range2);
img1 = ind2rgb(cast_double_to_int16(cast(volume1_img, 'double'), range1, 'uint16'), image1_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(volume2_img, 'double'), range2, 'uint16'), image2_obj.color_map); 
img_color{1} = img1 * fusion_factor + img2 * (1-fusion_factor);

volume1_img = apply_range(imrotate(squeeze(image1_obj.image_volume_data(:,current_ijk(2),:)), -90), range1);
volume2_img = apply_range(imrotate(squeeze(image2_obj.image_volume_data(:,current_ijk(2),:)), -90), range2);
img1 = ind2rgb(cast_double_to_int16(cast(volume1_img, 'double'), range1, 'uint16'), image1_obj.color_map);
img2 = ind2rgb(cast_double_to_int16(cast(volume2_img, 'double'), range2, 'uint16'), image2_obj.color_map); 
img_color{2} = img1 * fusion_factor + img2 * (1-fusion_factor);
return;
% 
% function img_color = overlay_img_with_contour(CT_slice, contour_slice)
% % temp130 = round(temp128(:,:,idx)/18);
% % temp130(find(temp130<64)) = 0;
% if isinteger(CT_slice)
%     I1 = ind2rgb(cast_double_to_int16(cast(CT_slice, 'double'), 'uint16'), winter(65536));
% else
%     I1 = ind2rgb(cast_double_to_int16(CT_slice, 'uint16'), winter(65536));
% end
% % temp129 = round(temp7(:,:,idx)/120);
% % temp129(find(temp129<100)) = 0;
% %temp129 = fliplr(temp129);
% I2 = ind2rgb(contour_slice*150, hot(256));
% img_color = I1;
% for idx1 = 1:size(I1,1)
%     for idx2 = 1:size(I1,2)
%         if contour_slice(idx1,idx2) == 1
%             img_color(idx1,idx2,:) = I2(idx1,idx2,:);
%             if idx1>1
%                 img_color(idx1-1,idx2,:) = I2(idx1,idx2,:);
%             end
%             if idx1<size(I1,1)
%                 img_color(idx1+1,idx2,:) = I2(idx1,idx2,:);
%             end
%             if idx2>1
%                 img_color(idx1,idx2-1,:) = I2(idx1,idx2,:);
%             end
%             if idx2<size(I1,2)
%                 img_color(idx1,idx2+1,:) = I2(idx1,idx2,:);
%             end
%         end
%     end
% end
% return;