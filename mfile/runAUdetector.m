function runAUdetector(FETA, AU, video_dir,varargin)

    p = inputParser;
    default_verbose = false;
    default_log_fid = -1;
    addOptional(p,'verbose',default_verbose);
    addOptional(p,'log_fid',default_log_fid);
    parse(p,varargin{:});
    verbose = p.Results.verbose;
    log_fid = p.Results.log_fid;

	video_dir_list = dir(video_dir);
	[file_num,~]   = size(video_dir_list);

    if file_num == 0
        printWrite('Nothing to process.\n',log_fid);
        return;
    end

    f = waitbar(0,'Processing AU detection');
    pause(.5)
	for n = 1: file_num
		video_name = video_dir_list(n).name;
		video_path = fullfile(video_dir_list(n).folder,video_dir_list(n).name);
		if ~isVideoFile(video_path)
			continue
		end
		[~,fname,ext] = fileparts(video_name);
        % waitbar_msg = sprintf('Running AU detection on %s',video_name);
        waitbar_msg = 'Running AU detection.';
        waitbar(n/file_num,f,waitbar_msg,'Interpreter','none');
    	runAUSingleVideo(fname,FETA,AU,'verbose',verbose,'log_fid',log_fid);
    end
    close(f)

end

