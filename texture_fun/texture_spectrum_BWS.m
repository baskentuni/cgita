function feature_output = texture_spectrum_BWS(varargin)
global texture_spectrum_global;
global texture_spectrum_Si_global;

if exist('texture_spectrum_global')==1    
    
    tempvar = 0;
    for idx = 1:364
        tempvar = tempvar + abs(texture_spectrum_Si_global(idx)-texture_spectrum_Si_global(idx+365));
    end
    tempvar = (1-tempvar/sum(texture_spectrum_Si_global(:)))*100;    
    
    feature_output = tempvar;
else
    error('The texture spectrum must be computed first');
end

return;