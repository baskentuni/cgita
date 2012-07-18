function [out]=DICOM_reader_CGITA(filename_list)
% currently only supporting static image volumes

header1 = dicominfo(filename_list{1});
% if isfield(header1, 'NumberOfTimeSlices')
%     if header1.NumberOfTimeSlices > 1
%         warndlg('This program only support static images currently. Contact CGITA developers for further info. ');
%         return;
%     end
% end
ref_pos = [header1.ImagePositionPatient];

n_file = length(filename_list);

for file_idx = 1:n_file
    if exist('dcmreadfile','file'),
        info = dcmreadfile(filename_list{file_idx});
    else
        info = dicominfo(filename_list{file_idx});
    end
    
    if isfield(info, 'RescaleSlope')
        scaleFactor(file_idx) = info.RescaleSlope;
    else
        scaleFactor(file_idx) = 1;
    end
    if isfield(info, 'RescaleIntercept')
        rescaleIntercept(file_idx) = info.RescaleIntercept;
    else
        rescaleIntercept(file_idx) = 0;
    end
    z_location(file_idx) = info.ImagePositionPatient(3);
    
    if strcmp(info.Modality,'PT')
        distance(file_idx) = info.ImageIndex;
    else
        pos = info.ImagePositionPatient;
        distance(file_idx) =  dot([pos - ref_pos]', ...
            [norm(ref_pos(1)) norm(ref_pos(2)) norm(ref_pos(3))]);
    end
end

[dummy, sorted_index] = sort(distance, 2);

filename_list = filename_list(sorted_index);
scaleFactor = scaleFactor(sorted_index);
rescaleIntercept = rescaleIntercept(sorted_index);

info = dicominfo(filename_list{end});

for file_idx = 1:n_file
    if exist('dcmreadfile','file'),
        temp_header = dcmreadfile(filename_list{file_idx});
        temp_img = temp_header.PixelData;
    else
        temp_img = dicomread(filename_list{file_idx});
    end
    final_data_output(:,:,file_idx) = cast((double(temp_img) * scaleFactor(file_idx)+rescaleIntercept(file_idx)), 'double');
end
final_data_output= flipdim(final_data_output,3);


nx = size(final_data_output,1);
ny = size(final_data_output,2);
nz = size(final_data_output,3);

if isfield(info, 'SpacingBetweenSlices'),
    out.pixelSpacing = [info.PixelSpacing' info.SpacingBetweenSlices];
else
    out.pixelSpacing = [info.PixelSpacing' info.SliceThickness];
end

out.scaleFactor = ones(1, n_file);
out.rescaleIntercept = zeros(1, n_file);
out.pixelData = final_data_output;
out.z_location = z_location(sorted_index);
%%%%%% This part deals with orientation. It needs special care!!!!!!!!!
out.original_z_location = (-out.z_location); % Not sure why this has to be flipped...
% out.z_location = -fliplr(out.z_location); % Because the it's flipped along the 3rd dimension!
% out.pmod_z_location = out.z_location;
%out.z_location = -fliplr(out.z_location); % Because the it's flipped along the 3rd dimension!
out.pmod_z_location = -fliplr(out.z_location);
out.pmod_z_location = out.z_location(1):info.SliceThickness:nz*info.SliceThickness+out.z_location;
out.pmod_z_location_2 = out.pmod_z_location(1): (out.pmod_z_location(end)-out.pmod_z_location(1))/(nz-1): out.pmod_z_location(end);

% xVals =scanInfo.xOffset - (sizeDim2*scanInfo.grid2Units)/2 : scanInfo.grid2Units : scanInfo.xOffset + (sizeDim2*scanInfo.grid2Units)/2;
% yVals = fliplr(scanInfo.yOffset - (sizeDim1*scanInfo.grid1Units)/2 : scanInfo.grid1Units : scanInfo.yOffset + (sizeDim1*scanInfo.grid1Units)/2);
out.x_location = info.ImagePositionPatient(1) : info.PixelSpacing(1): info.ImagePositionPatient(1)+(nx-1)*info.PixelSpacing(1);
out.original_x_location = (out.x_location); % Not sure why this has to be flipped...
out.pmod_x_location = info.ImagePositionPatient(1) : info.PixelSpacing(1): info.ImagePositionPatient(1)+(nx)*info.PixelSpacing(1);
out.pmod_x_location_2 = out.pmod_x_location(1): (out.pmod_x_location(end)-out.pmod_x_location(1))/(nx-1): out.pmod_x_location(end);

%out.original_x_location = (out.x_location); % Not sure why this has to be flipped...

out.y_location = info.ImagePositionPatient(2) : info.PixelSpacing(2): info.ImagePositionPatient(2)+(ny-1)*info.PixelSpacing(2);
out.y_location = -(out.y_location);
out.original_y_location = (out.y_location); % Not sure why this has to be flipped...
out.pmod_y_location = info.ImagePositionPatient(2) : info.PixelSpacing(2) : info.ImagePositionPatient(2)+(ny)*info.PixelSpacing(2);
out.pmod_y_location = -(out.pmod_y_location);
out.pmod_y_location_2 = out.pmod_y_location(1): (out.pmod_y_location(end)-out.pmod_y_location(1))/(ny-1): out.pmod_y_location(end);

if isfield(info, 'RadiopharmaceuticalInformationSequence')
    
    out.metadata = info;
    
    pixel_vol_in_mL = prod(info.PixelSpacing)* info.SliceThickness * 1e-3;
    
    patient_weight_in_kg =  info.PatientWeight;
    
    if ~isfield(info.RadiopharmaceuticalInformationSequence.Item_1, 'RadionuclideTotalDose')
        prompt = {'Enter RadionuclideTotalDose (in mCi):'};
        dlg_title = 'Input for dose info';
        num_lines = 1;
        def = {'10'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        info.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose = str2num(answer{1}) * 37000000; % convert to Bq
    end
    
    if ~isfield(info.RadiopharmaceuticalInformationSequence.Item_1, 'RadiopharmaceuticalStartTime')
        prompt = {'Enter Radionuclide Time (for example, 15:11:06, enter 151106:'};
        dlg_title = 'Input for dose info';
        num_lines = 1;
        def = {'120000'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        info.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime = answer{1}; % convert to Bq
    end
    
    dose_in_Bq =  info.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose;
    
    sec1 = (str2num(info.SeriesTime(5:6))-str2num(info.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime(5:6)));
    min1 = (str2num(info.SeriesTime(3:4))-str2num(info.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime(3:4)));
    hour1 = (str2num(info.SeriesTime(1:2))-str2num(info.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime(1:2)));
    
    time_diff = hour1*60*60+min1*60+sec1;
    
    decay_corr_factor = 2^(time_diff/(info.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife));
    
    temptemp1 = out.pixelData  / (dose_in_Bq/patient_weight_in_kg/1000)*decay_corr_factor ;
    
    out.pixelData = temptemp1;
    
end

out.file_order = filename_list;
out.imagesource='DICOM';
out.modality=info.Modality;
return;

