function feature_output = cooccurrence_Correlation(varargin)
global glcm_global

if glcm_global == 1
    feature_output = 0;
    return;
end
if exist('glcm_global')==1
    tempvar = graycoprops(glcm_global);
    feature_output = tempvar.Correlation;
else
    error('The GLCM must be computed first');
end

return;