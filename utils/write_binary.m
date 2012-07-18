function x = write_binary(filename, format, data, endian)

if exist('endian') %#ok<EXIST>
    if strcmp(endian, 'big')
        fid = fopen(filename, 'w', 'b');
    else
        fid = fopen(filename, 'w');
    end
else
    fid = fopen(filename, 'w');
end

fwrite(fid, data, format);
% 
% if ~isempty(dim)
%     x = reshape(fread(fid, format),dim);
% else
%     x = fread(fid, format);
% end

fclose(fid);

return;
    


