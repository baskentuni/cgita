function feature_output = coocurrance_Correlation(varargin)
global glcm_global

if exist('glcm_global')==1
    tempvar = graycoprops(glcm_global);
    feature_output = tempvar.Correlation;
else
    error('The GLCM must be computed first');
end

return;