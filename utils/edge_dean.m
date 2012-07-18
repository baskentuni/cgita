function img_out = edge_dean(img_in)

img_temp = zeros(size(img_in));
img_temp1 = zeros(size(img_in));

for idx1 = 2:size(img_in, 1)-1
    for idx2 = 2:size(img_in, 2)-1
        if img_in(idx1, idx2)
            if sum([img_in(idx1-1, idx2) img_in(idx1+1, idx2) img_in(idx1, idx2-1) img_in(idx1, idx2+1)]) < 4
                img_temp1(idx1-1, idx2)=1;
                img_temp1(idx1+1, idx2)=1; 
                img_temp1(idx1, idx2-1)=1;
                img_temp1(idx1, idx2+1)=1;
            end
        end
    end
end

img_in = (img_in+img_temp1)>0;

for idx1 = 2:size(img_in, 1)-1
    for idx2 = 2:size(img_in, 2)-1
        if img_in(idx1, idx2)
            if sum([img_in(idx1-1, idx2) img_in(idx1+1, idx2) img_in(idx1, idx2-1) img_in(idx1, idx2+1)]) == 4
                img_temp(idx1, idx2) = 1;
            end
        end
    end
end

img_out = img_in-img_temp;

return;