function tracking_list_path = getTrackingList(tracking_dir)
    tracking_fname = 'tracking_list.txt';
    fid    = fopen(tracking_fname,'w');
    videos = dir(tracking_dir);
    [video_cnt,~]  = size(videos);
    for n = 1 : video_cnt
        [fpath, fn, ext] = fileparts(videos(n).name);
        ext = convertCharsToStrings(ext);
        if videos(n).isdir 
            continue
        end

        video_path = fullfile(videos(n).folder, videos(n).name);
        if ~isVideoFile(video_path)
            continue
        end

        text_to_write = [video_path '\n'];
        fprintf(fid, text_to_write);
   end 
   fclose(fid);
   tracking_list_path = which(tracking_fname);
end

