function feature_output = NGLD_SRE(varargin)
global NGLD_global 

if exist('NGLD_global')==1
    feature_output = 0;
    for idx1 = 1:size(NGLD_global,1)
        for idx2 = 1:size(NGLD_global,2)
            feature_output = feature_output + NGLD_global(idx1, idx2)/idx2^2;
        end
    end
    feature_output = feature_output / sum(NGLD_global(:));
    
else
    error('The NGLD matrix must be computed first');
end

return;