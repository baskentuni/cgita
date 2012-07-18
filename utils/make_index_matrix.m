function mat_out = make_index_matrix(size_vec)

nr = size_vec(1);
nc = size_vec(2);
nz = size_vec(3);

mat_out = zeros(nr*nc*nz, 3);
temp1 = repmat((1:nc), [nr nz]);
temp1 = temp1(:);
mat_out(:,2) = temp1;

mat_out(:,1) = repmat((1:nr)', [nc*nz 1]);

temp1 = repmat(1:nz, [nr*nc 1]);
temp1 = temp1(:);
mat_out(:,3) = temp1;

return;