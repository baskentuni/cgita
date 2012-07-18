function ROI_struct = DICOM_contour_reader(filename, zV, x1, y1, z1, x2, y2, z2)

dicom_hdr = dicominfo(filename);



names_field1 = fieldnames(dicom_hdr.ROIContourSequence);
names_field2 = fieldnames(dicom_hdr.StructureSetROISequence);

ROI_n = numel(names_field1);

name_list = {};
for idx = 1:ROI_n 
    current_ROI_obj = getfield(dicom_hdr.StructureSetROISequence, names_field2{idx});
    name_list{current_ROI_obj.ROINumber} = current_ROI_obj.ROIName;
end

for idx = 1:ROI_n 
    if idx == 10
        display('here');
    end
    current_ROI_obj                        = getfield(dicom_hdr.ROIContourSequence, names_field1{idx});
    ROI_struct(idx).roiNumber        = current_ROI_obj.ReferencedROINumber;
    ROI_struct(idx).structureName = name_list{current_ROI_obj.ReferencedROINumber};
    if isfield(current_ROI_obj, 'ContourSequence')
        temp1= align_contour_on_slices(current_ROI_obj.ContourSequence, zV, x1, y1, z1, x2, y2, z2);
        ROI_struct(idx).contour = temp1.contour;
    else
        ROI_struct(idx).contour.segments.points = [];
    end
end

return;

