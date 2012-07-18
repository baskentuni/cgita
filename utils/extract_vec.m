function vec_line = extract_vec(mat_in, direction_idx, line_idx)
switch direction_idx 
    case 1 % right, take the whole row
        vec_line = mat_in(line_idx, :);
    case 2 % take the column
        vec_line = mat_in(:, line_idx);
    case 3 % take the diagonal
        offset = size(mat_in, 2)-1 - (line_idx-1);
        vec_line = diag(mat_in, offset);
    case 4
        offset = size(mat_in, 2)-1 - (line_idx-1);
        vec_line = (diag(fliplr(mat_in), offset));
        vec_line = flipud(vec_line(:));
    case 5 % Take the z direction vec
        vec_line = mat_in(line_idx, :);
    case 6
        offset = size(mat_in, 2)-1 - (line_idx-1);
        vec_line = diag(mat_in, offset);
    case 7
        offset = size(mat_in, 2)-1 - (line_idx-1);
        vec_line = (diag(fliplr(mat_in), offset));
        vec_line = flipud(vec_line(:));
    case 8
        offset = size(mat_in, 2)-1 - (line_idx-1);
        vec_line = diag(mat_in, offset);
    case 9
        offset = size(mat_in, 2)-1 - (line_idx-1);
        vec_line = (diag(fliplr(mat_in), offset));
        vec_line = flipud(vec_line(:));        
end
vec_line = vec_line(:)'; % convert all to a row vector

return;
