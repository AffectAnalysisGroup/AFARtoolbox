function runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
                     run_zface,run_FETA,run_AU_detector,varargin)

    % TODO: set up AFAR processing server folder.
    % TODO: solve bug with parallel worker number greater than processing videos
    % TODO: modify fet_process_single

    p = inputParser;
    default_debug_mode       = false;
    default_verbose          = false;
    default_zface_save_fit   = true;
    default_zface_save_video = false;
    default_zface_parallel   = false;
    addOptional(p,'debug_mode',default_debug_mode);
    addOptional(p,'verbose',default_verbose);
    addOptional(p,'zface_save_fit',default_zface_save_fit);
    addOptional(p,'zface_save_video',default_zface_save_video);
    addOptional(p,'zface_parallel',default_zface_parallel);
    parse(p,varargin{:});
    debug_mode       = p.Results.debug_mode;
    verbose          = p.Results.verbose;
    zface_save_fit   = p.Results.zface_save_fit;
    zface_save_video = p.Results.zface_save_video;
    zface_parallel   = p.Results.zface_parallel;

    if ~isfolder(output_dir)
        error('Given output folder is not valid.\n');
    end

    [zface_param,FETA_param,AU_param] = initOutDir(zface_folder,FETA_folder,...
                                        AU_folder,output_dir);
    addpath(genpath('.'));

    % ZFace module
    if run_zface
        if verbose
            fprintf('Running Zface on %s\n',video_dir);
        end
        runZface(zface_param,video_dir,'debug_mode',debug_mode,...
                 'save_fit',zface_save_fit,'save_video',zface_save_video,...
                 'multi_thread',zface_parallel,'verbose',verbose);
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
    % FETA_param.saveNormVideo      = true;
    % FETA_param.saveNormLandmarks  = true;
    % FETA_param.saveVideoLandmarks = true;
    if run_FETA
        runFETA(zface_param,FETA_param,video_dir);
    end

    % AU detection module
    AU_param.nAU = 12;
    AU_param.meanSub = false;
    if run_AU_detector
        runAUdetector(FETA_param,AU_param,video_dir);
    end
end



