video_dir = './test_video';
out_dir   = './test_out';
zface_dir = '../zface/';
FETA_dir  = '../FETA/';
AU_dir    = '../AU_detector/';

run_zface = true;
run_FETA  = false;
run_AU    = false;

verbose = true;
save_zface_video = false;
de_identify      = true;

runPipeline(video_dir,out_dir,zface_dir,FETA_dir,AU_dir,run_zface,run_FETA,run_AU,...
            'zface_save_video',save_zface_video,...
            'de_identify',de_identify...
            'verbose',true);




