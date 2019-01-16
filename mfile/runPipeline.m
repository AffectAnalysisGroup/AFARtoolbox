% function runPipeline(video_dir,output_dir,run_zface,run_FETA,run_AU_detector)
    video_dir  = '/Users/wanqiaod/workspace/pipeline/test_video';
    output_dir = '/Users/wanqiaod/workspace/pipeline/out';
    zface_folder = '/Users/wanqiaod/workspace/pipeline/zface';
    FETA_folder  = '/Users/wanqiaod/workspace/pipeline/FETA';
    AU_folder    = '/Users/wanqiaod/workspace/pipeline/AU_detector';

    mkdir(output_dir);

    % [zface,FETA,AU] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir,...
    %                              false);
    [zface,FETA,AU] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir);

    addpath(genpath('.'));

    runZface(video_dir,zface);
    % run FETA
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
    runFETA(video_dir,zface,FETA);

    AU.nAU = 12;
    runAUdetector(video_dir,FETA,AU);

% end



