function runZface(zface_param,video_dir,varargin)

% runZface generates zface outputs of videos in the given directory.
%   Input arguments: 
%   - zface_param: zface_param struct, output from initOutDir()
%   - video_dir: char array, the absolute path of the videos
%   Optional arguments:
%   - save_fit: boolean, if or not to save fit file. Default is true.
%   - save_video: boolean, if or not to save the tracked face video. 
%     Default is true.
%   - save_video_ext: the format of zface output video.(MATLAB can't write 
%     .mp4 videos on Linux)

    % Parse optional arguments
    p = inputParser;
    default_save_fit   = true;
    default_save_video = true;
    default_multi_thread   = false;
    default_save_video_ext = '.avi';
    default_debug_mode     = false; 
    addOptional(p,'save_fit',default_save_fit);
    addOptional(p,'save_video',default_save_video);
    addOptional(p,'save_video_ext',default_save_video_ext);
    addOptional(p,'debug_mode',default_debug_mode);
    addOptional(p,'multi_thread',default_multi_thread);
    parse(p,varargin{:});
    global_save_fit   = p.Results.save_fit;
    global_save_video = p.Results.save_video;
    save_video_ext    = p.Results.save_video_ext;
    debug_mode        = p.Results.debug_mode;
    multi_thread      = p.Results.multi_thread;

    % Check if the given video format is valid
    valid_ext = [".avi",".mj2",".mp4",".m4v"];
    ext_str   = convertCharsToStrings(save_video_ext);
    if ~(ismember(ext_str,valid_ext))
        error('Cannot write zface output video: invalid given video format\n');
    end

    % Check if the system is Linux and the output format is .avi
    islinux = (~ismac) & (~ispc);
    if islinux && (ext_str ~= ".avi")
        msg = ['Cannot write zface output video: cannot write',...
               ' .mp4 videos on Linux.\n'];
        error(msg);
    end

    old_zface_mat   = listDirItems(zface_param.matOut,'file_ext','.mat');
    old_zface_video = listDirItems(zface_param.videoOut,'is_file',true,...
                                   'is_dir',false);
    video_dir_list  = dir(video_dir);
    [file_num, ~]   = size(video_dir_list);

    zface_param.mesh = fullfile(zface_param.folder,'ZFace_models',...
                                'zf_ctrl49_mesh512.dat');
    zface_param.alt2 = fullfile(zface_param.folder,...
                                'haarcascade_frontalface_alt2.xml');

    % Loop through each file in the given folder
    process_list = []; % the list of all videos need to process.
    for file_index = 1 : file_num

        save_video = global_save_video;
        save_fit   = global_save_fit;

    	video_name  = video_dir_list(file_index).name;
    	[~,fname,~] = fileparts(video_name);
    	video_path 	= fullfile(video_dir,video_name);
        
        if ~isVideoFile(video_path)
            continue
        end

        % Get full path and file names of outputs 
    	fit_path         = fullfile(zface_param.matOut,[fname '_fit.mat']);
	    zface_video_path = fullfile(zface_param.videoOut,...
                                    [fname '_zface' save_video_ext]);
        fit_fname_str   = convertCharsToStrings([fname '_fit.mat']);
        video_fname_str = convertCharsToStrings([fname '_zface' save_video_ext]);
        if (~isempty(old_zface_mat)) && ismember(fit_fname_str,old_zface_mat)
            save_fit = false;
        end
        if (~isempty(old_zface_video)) && ismember(video_fname_str,old_zface_video)
            save_video = false;
        end
        
        video_info = [];
        video_info.path = video_path;
        video_info.fit  = fit_path;
        video_info.zface_video = zface_video_path;
        process_list = [process_list, video_info];
    end
    
    % run zface on each video
    if multi_thread
        parfor video_index = 1 : length(process_list)
            v = process_list(video_index);
            runZfaceSingleVideo(zface_param,v.path,v.zface_video,v.fit,...
                                'save_fit',save_fit,'save_video',save_video,...
                                'debug_mode',debug_mode);
        end
    else
        for video_index = 1 : length(process_list)
            v = process_list(video_index);
            runZfaceSingleVideo(zface_param,v.path,v.zface_video,v.fit,...
                                'save_fit',save_fit,'save_video',save_video,...
                                'debug_mode',debug_mode);
        end
    end

end
