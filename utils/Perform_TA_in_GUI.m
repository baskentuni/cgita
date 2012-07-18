function handles = Perform_TA_in_GUI(handles)

n_img_set = length(handles.image_vol_for_TA); % One with only primary; two with primary and fusion

if n_img_set > 2
    error('Currently this supports only two sets of images');
end

load user_feature_settings.mat;

n_textural_features = 0;
for idx = 1:length(feature_structure)
    n_textural_features = n_textural_features + length(feature_structure{idx});
end

n_parent = length(feature_structure);

Feature_table = {};

h = msgbox('Computing the textural features. Please wait...');

Feature_display_cell = {'Feature Parent' 'Feature Name'};

n_voi_this_set = length(handles.image_vol_for_TA{1});
for idx_voi = 1:n_voi_this_set
    Feature_display_cell{end+1} = ['Primary_' num2str(idx_voi)];
end
if n_img_set == 2
    n_voi_this_set = length(handles.image_vol_for_TA{2});
    for idx_voi = 1:n_voi_this_set
        Feature_display_cell{end+1} = ['Fusion_' num2str(idx_voi)];
    end
end

table_column_now_idx = 2;

for idx_img_set = 1:n_img_set
    % Check for the number of image sets
    n_voi_this_set = length(handles.image_vol_for_TA{idx_img_set});
    if idx_img_set == 1
        now_img_obj = handles.Primary_image_obj;
    else
        now_img_obj = handles.Fusion_image_obj;
    end
    for idx_voi = 1:n_voi_this_set
        table_column_now_idx = table_column_now_idx + 1;
        
        table_row_now_idx = 1;
        for idx_parent = 1:n_parent
            n_features_in_parent = length(feature_structure{idx_parent});
            if n_features_in_parent  < 1
                continue;
            end
            parent_function_name = feature_structure{idx_parent}{1}.parentfcn;
            parent_fcn_is_the_same = true;
            for idx_feature = 1:n_features_in_parent
                if ~strcmp(parent_function_name, feature_structure{idx_parent}{idx_feature}.parentfcn)
                    parent_fcn_is_the_same = false;
                end
            end
            if  parent_fcn_is_the_same && (exist(parent_function_name)>0)
                display(['Evaluating parent function: ' parent_function_name]);
                feval(parent_function_name, handles.image_vol_for_TA{idx_img_set}{idx_voi}, ...
                    handles.resampled_image_vol_for_TA{idx_img_set}{idx_voi}, ...
                    now_img_obj, ...
                    handles, ...
                    idx_img_set, ...
                    idx_voi, ...
                    handles.range{idx_img_set});
                
            end
            for idx_feature = 1:n_features_in_parent
                if  ~parent_fcn_is_the_same % if not all parent functions are the same, evaluate its parent function for each feature
                    display(['Evaluating parent function: ' feature_structure{idx_parent}{idx_feature}.parentfcn]);
                    feval(feature_structure{idx_parent}{idx_feature}.parentfcn, handles.image_vol_for_TA{idx_img_set}{idx_voi}, ...
                        handles.resampled_image_vol_for_TA{idx_img_set}{idx_voi}, ...
                        now_img_obj, ...
                        handles, ...
                        idx_img_set, ...
                        idx_voi, ...
                        handles.range{idx_img_set});
                end
                % 1: name, 2: value
                
                Feature_table{idx_img_set}{idx_voi}{idx_parent}{idx_feature}{1} = feature_structure{idx_parent}{idx_feature}.name;
                Feature_table{idx_img_set}{idx_voi}{idx_parent}{idx_feature}{2} = feval(feature_structure{idx_parent}{idx_feature}.matlab_fun, ...
                    handles.image_vol_for_TA{idx_img_set}{idx_voi}, ...
                    handles.resampled_image_vol_for_TA{idx_img_set}{idx_voi}, ...
                    now_img_obj, ...
                    handles, ...
                    idx_img_set, ...
                    idx_voi, ...
                    handles.range{idx_img_set});
                
                table_row_now_idx = table_row_now_idx+1;
                if table_column_now_idx == 3
                    Feature_display_cell{table_row_now_idx, 1} = feature_structure{idx_parent}{idx_feature}.parent;
                    Feature_display_cell{table_row_now_idx, 2} = feature_structure{idx_parent}{idx_feature}.name;
                end
                
                Feature_display_cell{table_row_now_idx, table_column_now_idx} = Feature_table{idx_img_set}{idx_voi}{idx_parent}{idx_feature}{2};
            end
        end
        table_row_now_idx = table_row_now_idx+1;
        if table_column_now_idx == 3
            Feature_display_cell{table_row_now_idx,     1} = 'Image header';
            Feature_display_cell{table_row_now_idx+1, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+2, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+3, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+4, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+5, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+6, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+7, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+8, 1} = 'Image header';
            Feature_display_cell{table_row_now_idx+9, 1} = 'Image header';
            
            Feature_display_cell{table_row_now_idx,     2} = 'ManufacturerModelName';
            Feature_display_cell{table_row_now_idx+1, 2} = 'Modality';
            Feature_display_cell{table_row_now_idx+2, 2} = 'Width';
            Feature_display_cell{table_row_now_idx+3, 2} = 'Height';
            Feature_display_cell{table_row_now_idx+4, 2} = 'Slices';
            Feature_display_cell{table_row_now_idx+5, 2} = 'PixelSpacing_1';
            Feature_display_cell{table_row_now_idx+6, 2} = 'PixelSpacing_2';
            Feature_display_cell{table_row_now_idx+7, 2} = 'SliceThickness';
            Feature_display_cell{table_row_now_idx+8, 2} = 'StudyDate';
            Feature_display_cell{table_row_now_idx+9, 2} = 'StudyTime';
            
        end
        Feature_display_cell{table_row_now_idx    , table_column_now_idx} = now_img_obj.metadata.ManufacturerModelName;
        Feature_display_cell{table_row_now_idx+1, table_column_now_idx} = now_img_obj.metadata.Modality;
        Feature_display_cell{table_row_now_idx+2, table_column_now_idx} = now_img_obj.metadata.Width;
        Feature_display_cell{table_row_now_idx+3, table_column_now_idx} = now_img_obj.metadata.Height;
        Feature_display_cell{table_row_now_idx+4, table_column_now_idx} = size(now_img_obj.image_volume_data,3);
        Feature_display_cell{table_row_now_idx+5, table_column_now_idx} = now_img_obj.metadata.PixelSpacing(1);
        Feature_display_cell{table_row_now_idx+6, table_column_now_idx} = now_img_obj.metadata.PixelSpacing(2);
        Feature_display_cell{table_row_now_idx+7, table_column_now_idx} = now_img_obj.metadata.SliceThickness;
        Feature_display_cell{table_row_now_idx+8, table_column_now_idx} = now_img_obj.metadata.StudyDate;
        Feature_display_cell{table_row_now_idx+9, table_column_now_idx} = now_img_obj.metadata.StudyTime;
        
    end
    
end

close(h);

handles.Feature_table = Feature_table;
handles.Feature_display_cell = Feature_display_cell;

return;