function varargout = prepare_SUV_parent(varargin)
% This function computes the 3D Gray Level Co-occurance matrix. The output
% is a 2D matrix. Input img_in has to be in integers, but it does not
% necessary have to 3D
% This is a 'symmetric' GLCM. ie (0,1) and (1,0) is regarded to be the same
% ie it is non-directional!
% This function is the parent function for co-occurrence matrices
img_in = varargin{1}; % Use the original masked image volume to compute the co-occurrence matrix
img_obj = varargin{3};
mask = varargin{4}.mask_vol_for_TA{varargin{5}}{varargin{6}};

if exist('image_global') == 1
    clear image_global;
end
global image_global;
image_global = img_in; % Should be in double already
% global image_global_ni;
% image_global_ni = img_in2;
global mask_for_TA;
mask_for_TA = mask;

if exist('image_property') == 1
    clear image_property;
end
global image_property;
image_property.pixel_spacing = img_obj.pixel_spacing;


return;