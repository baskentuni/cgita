function out_img = cast_double_to_int16(in_img, range, varargin)

if nargin == 2
    type = 'uint16';
else
    type = varargin{1};
end

% img_min = min(in_img(:));
% img_max = max(in_img(:));
img_min = range(1);
img_max = range(2);

type_min = double(intmin(type));
type_max = double(intmax(type));

out_img = cast(type_min + (in_img-img_min)/(img_max-img_min)*(type_max- type_min), type);

return;



