function runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
                     run_zface,run_FETA,run_AU_detector,varargin)

    % TODO: set up AFAR processing server folder.
    % TODO: solve bug with parallel worker number greater than processing videos
    % TODO: modify fet_process_single
    % TODO: finalize verbose messages.

    p = inputParser;
    default_verbose    = false;
    default_save_log   = false;
    default_zface_save_fit   = true;
    default_zface_save_video = false;
    default_zface_parallel   = false;
    addOptional(p,'verbose',default_verbose);
    addOptional(p,'save_log',default_save_log);
    addOptional(p,'zface_save_fit',default_zface_save_fit);
    addOptional(p,'zface_save_video',default_zface_save_video);
    addOptional(p,'zface_parallel',default_zface_parallel);
    parse(p,varargin{:});
    verbose    = p.Results.verbose;
    save_log   = p.Results.save_log;
    zface_save_fit   = p.Results.zface_save_fit;
    zface_save_video = p.Results.zface_save_video;
    zface_parallel   = p.Results.zface_parallel;

    if ~isfolder(output_dir)
        error('Given output folder is not valid.\n');
    end
    
    if save_log
        log_fn = 'AFAR_process_log.txt';
        if isfile(log_fn)
            log_fid = fopen(log_fn,'a+');
        else
            log_fid = fopen(log_fn,'w');
        end
    else
        log_fid = -1;
    end

    [zface_param,FETA_param,AU_param] = initOutDir(zface_folder,FETA_folder,...
                                        AU_folder,output_dir);
    addpath(genpath('.'));

    % ZFace module
    if run_zface
        if verbose
            printWrite(sprintf('\n%s Running Zface on %s\n',getMyTime(),video_dir),log_fid);
        end
        runZface(zface_param,video_dir,...
                 'save_fit',zface_save_fit,'save_video',zface_save_video,...
                 'multi_thread',zface_parallel,'verbose',verbose,...
                 'log_fid',log_fid);
    end
    
    % TODO: Add verbose option for FETA and AU detection.
    % FETA module
    load('ms3D_v1024_low_forehead.mat');
    FETA_param.lmSS = ':';
    FETA_param.res  = 250;
    FETA_param.IOD  = 80;
    FETA_param.ms3D = ms3D;
    FETA_param.normFeature = '2D_similarity';
    FETA_param.descFeature = 'HOG_OpenCV';
    FETA_param.patch_size  = 32;
    FETA_param.video_list  = getTrackingList(video_dir);
    if run_FETA
        if verbose
            printWrite(sprintf('\n%s Running FETA on %s\n',getMyTime(),video_dir),log_fid);
        end
        runFETA(zface_param,FETA_param,video_dir);
    end

    % AU detection module
    AU_param.nAU = 12;
    AU_param.meanSub = false;
    if run_AU_detector
        runAUdetector(FETA_param,AU_param,video_dir);
    end
end



