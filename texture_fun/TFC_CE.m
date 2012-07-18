function feature_output = TFC_CE(varargin)
global FC3D_global
global glcm_global 
%global texture_spectrum_Si_global;

vec = FC3D_global(:);
vec = vec(find(vec>0));

mean1 = mean(vec);
sd1 = std(vec);

if exist('FC3D_global')==1    
    tempvar = 0;
    for idx1 = 1:max(FC3D_global(:))
        for idx2 = 1:max(FC3D_global(:))
            if glcm_global(idx1,idx2)>0
                tempvar = tempvar  - glcm_global(idx1,idx2)*log(glcm_global(idx1,idx2))  ;
            end
        end
    end
    feature_output = tempvar;
    
else
    error('The texture feature coding must be computed first');
end

return;