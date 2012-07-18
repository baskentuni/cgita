function feature_output = NID_Strength(varargin)
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
                    (image_property.intensity_occurrence(idx1)+image_property.intensity_occurrence(idx2))*(idx1-idx2)^2;
            end
        end
    end
    
    feature_output = tempvar2 / sum(NGTD_global);
    
else
    error('The NGTD must be computed first');
end

return;


  