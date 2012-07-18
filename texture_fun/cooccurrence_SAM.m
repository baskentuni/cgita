function feature_output = coocurrance_SAM(varargin)
global glcm_global

if exist('glcm_global')==1
    feature_output = sum(sum(glcm_global.^2)); % The Second angular moment is a summation of squared co-occurrence matrix
else
    error('The GLCM must be computed first');
end

return;