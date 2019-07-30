function runAUdetector(FETA, AU, video_dir)

	video_dir_list = dir(video_dir);
	[file_num,~]   = size(video_dir_list);

	for n = 1: file_num
		video_name = video_dir_list(n).name;
		video_path = fullfile(video_dir_list(n).folder,video_dir_list(n).name);
		if ~isVideoFile(video_path)
			continue
		end
		[~,fname,ext] = fileparts(video_name);
    	runAUSingleVideo(fname,FETA,AU);
    end

end

