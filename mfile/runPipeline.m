function runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
                     run_zface,run_FETA,run_AU_detector,create_out,varargin)

    p = inputParser;
    default_debug_mode       = false;
    default_zface_save_fit   = true;
    default_zface_save_video = false;
    addOptional(p,'debug_mode',default_debug_mode);
    addOptional(p,'zface_save_fit',default_zface_save_fit);
    addOptional(p,'zface_save_video',default_zface_save_video);
    parse(p,varargin{:});
    debug_mode       = p.Results.debug_mode;
    zface_save_fit   = p.Results.zface_save_fit;
    zface_save_video = p.Results.zface_save_video;

    if create_out
        mkdir(output_dir);
    end

    [zface_param,FETA_param,AU_param] = initOutDir(zface_folder,FETA_folder,...
                                        AU_folder,output_dir,create_out);
    addpath(genpath('.'));

    % ZFace module
    if run_zface
        runZface(zface_param,video_dir,'debug_mode',debug_mode,...
                 'save_fit',zface_save_fit,'save_video',zface_save_video);
    end


    % FETA module
    load('ms3D_v1024_low_forehead.mat');
    FETA.lmSS = ':';
    FETA.res  = 200;
    FETA.IOD  = 80;
    FETA.ms3D = ms3D;
    FETA.normFeature = '2D_similarity';
    FETA.descFeature = 'HOG_OpenCV';
    FETA.patch_size  = 32;
    FETA.video_list  = getTrackingList(video_dir);
    FETA.saveNormVideo      = true;
    FETA.saveNormLandmarks  = true;
    FETA.saveVideoLandmarks = true;
    if run_FETA
        runFETA(zface_param,FETA_param,video_dir);
    end

    % AU detection module
    AU.nAU = 12;
    AU.meanSub = false;
    if run_AU_detector
        runAUdetector(FETA_param,AU_param,video_dir);
    end
end



