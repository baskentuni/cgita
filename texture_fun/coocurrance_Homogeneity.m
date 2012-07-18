function feature_output = coocurrance_Homogeneity(varargin);
global glcm_global

if exist('glcm_global')==1
    feature_output = 0;
    if length(find(isnan(glcm_global))) < 1
        
        for idx1 = 1:size(glcm_global,1)
            for idx2 = 1:size(glcm_global,2)
                feature_output = feature_output + glcm_global(idx1, idx2)*(1/(1+abs(idx1-idx2)));
            end
        end
    end
%     tempvar = graycoprops(glcm_global);
%     matlab_homogeneity = tempvar.Homogeneity;
%     if abs(matlab_homogeneity*sum(glcm_global(:)) - feature_output) > abs(feature_output*10-5)
%         %matlab_homogeneity ~= feature_output
%         warning('Matlab has a different value.');
%     end
    
else
    error('The GLCM must be computed first');
end

return;