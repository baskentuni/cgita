function run_length_matrix_all = compute_voxel_alignment_matrix_parametric_img(varargin)
% row: gray level. Zero is not accounted for
% col: # of runs
mat_in = varargin{2};

if exist('run_length_matrix_all')==1
    clear run_length_matrix_all;
end

global run_length_matrix_all;
global image_property;

image_property.num_voxels = length(mat_in(:));

direction_mat = [
    1    size(mat_in,1)                                  size(mat_in, 3)
    2    size(mat_in,2)                                  size(mat_in, 3)
    3    size(mat_in,1)+size(mat_in,2)-1     size(mat_in, 3)
    4    size(mat_in,1)+size(mat_in,2)-1     size(mat_in, 3)
    5    size(mat_in,3)                                  size(mat_in, 1)
    6    size(mat_in,3)+size(mat_in,2)-1     size(mat_in, 1)
    7    size(mat_in,3)+size(mat_in,2)-1     size(mat_in, 1)
    8    size(mat_in,3)+size(mat_in,1)-1     size(mat_in, 2)  
    9    size(mat_in,3)+size(mat_in,1)-1     size(mat_in, 2)
    ]; % number, max of lines, max of loops

run_length_matrix_all = zeros(max(mat_in(:)), max(size(mat_in)), 9);

for idx_direction = 1:size(direction_mat,1)
    max_lines = direction_mat(idx_direction, 2);
    max_num_mat = direction_mat(idx_direction, 3);
    run_length_matrix = zeros(max(mat_in(:)), max(size(mat_in)));%, 9);
    for idx_slice = 1:max_num_mat
        I = mat_in(:, :, idx_slice);
        for idx_intensity = 1:max(mat_in(:))
            mat_isintensity = (I==idx_intensity);
            for idx_line = 1:max_lines
                vec_line = extract_vec(mat_isintensity, direction_mat(idx_direction, 1), idx_line);                
                now_pos = find_first_in_vec(vec_line);
                if now_pos>0
                    while (now_pos<=length(vec_line))
                        cut_vec = vec_line(now_pos:end);
                        run_length_now = determine_run_length(cut_vec);
                        run_length_matrix(idx_intensity, run_length_now) = run_length_matrix(idx_intensity, run_length_now)+1;
                        cut_vec = vec_line(now_pos+run_length_now:end);
                        first_idx = find_first_in_vec(cut_vec);
                        if first_idx > 0
                            now_pos = now_pos +run_length_now+first_idx-1;
                        else
                            break;
                        end
                    end
                end
            end
            
        end
        %stop
    end
    run_length_matrix_all(:,:,idx_direction) = run_length_matrix;
    if idx_direction == 4
        mat_in = permute(mat_in, [3 2 1]);
    end
    if idx_direction == 7
        mat_in = permute(mat_in, [3 2 1]);
        mat_in = permute(mat_in, [1 3 2]);        
    end
end

run_length_matrix_all = sum(run_length_matrix_all, 3);

% ARL = sum(sum(run_length_matrix_all.*repmat(1:max(size(mat_in)), [max(mat_in(:)) 1]))) / sum(sum(run_length_matrix_all)); % average run length
% run_length_matrix_normalized = run_length_matrix_all / ARL ; % To normalize the run length matrix
% 
% run_length_matrix_all = run_length_matrix_normalized;
% 
return;
%
% run_length_matrix = zeros(max(mat_in(:)), max(size(mat_in)));%, 9);
%
% % same slice, 90 degrees == towards the top
% for idx_intensity = 1:max(mat_in(:))
%     mat_isintensity = (I==idx_intensity);
%     for idx2 = 1:size(mat_in,2)
%         now_row = find_first_in_vec(mat_isintensity(:,idx2));
%         if now_row>0
%             while (now_row<=size(mat_in,1))
%                 cut_vec = mat_isintensity(now_row:end, idx2);
%                 run_length_now = determine_run_length(cut_vec);
%                 run_length_matrix(idx_intensity, run_length_now) = run_length_matrix(idx_intensity, run_length_now)+1;
%                 cut_vec = mat_isintensity(now_row+run_length_now:end, idx2);
%                 first_idx = find_first_in_vec(cut_vec);
%                 if first_idx > 0
%                     now_row = now_row+run_length_now+first_idx-1;
%                 else
%                     break;
%                 end
%             end
%         end
%     end
% end

%return;


% img_as_vec = img_in(:);
%
% index_mapping_mat = make_index_matrix(size(img_in));
