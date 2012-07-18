function feature_output = coocurrance_Contrast(varargin)
global glcm_global

if exist('glcm_global')==1
    if length(find(isnan(glcm_global))) > 1
        feature_output = 0;
    else
        feature_output = 0;
        for idx1 = 1:size(glcm_global,1)
            for idx2 = 1:size(glcm_global,2)
                feature_output = feature_output + glcm_global(idx1, idx2)*(idx1-idx2)^2;
            end
        end
    end
    
%     tempvar = graycoprops(glcm_global);
%     matlab_contrast = tempvar.Contrast;
%     if abs(matlab_contrast*sum(glcm_global(:)) - feature_output) > abs(feature_output*10-5)
%         warning('Matlab has a different value.');
%     end
    
else
    error('The GLCM must be computed first');
end

return;