mkdir 'test_out/';

if isunix
    video_dir = './test_video';
    out_dir   = './test_out';
    zface_dir = '../zface/';
    FETA_dir  = '../FETA/';
    AU_dir    = '../AU_detector/';
else
    video_dir = '..\..\data\test_videos\';
    out_dir   = '..\..\data\test_out\';
    zface_dir = '..\zface\';
    FETA_dir  = '..\FETA\';
    AU_dir    = '..\AU_detector';
end

run_zface = true;
run_FETA  = true;
run_AU    = true;

runPipeline(video_dir,out_dir,zface_dir,FETA_dir,AU_dir,run_zface,run_FETA,...
            run_AU,'zface_save_video',true,'verbose',true);




