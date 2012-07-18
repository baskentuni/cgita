function feature_output = NID_Coarseness(varargin)
global NGTD_global;
global image_property;

epsilon= 1e-10;

if exist('NGTD_global')==1
    tempvar = 0;
    for idx = 1:length(NGTD_global)
         tempvar = tempvar + NGTD_global(idx)*image_property.intensity_occurrence(idx);
    end
    
    feature_output = 1/(epsilon + tempvar);
    
else
    error('The NGTD must be computed first');
end

return;