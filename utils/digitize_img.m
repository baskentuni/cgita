function out = digitize_img(img_in_double, output_type, outmin, outmax, inmin, inmax)

if nargin < 5    
    inmax = max(img_in_double(:));
    if nargin < 4
        inmin = min(img_in_double(:));
    end
end

if inmax == inmin
    out = cast(img_in_double/inmax, output_type);
else
    out = cast((outmax-outmin)*(img_in_double-inmin)/(inmax-inmin) + outmin, output_type);
end

return;