function now_struct =  align_contour_on_slices(contour_obj, zV, x1, y1, z1, x2, y2, z2);

tol = 1e-4;

out_struct = {};

n_slices = length(zV);

names_field = fieldnames(contour_obj);

contour_cell = cell(length(names_field), 1);

tempvar.segments = struct('points',{});

for idx = 1:n_slices
    now_struct.contour(idx) = tempvar;
end

tempmat = [];
for idx = 1:length(names_field) % loop through all segments
    current_item = getfield(contour_obj, names_field{idx});
    clear tempmat;
    for idx2 = 1:round(length(current_item.ContourData)/current_item.NumberOfContourPoints)
        tempmat(:,idx2) = current_item.ContourData(idx2:round(length(current_item.ContourData)/current_item.NumberOfContourPoints):end);
    end
    %tempmat2 = -tempmat;
    
    tempmat(:,3) = -tempmat(:,3);
    tempmat(:,2) = -tempmat(:,2);
    
    if ~isempty(tempmat)
        tempmat = tempmat/10; % convert to cm
        
        tempmat = deal_with_xyz(tempmat, x1, y1, z1, x2, y2, z2);
        % determine slice_n
        slice_n = find(abs(zV-tempmat(1,3))<tol);
        slice_n_all(idx) = slice_n;
        if length(slice_n) > 1
            error('More than one slice mapped to this segment');
        end
        if length(slice_n) == 1
            
            % determine segment_n
            if length(now_struct.contour(slice_n).segments) == 1
                if isempty(now_struct.contour(slice_n).segments(1).points)
                    segment_n = 1;
                else
                    segment_n = 2;
                end
            else
                segment_n = length(now_struct.contour(slice_n).segments)+1;
            end
            now_struct.contour(slice_n).segments(segment_n).points = tempmat;
        else
            display('Found an unmatch slice.');
            %stop;
            %isempty(now_struct(slice_n).segment(1).points)
        end
    end
end

%             %Reshape Contour Data
%             data    = reshape(data, [3 nPoints])';
% 
%             data(:,3) = -data(:,3); %Z is always negative to match RTOG spec
% 
%             if isstr(pPos)
%                 switch upper(pPos)
%                     case 'HFS' %+x,-y,-z
%                         data(:,2) = -data(:,2);
%                         %data(:,2) = 2*yOffset*10 - data(:,2);
%                     case 'HFP' %-x,+y,-z
%                         data(:,1) = -data(:,1);
%                         data(:,1) = 2*xOffset*10 - data(:,1);
%                     case 'FFS' %+x,-y,-z
%                         data(:,2) = -data(:,2);
%                         %data(:,2) = 2*yOffset*10 - data(:,2);
%                     case 'FFP' %-x,+y,-z
%                         data(:,1) = -data(:,1);
%                         data(:,1) = 2*xOffset*10 - data(:,1);
%                 end
%             else
%                 data(:,2) = -data(:,2); %Default it to HFS
%             end
% 
%             %Convert from DICOM mm to CERR cm.
%             data    = data / 10;
% 
%             %Replicate the last data point: CERR needs first/last identical
%             if ~isempty(data)
%                 data(end+1,:) = data(1,:);
% 
%                 if length(unique(data(:,3))) > 1;
% 
%                     a = abs(diff(unique(data(:,3))));
% 
%                     if (max(a)>5e-3)
%                         %ROI Name
%                         name = dcm2ml_Element(ssObj.get(hex2dec('30060026')));
% 
%                         warning(['CERR does not support out-of-plane contours. Skipping contour ' num2str(i) ' in structure ' name '.']);
%                         continue;
%                     end
%                 end
% 
%             end
% 
%             dataS(i).segments = data;

return;