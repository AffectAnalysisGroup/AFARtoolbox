function target_items = listDirItems(target_dir,varargin)
   
    p = inputParser;
    default_is_file  = true;
    default_is_dir   = false;
    default_file_ext = "";
    addOptional(p,'is_file',default_is_file);
    addOptional(p,'is_dir',default_is_dir);
    addOptional(p,'file_ext',default_file_ext);
    parse(p,varargin{:}); 
    is_file  = p.Results.is_file;
    is_dir   = p.Results.is_dir;
    file_ext = p.Results.file_ext;

    dir_list_struct = dir(target_dir);
    target_items    = [];
    for n = 1 : length(dir_list_struct)
        fname_str = convertCharsToStrings(dir_list_struct(n).name);
        if fname_str == "." || fname_str == ".."
            continue
        end

        exclude_item = false;
        item_is_dir = dir_list_struct(n).isdir;
        if item_is_dir
            if is_file
                exclude_item = true;
            end
        else % the element is a file.
            if file_ext ~= "" && ext ~= file_ext
                exclude_item = true;
            end
        end
        if ~exclude_item
            target_items = [target_items,fname_str];
        end
    end
end
