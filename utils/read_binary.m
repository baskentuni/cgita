function x = read_binary(filename, format, dim, endian)
% read_binary(filename, format, dim, endian)
% dim and endian are optional
if exist('endian') %#ok<EXIST>
    if strcmp(endian, 'big')
        fid = fopen(filename, 'r', 'b');
    else
        fid = fopen(filename, 'r');
    end
else
    fid = fopen(filename, 'r');
end

if exist('dim')
    if ~isempty(dim)
        x = reshape(fread(fid, format),dim);
    else
        x = fread(fid, format);
    end
else
    x = fread(fid, format);
end

fclose(fid);

return;
    


