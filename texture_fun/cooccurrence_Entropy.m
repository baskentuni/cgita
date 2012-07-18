function feature_output = cooccurrence_Entropy(varargin)
global glcm_global

if exist('glcm_global')==1
    feature_output = 0;
    for idx1 = 1:size(glcm_global,1)
        for idx2 = 1:size(glcm_global,2)
            if glcm_global(idx1,idx2) > 0
                feature_output = feature_output + (-glcm_global(idx1,idx2)*log(glcm_global(idx1,idx2)));
            end
        end
    end
    
else
    error('The GLCM must be computed first');
end

return;