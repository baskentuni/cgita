function feature_output = NGLD_SM(varargin)
global NGLD_global 

if exist('NGLD_global')==1
    feature_output = sum(sum(NGLD_global.^2));    
    feature_output = feature_output / sum(NGLD_global(:));
    
else
    error('The NGLD matrix must be computed first');
end

return;