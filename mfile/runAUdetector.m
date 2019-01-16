function runAUdetector(video_dir, FETA, AU)

	video_dir_list = dir(video_dir);
	[file_num,~]   = size(video_dir_list);

	for n = 1: file_num
		if video_dir_list(n).isdir
			continue
		end
		video_name    = video_dir_list(n).name;
		[~,fname,ext] = fileparts(video_name);
    	runZfaceSingleVideo(fname,FETA,AU)
    end
 

end
