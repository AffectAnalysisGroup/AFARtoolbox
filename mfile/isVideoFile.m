function is_video = isVideoFile(fname)

    is_video = true;
    [fpath,fn,ext] = fileparts(fname);
    if ~isfile(fname) 
        is_video = false;
    end
    ext = convertCharsToStrings(ext);
    video_ext_list = [".mp4",".avi",".flv"];
    if ~ismember(ext,video_ext_list)
        is_video = false;
    end

end

