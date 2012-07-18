function  tempmat = deal_with_xyz(tempmat, x1, y1, z1, x2, y2, z2)

for idx = 1:size(tempmat,1)
    vox_x = tempmat(idx, 1);
    vox_y = tempmat(idx, 2);
    vox_z = tempmat(idx, 3);
    [d i] = min(abs(x1-vox_x));
    tempmat(idx, 1) = x2(i);
    [d i] = min(abs(y1-vox_y));
    tempmat(idx, 2) = y2(i);
    [d i] = min(abs(z1-vox_z));
    tempmat(idx, 3) = z2(i);
    
end

return;

        