function run_length_matrix_all = compute_ISZ_matrix(varargin)
mat_in = varargin{2}; % Use the resampled image volume to compute the co-occurrence matrix

if exist('run_length_matrix_alll') == 1
    clear run_length_matrix_all;
end

global image_property;
image_property.num_voxels = length(mat_in(:));

global run_length_matrix_all;
run_length_matrix_all = zeros(max(mat_in(:)), max(size(mat_in)));

for idx_intensity = 1:max(mat_in(:))
    mat_isintensity = (mat_in==idx_intensity);
    mat_connection = bwlabeln(mat_isintensity, 26); % allow the max connectivity
    for idx_group = 1:max(mat_connection(:))
        if size(run_length_matrix_all,2)< length(find(mat_connection== idx_group))
            run_length_matrix_all(idx_intensity, length(find(mat_connection== idx_group))) = 1;
        else
            run_length_matrix_all(idx_intensity, length(find(mat_connection== idx_group))) = run_length_matrix_all(idx_intensity, length(find(mat_connection== idx_group))) +1;
        end
    end
end

%ARL = sum(sum(run_length_matrix_all.*repmat(1:max(size(mat_in)), [max(mat_in(:)) 1]))) / sum(sum(run_length_matrix_all)); % average run length
% ARL = sum(sum(run_length_matrix_all.*repmat(1:size(run_length_matrix_all, 2), [max(mat_in(:)) 1]))) / sum(sum(run_length_matrix_all)); % average run length
% run_length_matrix_normalized = run_length_matrix_all / ARL ; % To normalize the run length matrix
% 
% run_length_matrix_all = run_length_matrix_normalized;


% global RLM_global;
% 
% RLM_global = run_length_matrix_all;

return;
        
        
        
