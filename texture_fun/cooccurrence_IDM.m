function feature_output = coocurrance_IDM(varargin)
global glcm_global

if exist('glcm_global')==1
    feature_output = 0;
    for idx1 = 1:size(glcm_global,1)
        for idx2 = 1:size(glcm_global,2)
            feature_output = feature_output + glcm_global(idx1, idx2)*(1/(1+(idx1-idx2)^2));
        end
    end
else
    error('The GLCM must be computed first');
end

return;