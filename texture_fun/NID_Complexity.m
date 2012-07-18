function feature_output = NID_Complexity(varargin)
global NGTD_global;
global image_property;

Ng = image_property.Ng;
n = image_property.n;

if exist('NGTD_global')==1

    tempvar2 = 0;
    for idx1 = 1:length(NGTD_global)
        for idx2 = 1:length(NGTD_global)
            if (image_property.intensity_occurrence(idx1) * image_property.intensity_occurrence(idx2)) > 0
                tempvar2 = tempvar2 + ...
                    abs(idx1-idx2) / (n^2*(image_property.intensity_occurrence(idx1) + image_property.intensity_occurrence(idx2))) * ...
                    (image_property.intensity_occurrence(idx1) * NGTD_global(idx1) + image_property.intensity_occurrence(idx2) * NGTD_global(idx2));
            end
        end
    end
    
    feature_output = tempvar2;
    
else
    error('The NGTD must be computed first');
end

return;