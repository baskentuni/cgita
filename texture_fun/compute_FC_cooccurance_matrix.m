function out_mat = compute_FC_cooccurance_matrix(varargin)
handles = varargin{4};

idx_img_set = varargin{5};
idx_voi = varargin{6};

% mat_in = handles.resampled_image_vol_for_TA_unmasked{idx_img_set}{idx_voi};
% 
% mask= handles.mask_vol_for_TA{idx_img_set}{idx_voi};

mat_in    = varargin{4}.resampled_image_vol_for_TA_unmasked_extended{varargin{5}}{varargin{6}};
mask_in = varargin{4}.mask_vol_for_TA_extended{varargin{5}}{varargin{6}};
mask = mask_in;

mask2 = mask(2:end-1, 2:end-1, 2:end-1);

out_mat = zeros(size(mat_in)-[2 2 2]);

squeezed_matrix = zeros(3, 3, numel(out_mat));

counter = 0;
for idx1 = 2:size(mat_in,1)-1
    for idx2 = 2:size(mat_in,2)-1
        for idx3 = 2:size(mat_in,3)-1
            counter = counter+1;            
            squeezed_matrix(:,:,counter) = [
                mat_in(idx1-1,idx2,idx3) mat_in(idx1,idx2,idx3) mat_in(idx1+1,idx2,idx3); ...
                mat_in(idx1,idx2-1,idx3) mat_in(idx1,idx2,idx3) mat_in(idx1,idx2+1,idx3); ...
                mat_in(idx1,idx2,idx3-1) mat_in(idx1,idx2,idx3) mat_in(idx1,idx2,idx3+1)];
        end
    end
end

code_in_vec = compute_texture_coding(squeezed_matrix);

counter = 0;
for idx1 = 1:size(out_mat,1)
    for idx2 = 1:size(out_mat,2)
        for idx3 = 1:size(out_mat,3)
            counter = counter+1;            
            out_mat(idx1, idx2, idx3) = code_in_vec(counter);            
        end
    end
end

out_mat = out_mat .* mask2;

if exist('FC3D_global')
    clear FC3D_global;
end
global FC3D_global;
FC3D_global = out_mat;


%% co-occurrence matrix
img_in = out_mat; % Use the resampled image volume to compute the co-occurrence matrix
mask_in = mask2;

glm_3D = zeros(max(img_in(:))+1, max(img_in(:))+1); % intensity of zero is accounted as '1'

for idx1 = 1:size(img_in, 1)
    for idx2 = 1:size(img_in, 2)
        for idx3 = 1:size(img_in, 3)
            if mask_in(idx1, idx2, idx3)
                if idx2<size(img_in, 2) && mask_in(idx1, idx2+1, idx3)
                    a = sort([img_in(idx1, idx2, idx3) img_in(idx1, idx2+1, idx3)]); a = a+1;
                    glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
                end
                if idx1<size(img_in, 1) && mask_in(idx1+1, idx2, idx3)
                    a = sort([img_in(idx1, idx2, idx3) img_in(idx1+1, idx2, idx3)]); a = a+1;
                    glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
                end
                if idx3<size(img_in, 3) && mask_in(idx1, idx2, idx3+1)
                    a = sort([img_in(idx1, idx2, idx3) img_in(idx1, idx2, idx3+1)]); a = a+1;
                    glm_3D(a(1), a(2)) = glm_3D(a(1), a(2))+1;
                end
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

% Create external global 'glcm_global' for other functions to access
if exist('glcm_global') == 1
    clear glcm_global;
end
global glcm_global;

glm_3D = glm_3D(2:end, 2:end);
glcm_global = glm_3D / sum(sum(glm_3D));

if nargout > 0
    varargout{1} = glm_3D;
end

return;
%out_mat = reshape(code_in_vec, size(out_mat));
