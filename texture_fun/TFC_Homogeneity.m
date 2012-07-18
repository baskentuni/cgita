function feature_output = TFC_Homogeneity(varargin)
global FC3D_global
%global texture_spectrum_Si_global;

if exist('FC3D_global')==1    
        
    feature_output = length(find(FC3D_global==1))/ length(find(FC3D_global>0)) ;
    
else
    error('The texture feature coding must be computed first');
end

return;