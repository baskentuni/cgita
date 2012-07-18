function feature_output = TFC_Coarseness(varargin)
global FC3D_global
%global texture_spectrum_Si_global;

if exist('FC3D_global')==1    
        
    feature_output = length(find(FC3D_global==20))/ length(find(FC3D_global>0)) ;
    
else
    error('The texture coding must be computed first');
end

return;