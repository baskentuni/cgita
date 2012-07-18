function Image_obj = make_image_obj_DICOM(out1)

% Import images and record necessary information
out1.x_location = out1.x_location/10;
out1.y_location = out1.y_location/10;
out1.z_location = out1.z_location/10;
out1.original_x_location = out1.original_x_location/10;
out1.original_y_location = out1.original_y_location/10;
out1.original_z_location = out1.original_z_location/10;

Image_obj.image_volume_data = out1.pixelData;

Image_obj.xV = out1.x_location;
Image_obj.yV = out1.y_location;
Image_obj.zV = out1.z_location;
Image_obj.xV_original = out1.original_x_location; % tempoary variables
Image_obj.yV_original = out1.original_y_location;
Image_obj.zV_original = out1.original_z_location;
 
Image_obj.xV = out1.x_location;
Image_obj.yV = out1.y_location;
Image_obj.zV = out1.z_location;

Image_obj.pmod_xV = out1.pmod_x_location;
Image_obj.pmod_yV = out1.pmod_y_location;
Image_obj.pmod_zV = out1.pmod_z_location;

Image_obj.pmod_xV_2 = out1.pmod_x_location_2;
Image_obj.pmod_yV_2 = out1.pmod_y_location_2;
Image_obj.pmod_zV_2 = out1.pmod_z_location_2;


Image_obj.pixel_spacing = abs(out1.pixelSpacing);
Image_obj.modality = out1.modality;

return;