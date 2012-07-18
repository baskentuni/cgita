function NGTD_matrix = compute_NGTD_matrix(varargin)
%mat_in = varargin{2};
%mask_in = varargin{4}.mask_vol_for_TA{varargin{5}}{varargin{6}};
mat_in    = varargin{4}.resampled_image_vol_for_TA_unmasked_extended{varargin{5}}{varargin{6}};
mask_in = varargin{4}.mask_vol_for_TA_extended{varargin{5}}{varargin{6}};

mat_in_double = cast(mat_in, 'double');
mat_in_double(mask_in==0) = NaN;
mat_in = mat_in_double;
% size = 1 ==> Surrounding 18 voxels
surrounding_mean_mat = zeros(size(mat_in)-[2 2 2]);

for idx1 = 2:size(mat_in,1)-1
    for idx2 = 2:size(mat_in,2)-1
        for idx3 = 2:size(mat_in,3)-1
            if ~isnan(mat_in(idx1,idx2,idx3))
                surrounding_mean_mat(idx1-1, idx2-1, idx3-1) =  (nansum(nansum(nansum(mat_in(idx1-1:idx1+1, idx2-1:idx2+1, idx3-1:idx3+1)))) ...
                    - nansum([mat_in(idx1,idx2,idx3) ...
                    mat_in(idx1-1,idx2-1,idx3-1) ...
                    mat_in(idx1+1,idx2-1,idx3-1) ...
                    mat_in(idx1-1,idx2+1,idx3-1) ...
                    mat_in(idx1+1,idx2+1,idx3-1) ...
                    mat_in(idx1-1,idx2-1,idx3+1) ...
                    mat_in(idx1+1,idx2-1,idx3+1) ...
                    mat_in(idx1-1,idx2+1,idx3+1) ...
                    mat_in(idx1+1,idx2+1,idx3+1)]));
                sur_26_not_nan = length(find(~isnan(mat_in(idx1-1:idx1+1, idx2-1:idx2+1, idx3-1:idx3+1)))) - length(find(~isnan([mat_in(idx1,idx2,idx3) ...
                    mat_in(idx1-1,idx2-1,idx3-1) ...
                    mat_in(idx1+1,idx2-1,idx3-1) ...
                    mat_in(idx1-1,idx2+1,idx3-1) ...
                    mat_in(idx1+1,idx2+1,idx3-1) ...
                    mat_in(idx1-1,idx2-1,idx3+1) ...
                    mat_in(idx1+1,idx2-1,idx3+1) ...
                    mat_in(idx1-1,idx2+1,idx3+1) ...
                    mat_in(idx1+1,idx2+1,idx3+1)])));
                surrounding_mean_mat(idx1-1, idx2-1, idx3-1) = surrounding_mean_mat(idx1-1, idx2-1, idx3-1) / sur_26_not_nan;
                if isnan(surrounding_mean_mat(idx1-1, idx2-1, idx3-1))
                    surrounding_mean_mat(idx1-1, idx2-1, idx3-1) = 0;
                end
            end
        end
    end
end

mat_in_cut = mat_in(2:size(mat_in,1)-1, 2:size(mat_in,2)-1, 2:size(mat_in,3)-1);

surrounding_mean_mat = surrounding_mean_mat(:);
mat_in_cut = mat_in_cut(:);

NGTD_matrix = zeros(1, max(mat_in_cut));

pi = zeros(1, max(mat_in_cut));

for idx_intensity = 1:double(max(mat_in_cut))
    NGTD_matrix(idx_intensity) = sum(abs(idx_intensity-surrounding_mean_mat(mat_in_cut == idx_intensity)));
    pi(idx_intensity) = length(find(mat_in_cut(:)==idx_intensity));
    %NGTD_matrix(idx_intensity) = NGTD_matrix(idx_intensity) / pi(idx_intensity); % Normalize it by the number of occurance
end

global image_property;
image_property.intensity_occurrence = pi / length(find(~isnan(mat_in_cut(:))));
image_property.n =  length(find(~isnan(mat_in_cut(:))));

Ng = 0;
for idx1 = 1:max(mat_in_cut)
    if length(find(mat_in_cut == idx1))>0
        Ng = Ng+1;
    end
end

image_property.Ng = Ng;

if exist('NGTD_global') == 1
    clear NGTD_global;
end

global NGTD_global;
NGTD_global = NGTD_matrix;

return;

%
%
%
% for idx_direction = 1:size(direction_mat,1)
%     max_lines = direction_mat(idx_direction, 2);
%     max_num_mat = direction_mat(idx_direction, 3);
%     run_length_matrix = zeros(max(mat_in(:)), max(size(mat_in)));%, 9);
%     for idx_slice = 1:max_num_mat
%         I = mat_in(:, :, idx_slice);
%         for idx_intensity = 1:max(mat_in(:))
%             mat_isintensity = (I==idx_intensity);
%             for idx_line = 1:max_lines
%                 vec_line = extract_vec(mat_isintensity, direction_mat(idx_direction, 1), idx_line);
%                 now_pos = find_first_in_vec(vec_line);
%                 if now_pos>0
%                     while (now_pos<=length(vec_line))
%                         cut_vec = vec_line(now_pos:end);
%                         run_length_now = determine_run_length(cut_vec);
%                         run_length_matrix(idx_intensity, run_length_now) = run_length_matrix(idx_intensity, run_length_now)+1;
%                         cut_vec = vec_line(now_pos+run_length_now:end);
%                         first_idx = find_first_in_vec(cut_vec);
%                         if first_idx > 0
%                             now_pos = now_pos +run_length_now+first_idx-1
%                         else
%                             break;
%                         end
%                     end
%                 end
%             end
%
%         end
%         %stop
%     end
%     run_length_matrix_all(:,:,idx_direction) = run_length_matrix;
%     if idx_direction == 4
%         mat_in = permute(mat_in, [3 2 1]);
%     end
%     if idx_direction == 7
%         mat_in = permute(mat_in, [3 2 1]);
%         mat_in = permute(mat_in, [1 3 2]);
%     end
% end
%
% run_length_matrix_all = sum(run_length_matrix_all, 3);
%
% return;
% %
% % run_length_matrix = zeros(max(mat_in(:)), max(size(mat_in)));%, 9);
% %
% % % same slice, 90 degrees == towards the top
% % for idx_intensity = 1:max(mat_in(:))
% %     mat_isintensity = (I==idx_intensity);
% %     for idx2 = 1:size(mat_in,2)
% %         now_row = find_first_in_vec(mat_isintensity(:,idx2));
% %         if now_row>0
% %             while (now_row<=size(mat_in,1))
% %                 cut_vec = mat_isintensity(now_row:end, idx2);
% %                 run_length_now = determine_run_length(cut_vec);
% %                 run_length_matrix(idx_intensity, run_length_now) = run_length_matrix(idx_intensity, run_length_now)+1;
% %                 cut_vec = mat_isintensity(now_row+run_length_now:end, idx2);
% %                 first_idx = find_first_in_vec(cut_vec);
% %                 if first_idx > 0
% %                     now_row = now_row+run_length_now+first_idx-1;
% %                 else
% %                     break;
% %                 end
% %             end
% %         end
% %     end
% % end




% img_as_vec = img_in(:);
%
% index_mapping_mat = make_index_matrix(size(img_in));
