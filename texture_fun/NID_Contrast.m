function feature_output = NID_Contrast(varargin)
global NGTD_global;
global image_property;

Ng = image_property.Ng;
n = image_property.n;

if exist('NGTD_global')==1
    tempvar = 0;
    for idx1 = 1:length(NGTD_global)
        for idx2 = 1:length(NGTD_global)
            tempvar = tempvar + image_property.intensity_occurrence(idx1)*image_property.intensity_occurrence(idx2)*(idx1-idx2)^2;
        end
    end
    feature_output = 1/Ng/(Ng-1)*tempvar*sum(NGTD_global)/n^2;
else
    error('The NGTD must be computed first');
end

return;