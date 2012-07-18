function feature_output = texture_spectrum_Max(varargin)
global texture_spectrum_global;
global texture_spectrum_Si_global;

if exist('texture_spectrum_global')==1    
    feature_output = max(texture_spectrum_Si_global(:))/sum(texture_spectrum_Si_global(:));
else
    error('The texture spectrum must be computed first');
end

return;