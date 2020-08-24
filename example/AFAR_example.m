
video_dir = './test_video';
out_dir   = './test_out';
zface_dir = '../zface/';
FETA_dir  = '../FETA/';
AU_dir    = '../AU_detector/';

run_zface = true;
run_FETA  = true;
run_AU    = true;

runPipeline(video_dir,out_dir,zface_dir,FETA_dir,AU_dir,run_zface,run_FETA,...
            run_AU,'zface_save_video',true,'verbose',true);




