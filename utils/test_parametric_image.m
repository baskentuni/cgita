clear all; close all;

load d:\temp\datatemp.mat;

img_vol = handles.Primary_image_obj.image_volume_data;

temp1 = squeeze(max(img_vol(:, :, 1:70), [],1));

figure
imagesc(temp1);

temp2 = parametric_FC(img_vol(:, :, 1:70)); 

figure
imagesc(imrotate(squeeze(max(temp2,[],1)),-90), [0 23])
colormap hot; axis off; truesize;

load d:\temp\datatemp2.mat;

img_vol = handles.Primary_image_obj.image_volume_data;

temp1 = squeeze(max(img_vol(:, :, 1:70), [],1));

figure
imagesc(temp1);

temp2 = parametric_FC(img_vol(:, :, 1:70)); 

figure
imagesc(imrotate(squeeze(max(temp2,[],1)),-90), [0 20])
colormap hot; axis off; truesize;

write_binary('D:\temp\a1_FC.raw', 'float', temp2);