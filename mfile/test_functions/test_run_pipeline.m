% Testing runZface.m

video_dir    = '/home/wanqiao/workspace/data/test_video';
output_dir   = '/home/wanqiao/workspace/data/test_out';
zface_folder = '/home/wanqiao/workspace/pipeline/zface';
FETA_folder  = '/home/wanqiao/workspace/pipeline/FETA';
AU_folder    = '/home/wanqiao/workspace/pipeline/AU_detector';
run_zface    = true;
run_FETA     = false;
run_AU       = false;
create_out   = false;

runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
            run_zface,run_FETA,run_AU,create_out);


