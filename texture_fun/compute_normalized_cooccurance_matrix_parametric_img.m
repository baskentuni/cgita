function varargout = compute_normalized_cooccurance_matrix_parametric_img(varargin)
% This function computes the 3D Gray Level Co-occurance matrix. The output
% is a 2D matrix. Input img_in has to be in integers, but it does not
% necessary have to 3D
% This is a 'symmetric' GLCM. ie (0,1) and (1,0) is regarded to be the same
% ie it is non-directional!
% This function is the parent function for co-occurrence matrices

img_in = varargin{2}; % Use the resampled image volume to compute the co-occurrence matrix

glm_3D = zeros(max(img_in(:))+1, max(img_in(:))+1); % intensity of zero is accounted as '1'

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

for idx1 = 1:size(glm_3D,1)
    for idx2 = 1:size(glm_3D,2)
        if glm_3D(idx1, idx2) > 0
            glm_3D(idx2, idx1) = glm_3D(idx1, idx2);
        end
    end
end

glm_3D = glm_3D(2:end, 2:end); % remove the intensity zero
glm_3D = glm_3D / sum(glm_3D(:)); % Normalize it so it becomes probability

% Create external global 'glcm_global' for other functions to access
global glcm_global;
glcm_global = glm_3D;

if nargout > 0
    varargout{1} = glm_3D;
end

return;