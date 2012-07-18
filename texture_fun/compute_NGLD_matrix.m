function NGLD_matrix = compute_NGLD_matrix(varargin)
mat_in = varargin{2};

mat_in    = varargin{4}.resampled_image_vol_for_TA_unmasked_extended{varargin{5}}{varargin{6}};
mask_in = varargin{4}.mask_vol_for_TA_extended{varargin{5}}{varargin{6}};

%mat_in((mask_in==0)) = NaN;
%glm_3D = zeros(max(img_in(:))+1, max(img_in(:))+1); % intensity of zero is accounted as '1'

% size = 1 ==> Surrounding 18 voxels

NGLD_matrix = zeros(max(mat_in(:))+1, 19); % Both zeros (gray scale, times) are accounted for

for idx1 = 2:size(mat_in,1)-1
    for idx2 = 2:size(mat_in,2)-1
        for idx3 = 2:size(mat_in,3)-1
            if mask_in(idx1, idx2, idx3)
                surrounding_vec = [
                    mat_in(idx1-1,idx2,idx3)         mat_in(idx1+1,idx2,idx3)           mat_in(idx1,idx2-1,idx3)              mat_in(idx1,idx2+1,idx3) ...
                    mat_in(idx1-1,idx2-1,idx3)      mat_in(idx1+1,idx2+1,idx3)      mat_in(idx1-1,idx2+1,idx3)          mat_in(idx1+1,idx2-1,idx3) ...
                    mat_in(idx1,idx2,idx3-1)         mat_in(idx1-1,idx2,idx3-1)         mat_in(idx1+1,idx2,idx3-1)          mat_in(idx1,idx2-1,idx3-1)       mat_in(idx1,idx2+1,idx3-1) ...
                    mat_in(idx1,idx2,idx3+1)        mat_in(idx1-1,idx2,idx3+1)        mat_in(idx1+1,idx2,idx3+1)         mat_in(idx1,idx2-1,idx3+1)      mat_in(idx1,idx2+1,idx3+1)];
                NGLD_matrix(mat_in(idx1,idx2,idx3)+1, length(find(surrounding_vec==mat_in(idx1,idx2,idx3)))+1) = ...
                    NGLD_matrix(mat_in(idx1,idx2,idx3)+1, length(find(surrounding_vec==mat_in(idx1,idx2,idx3)))+1)+1;
            end
        end
    end
end
      
NGLD_matrix = NGLD_matrix(2:end, :);

%NGLD_matrix = NGLD_matrix/sum(NGLD_matrix(:)); % Normalize it

if exist('NGLD_global') == 1
    clear NGLD_global;
end
global NGLD_global;
NGLD_global = NGLD_matrix;

return;

