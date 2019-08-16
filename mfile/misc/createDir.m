function createDir(target_dir)
    if ~isfolder(target_dir)
        mkdir(target_dir);
    end
end
