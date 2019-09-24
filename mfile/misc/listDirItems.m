function target_items = listDirItems(target_dir,varargin)
   
    p = inputParser;
    default_is_file  = true;
    default_is_dir   = false;
    default_file_ext = "";
    default_with_dir = false;
    addOptional(p,'is_file',default_is_file);
    addOptional(p,'is_dir',default_is_dir);
    addOptional(p,'file_ext',default_file_ext);
    addOptional(p,'with_dir',default_with_dir);
    parse(p,varargin{:}); 
    is_file  = p.Results.is_file;
    is_dir   = p.Results.is_dir;
    file_ext = p.Results.file_ext;
    with_dir = p.Results.with_dir;

    dir_list_struct = dir(target_dir);
    target_items    = [];
    for n = 1 : length(dir_list_struct)
        if with_dir
            fname_str = convertCharsToStrings(fullfile(...
            dir_list_struct(n).folder,dir_list_struct(n).name));
        else
            fname_str = convertCharsToStrings(dir_list_struct(n).name);
        end

        if fname_str == "." || fname_str == ".."
            continue
        end
        [~,~,ext] = fileparts(fname_str);
        exclude_item = false;
        item_is_dir  = dir_list_struct(n).isdir;
        if item_is_dir
            if is_file
                exclude_item = true;
            end
        else % the element is a file.
            if is_dir
                exclude_item = true;
            end
            if file_ext ~= "" && ext ~= file_ext
                exclude_item = true;
            end
        end
        if ~exclude_item
            target_items = [target_items fname_str];
        end
    end
end
