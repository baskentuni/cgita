function img_out = apply_range(img_in, range)
img_out = img_in;
img_out(img_out<range(1)) = range(1);
img_out(img_out>range(2)) = range(2);
return;
