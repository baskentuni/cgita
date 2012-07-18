function feature_output = NGLD_NNU(varargin)
global NGLD_global 

if exist('NGLD_global')==1
    feature_output = 0;
    for idx2 = 1:size(NGLD_global,2)        
        feature_output = feature_output + sum(NGLD_global(:, idx2))^2;
    end
    feature_output = feature_output / sum(NGLD_global(:));
    
else
    error('The NGLD matrix must be computed first');
end

return;