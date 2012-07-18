function feature_output = NGLD_EN(varargin)
global NGLD_global

if exist('NGLD_global')==1
    feature_output = 0;    
    for idx1 = 1:size(NGLD_global,1)
        for idx2 = 1:size(NGLD_global,2)
            if NGLD_global(idx1,idx2)>0
                feature_output = feature_output + NGLD_global(idx1,idx2)*log(NGLD_global(idx1,idx2));
            end
        end
    end
    feature_output = - feature_output / sum(NGLD_global(:));
else
    error('The NGLD matrix must be computed first');
end

return;