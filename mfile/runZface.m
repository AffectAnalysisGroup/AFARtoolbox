function runZface(video_dir,zface,save_fit)
		
    video_dir_list = dir(video_dir);
    [file_num, ~]  = size(video_dir_list);

    zface.mesh  = fullfile(zface.folder,'ZFace_models','zf_ctrl49_mesh512.dat');
    zface.alt2  = fullfile(zface.folder,'haarcascade_frontalface_alt2.xml');

    for file_index = 1 : file_num

    	video_name    = video_dir_list(file_index).name;
    	[~,fname,ext] = fileparts(video_name);
    	video_path 	  = fullfile(video_dir,video_name);
        
        if ~isVideoFile(video_path)
            continue
        end
        
    	fit_path          = fullfile(zface.matOut,[fname '_fit.mat']);
	    zface_video_path  = fullfile(zface.videoOut,[fname '_zface' ext]);
    	runZfaceSingleVideo(zface,video_path,zface_video_path,fit_path,...
                            save_fit);
        
    end

end