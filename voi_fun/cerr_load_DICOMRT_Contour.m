%rtstruct=rtstruct_filename;
% Get number of VOIs
ROIContourSequence=fieldnames(rtstruct.ROIContourSequence);

% Define cell array
VOI=cell(size(ROIContourSequence,1),2);

% Progress bar
h = waitbar(0,['Loading progress:']);
set(h,'Name','dicomrt_loadvoi: loading RTSTRUCT objects');

for i=1:size(ROIContourSequence,1) % for i=1:(number of VOIs) ...
    voilabel=getfield(rtstruct.StructureSetROISequence,char(ROIContourSequence(i)),'ROIName');
    VOI{i,1}=voilabel; % get VOI's name

    try
        ncont_temp=fieldnames(getfield(rtstruct.ROIContourSequence,char(ROIContourSequence(i)), ...
            'ContourSequence')); % get contour list per each VOI (temporary variable)
    catch
        warning(['ContourSequence not found for ROI: ', voilabel]);
        ncont_temp = [];
    end

    switch isempty(ncont_temp)
        case 0
            for j=1:size(ncont_temp,1) % for j=1:(number of contours) ...
                if j==1
                    VOI{i,2}=cell(size(ncont_temp,1),1);
                end
                try
                    NumberOfContourPoints=getfield(rtstruct.ROIContourSequence,char(ROIContourSequence(i)), ...
                        'ContourSequence', char(ncont_temp(j)),'NumberOfContourPoints');
                    ContourData=getfield(rtstruct.ROIContourSequence,char(ROIContourSequence(i)), ...
                        'ContourSequence',char(ncont_temp(j)),'ContourData');
                    x=dicomrt_mmdigit(ContourData(1:3:NumberOfContourPoints*3)*0.1,7);
                    y=dicomrt_mmdigit(ContourData(2:3:NumberOfContourPoints*3)*0.1,7);
                    z=dicomrt_mmdigit(ContourData(3:3:NumberOfContourPoints*3)*0.1,7);
                    VOI{i,2}{j,1}=cat(2,x,y,z); % this is the same as VOI{i,2}{j,1}=[x,y,z];
                end
            end
        case 1
            % set dummy values. This will be deleted later dugin the import
            NumberOfContourPoints=1;
            ContourData=[0,0,0];
            x=0;
            y=0;
            z=0;
            VOI{i,2}{1,1}=cat(2,x,y,z);
    end
    waitbar(i/size(ROIContourSequence,1),h);
    ncont_temp=[];
end