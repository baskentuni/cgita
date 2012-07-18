function varargout = compute_voxel_alignment_matrix(varargin)
% This function computes the 3D Gray Level Co-occurance matrix. The output
% is a 2D matrix. Input img_in has to be in integers, but it does not
% necessary have to 3D
% This is a 'symmetric' GLCM. ie (0,1) and (1,0) is regarded to be the same
% ie it is non-directional!
% This function is the parent function for co-occurrence matrices

img_in = varargin{2}; % Use the resampled image volume to compute the co-occurrence matrix

run_length_matrix = zeros(max(img_in(:))+1, max(size(img_in)));

img_as_vec = img_in(:);

index_mapping_mat = make_index_matrix(size(img_in));

for idx_intensity = 1:max(img_in(:))+1
    now_intensity = idx_intensity-1; % zero is also accounted for
    voxel_index_with_now_intensity = find(img_as_vec == now_intensity);
    
    num_of_voxel_with_now_intensity = length(voxel_index_with_now_intensity);
    if num_of_voxel_with_now_intensity > 0
        for idx_voxel = 1:num_of_voxel_with_now_intensity
            now_rcz = index_mapping_mat(voxel_index_with_now_intensity(idx_voxel), :);
            % Search on the six directions
            
        end
    end
end



for idx1 = 1:size(img_in, 1)
    for idx2 = 1:size(img_in, 2)
        for idx3 = 1:size(img_in, 3)
            if idx2<size(img_in, 2)
                a = sort([img_in(idx1, idx2, idx3) img_in(idx1, idx2+1, idx3)]); a = a+1;
                glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
            end
            if idx1<size(img_in, 1)
                a = sort([img_in(idx1, idx2, idx3) img_in(idx1+1, idx2, idx3)]); a = a+1;
                glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
            end
            if idx3<size(img_in, 3)
                a = sort([img_in(idx1, idx2, idx3) img_in(idx1, idx2, idx3+1)]); a = a+1;
                glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
            end
        end
    end
end



% glm_3D = zeros(max(img_in(:))+1, max(img_in(:))+1); % intensity of zero is accounted as '1'
% 
% for idx1 = 1:size(img_in, 1)
%     for idx2 = 1:size(img_in, 2)
%         for idx3 = 1:size(img_in, 3)
%             if idx2<size(img_in, 2)
%                 a = sort([img_in(idx1, idx2, idx3) img_in(idx1, idx2+1, idx3)]); a = a+1;
%                 glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
%             end
%             if idx1<size(img_in, 1)
%                 a = sort([img_in(idx1, idx2, idx3) img_in(idx1+1, idx2, idx3)]); a = a+1;
%                 glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
%             end
%             if idx3<size(img_in, 3)
%                 a = sort([img_in(idx1, idx2, idx3) img_in(idx1, idx2, idx3+1)]); a = a+1;
%                 glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
%             end
%         end
%     end
% end
% 
% for idx1 = 1:size(glm_3D,1)
%     for idx2 = 1:size(glm_3D,2)
%         if glm_3D(idx1, idx2) > 0
%             glm_3D(idx2, idx1) = glm_3D(idx1, idx2);
%         end
%     end
% end
% 
% % Create external global 'glcm_global' for other functions to access
% if exist('glcm_global') == 1
%     clear glcm_global;
% end
% global glcm_global;
% glcm_global = glm_3D;
% 
% if nargout > 0
%     varargout{1} = glm_3D;
% end

return;