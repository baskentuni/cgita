function feature_output = TFC_Variance(varargin)
global FC3D_global
%global texture_spectrum_Si_global;

vec = FC3D_global(:);
vec = vec(find(vec>0));

mean1 = mean(vec);
sd1 = std(vec);

if exist('FC3D_global')==1    
    tempvar = 0;
    for idx1 = 1:max(FC3D_global(:))
        tempvar = tempvar + (idx1-mean1)^2*length(find(FC3D_global == idx1))/numel(vec);
    end
    feature_output = tempvar;
    
else
    error('The texture feature coding must be computed first');
end

return;