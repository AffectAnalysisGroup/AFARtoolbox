function runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
                     run_zface,run_FETA,run_AU_detector,create_out)
    % create_out = true; % run the pipeline need to set the value to be true to get
    %                     % all the output dir and subdir.
    % video_dir  = '/Users/wanqiaod/workspace/pipeline/test_video';
    % output_dir = '/Users/wanqiaod/workspace/pipeline/out';
    % zface_folder = '/Users/wanqiaod/workspace/pipeline/zface';
    % FETA_folder  = '/Users/wanqiaod/workspace/pipeline/FETA';
    % AU_folder    = '/Users/wanqiaod/workspace/pipeline/AU_detector';

    if create_out
        mkdir(output_dir);
    end

    [zface,FETA,AU] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir,...
                                 create_out);
    addpath(genpath('.'));

    % ZFace
    if run_zface
        runZface(video_dir,zface,true);
    end

    % FETA
    load('ms3D_v1024_low_forehead');
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
        runFETA(video_dir,zface,FETA);
    end

    % AU detection.
    AU.nAU = 12;
    AU.meanSub = false;
    if run_AU_detector
        runAUdetector(video_dir,FETA,AU);
    end
end



