function handles = refresh_display(handles)
% Determine if the handles includes image and voi objects
Primary_exist_tag = handles.Primary_images_loaded;
Fusion_exist_tag = handles.Fusion_images_loaded;
if Primary_exist_tag+Fusion_exist_tag < 1
    return; % No images loaded. Does not refresh the display.
end
VOI_exist_tag = handles.VOI_loaded;

% Initialize (i,j,k) if necessary
if isempty(handles.current_k)
    if VOI_exist_tag % Initialize slice location by VOI 
        %[handles.current_i handles.current_j handles.current_k] = determine_ijk_from_VOI(handles.VOI_obj);
    else % Initialize slice location by images
        if Primary_exist_tag 
            handles.current_i = round(size(handles.Primary_image_obj.image_volume_data,1)/2);
            handles.current_j = round(size(handles.Primary_image_obj.image_volume_data,2)/2);
            handles.current_k = round(size(handles.Primary_image_obj.image_volume_data,3)/2);
        else
            handles.current_i = round(size(handles.Fusion_image_obj.image_volume_data,1)/2);
            handles.current_j = round(size(handles.Fusion_image_obj.image_volume_data,2)/2);
            handles.current_k = round(size(handles.Fusion_image_obj.image_volume_data,3)/2);
        end
    end
end

if handles.Let_VOI_decide_slice ==1 % Determine the slice location
    list_idx = get(handles.listbox1, 'Value');
    %if case_tag > 1 && handles.VOI_loaded
        [handles.contour_volume handles.mask_volume first_slice last_slice] = return_volume_contour_mask(handles.VOI_obj(list_idx).contour, handles);
        if round((first_slice+last_slice)/2) == Inf
            warndlg('Empty VOI');
        else
        handles.current_k = round((first_slice+last_slice)/2);
        
        while(1)
            temp_img = handles.contour_volume(:,:,handles.current_k);
            if isempty(find(abs(diff(sum(temp_img,1)>0))==1))
                handles.current_k = handles.current_k-1;
            else
                break;
            end
            
        end
        % handles.current_slice = round(mean(first_slice,last_slice));
        temp_img = handles.contour_volume(:,:,handles.current_k);
        temp_vec = find(abs(diff(sum(temp_img,1)>0))==1);
        handles.current_j = round(mean([temp_vec(1) temp_vec(end)]));
        temp_vec = find(abs(diff(sum(temp_img,2)>0))==1);
        handles.current_i = round(mean([temp_vec(1) temp_vec(end)]));
        end
   % end
end
% Get the images displayed
axes_images = overlay_images(handles);

% axes(handles.axes1);
% temp1 = get(handles.I1, 'ButtonDownFcn');
% handles.I1 = imagesc( imrotate(squeeze(handles.smoothed_pixel_data(:,handles.current_I,:)),0), [handles.display_min handles.display_max]); axis off; colormap hot;
% set(handles.I1,'ButtonDownFcn',temp1);

% handles.axial_btndwn_fcn      = get(handles.axial_axes,'ButtonDownFcn');
% handles.coronal_btndwn_fcn = get(handles.coronal_axes,'ButtonDownFcn');
% handles.sagittal_btndwn_fcn = get(handles.sagittal_axes,'ButtonDownFcn');
% 
%waitfor(handles.axial_axes, 'Children');
pixel_spacing = handles.Primary_image_obj.pixel_spacing;
volume_size = size(handles.Primary_image_obj.image_volume_data);
axes(handles.axial_axes); temp1 = get(handles.axial_axes, 'ButtonDownFcn');
handles.Img_axial = imagesc(axes_images{3}); axis off;  
% if get(handles.axes_aspect_ratio_checkbox, 'Value')
%     pbaspect([1  pixel_spacing(2)*volume_size(2)/(volume_size(1)*pixel_spacing(1)) 1]); %/pixel_spacing(2)
% else
%     pbaspect([1  volume_size(2)/(volume_size(1)) 1]); %/pixel_spacing(2)
% end
set(handles.Img_axial, 'ButtonDownFcn', handles.axial_btndwn_fcn );

axes(handles.coronal_axes); temp1 = get(handles.coronal_axes, 'ButtonDownFcn');
handles.Img_coronal =imagesc(axes_images{1}); axis off; 
% if get(handles.axes_aspect_ratio_checkbox, 'Value')
%     pbaspect([1 pixel_spacing(3)*volume_size(3)/(volume_size(1)*pixel_spacing(1)) 1]); %*
% else
%     pbaspect([1  volume_size(3)/(volume_size(1)) 1]); %/pixel_spacing(2)
% end
set(handles.Img_coronal, 'ButtonDownFcn', handles.coronal_btndwn_fcn);
axes(handles.sagittal_axes); temp1 = get(handles.sagittal_axes, 'ButtonDownFcn');
handles.Img_sagittal =imagesc(axes_images{2}); axis off; 
% if get(handles.axes_aspect_ratio_checkbox, 'Value')
%     pbaspect([1  pixel_spacing(3)*volume_size(3)/(volume_size(2)*pixel_spacing(2)) 1]);
% else
%     pbaspect([1  volume_size(3)/(volume_size(2)) 1]); %/pixel_spacing(2)
% end
set(handles.Img_sagittal, 'ButtonDownFcn', handles.sagittal_btndwn_fcn);
return;
