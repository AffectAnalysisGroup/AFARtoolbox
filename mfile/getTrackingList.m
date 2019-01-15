function tracking_list_path = getTrackingList(tracking_dir)
    tracking_fname = 'tracking_list.txt';
    fid    = fopen(tracking_fname,'w');
    videos = dir(tracking_dir);
    [video_cnt,~]  = size(videos);
    for n = 1 : video_cnt
        if videos(n).isdir
            continue
        end
        video_path = [videos(n).folder videos(n).name '\n'];
        fprintf(fid, video_path);
   end 
   fclose(fid);
   tracking_list_path = which(tracking_fname);
end

