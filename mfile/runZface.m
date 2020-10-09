function runZface(video_dir,out_dir,zface_folder,varargin)

% runZface generates zface outputs of videos in the given directory.
%   Input arguments: 
%   - video_dir: char array, the absolute path of the videos
%   - out_dir: char array, output directory of AFAR processing 
%   - zface_folder: char array, zface code
%   Optional arguments:
%   - verbose: boolean, verbose option
%   - log_fn: boolean, verbose log file name 
%   - save_fit: boolean, if or not to save fit file. Default is true.
%   - save_video: boolean, if or not to save the tracked face video. 
%     Default is true.
%   - save_video_ext: the format of zface output video.(MATLAB can't write 
%     .mp4 videos on Linux)
%   - parallel: if run on parallel

    % Parse optional arguments
    p = inputParser;
    default_verbose    = false;
    default_log_fn     = '';
    default_save_fit   = true;
    default_save_video = false;
    default_parallel   = false;
    default_de_identify    = false; 
    default_save_video_ext = '.avi';

    addOptional(p,'verbose',default_verbose);
    addOptional(p,'log_fn',default_log_fn);
    addOptional(p,'save_fit',default_save_fit);
    addOptional(p,'save_video',default_save_video);
    addOptional(p,'save_video_ext',default_save_video_ext);
    addOptional(p,'parallel',default_parallel);
    addOptional(p,'de_identify',default_de_identify);

    parse(p,varargin{:});
    verbose  = p.Results.verbose;
    log_fn   = p.Results.log_fn;
    parallel = p.Results.parallel;
    global_save_fit   = p.Results.save_fit;
    global_save_video = p.Results.save_video;
    save_video_ext    = p.Results.save_video_ext;
    de_identify       = p.Results.de_identify;

    % Check if the given video format for saved video is valid.
    valid_ext = [".avi",".mj2",".mp4",".m4v"];
    ext_str   = convertCharsToStrings(save_video_ext);
    if ~(ismember(ext_str,valid_ext))
        error('Cannot write zface output video: invalid given video format\n');
    end

    % Check if the system is Linux and the output format is .avi.
    islinux = (~ismac) & (~ispc);
    if islinux && (ext_str ~= ".avi")
        msg = ['Cannot write zface output video: cannot write',...
               ' .mp4 videos on Linux.\n'];
        error(msg);
    end

    % Check the existing zface outputs
    old_zface_mat   = listDirItems(out_dir,'file_ext','.mat');
    old_zface_video = listDirItems(out_dir,'is_file',true,'is_dir',false);
    video_dir_list  = dir(video_dir);
    [file_num, ~]   = size(video_dir_list);
    % Save the mesh and alt2 path in zface_param struct
    zface_param = [];
    zface_param.folder = zface_folder;
    zface_param.mesh   = fullfile(zface_param.folder,'ZFace_models',...
                                  'zf_ctrl49_mesh512.dat');
    zface_param.alt2   = fullfile(zface_param.folder,...
                                  'haarcascade_frontalface_alt2.xml');

    % Loop through each video file in the given folder
    process_list = []; % the list of all videos need to process.
    for file_index = 1 : file_num
        % Assign the bool values for each video processing same as
        % caller's input
        save_video = global_save_video;
        save_fit   = global_save_fit;

    	video_name  = video_dir_list(file_index).name;
    	[~,fname,~] = fileparts(video_name);
    	video_path 	= fullfile(video_dir,video_name);
        % If the video is not valid, skip this iteration 
        if ~isVideoFile(video_path)
            continue
        end

        % Get full path and file names of outputs 
    	fit_path         = fullfile(out_dir,[fname '_fit.mat']);
	    zface_video_path = fullfile(out_dir,[fname '_zface' save_video_ext]);
        fit_fname_str    = convertCharsToStrings([fname '_fit.mat']);
        video_fname_str  = convertCharsToStrings([fname '_zface' save_video_ext]);
        % Check if the output is already in the output folder. If it is, 
        % overwrite the caller's save_fit/video bool value. Otherwise, don't
        % process this video
        if (~isempty(old_zface_mat)) && ismember(fit_fname_str,old_zface_mat)
            save_fit = false;
        end
        if (~isempty(old_zface_video)) && ...
           ismember(video_fname_str,old_zface_video)
            save_video = false;
        end

        % Save the fields used by runZfaceSingleVideo in each video struct
        video_info = [];
        video_info.path = video_path;
        video_info.fit  = fit_path;
        video_info.save_fit    = save_fit;
        video_info.save_video  = save_video;
        video_info.zface_video = zface_video_path;
        % Append the video struct to process_list
        process_list = [process_list, video_info];
    end
    
    % run zface on each video
    % TODO: pass all of optional args to runZfaceSingleVideo
    if parallel
        parfor video_index = 1 : length(process_list)
            v = process_list(video_index);
            runZfaceSingleVideo(zface_param,v.path,v.zface_video,v.fit,...
                                'save_fit',v.save_fit,'save_video',...
                                v.save_video,'verbose',verbose,'log_fn',...
                                log_fn);
        end
    else
        for video_index = 1 : length(process_list)
            v = process_list(video_index);
            runZfaceSingleVideo(zface_param,v.path,v.zface_video,v.fit,...
                                'save_fit',v.save_fit,...
                                'save_video',v.save_video,'de_identify',de_identify,...
                                'verbose',verbose,'log_fn',log_fn);
        end
    end
end
