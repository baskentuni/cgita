function filename = list_all_files(itempath, current_list, prev_path)

% First check if it is a folder or a file
% If folder, do nest search
% If file, return complete path including filename
% Current list should be a cell array

%dir_return = dir(dirname);

if isempty(itempath)
    error('Input itempath must be non-empty');
end


if strcmp(itempath, '.')
    filename = [];
    return;
end

if strcmp(itempath, '..')
    filename = [];
    return;
end

completename = fullfile(prev_path, itempath);

if isdir(completename)
    %dir_content = fullfile(itempath, dir_return, '');
    %dir_complete = fullfile(path, itempath);
    dir_content = dir(completename);
    content = current_list;
    for idx = 1:length(dir_content)
        out = list_all_files(dir_content(idx).name, current_list, completename);
        if ~isempty(out)
            content = [content; out];
        end
    end
    filename = content;
    
    return;
else
    % file
    %completename = fullfile(prev_path, itempath);
    filename = [current_list; completename];
    return;
end

return;