function runZface(video_dir,zface)
		
    video_dir_list = dir(video_dir);
    [file_num, ~]  = size(video_dir_list);
    for file_index = 1 : file_num

    	if video_dir_list(file_index).isdir
    		continue
    	end

    	video_name    = video_dir_list(file_index).name
    	[~,fname,ext] = fileparts(video_name);
    	video_path 	  = fullfile(video_dir,video_name);
    	fit_path      = fullfile(zface.matOut,[fname '_fit.mat']);
    	zface_video_fname = [fname '_zface' ext];
	    zface_video_path  = fullfile(zface.videoOut,zface_video_fname);
    	% runZfaceSingleVideo(zface_dir,zface_video_fname,zface_video_path,...
    	% 				    fit_path);
    	
    end

end