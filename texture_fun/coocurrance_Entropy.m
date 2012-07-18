function feature_output = coocurrance_Entropy(varargin)
global glcm_global

if exist('glcm_global')==1
    feature_output = -sum(sum(glcm_global.*log(glcm_global))); 
else
    error('The GLCM must be computed first');
end

return;