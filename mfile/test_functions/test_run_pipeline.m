% Testing runZface.m

video_dir    = '/Users/wanqiaod/workspace/data/B';
output_dir   = '/Users/wanqiaod/workspace/data/B_out';
zface_folder = '/Users/wanqiaod/workspace/pipeline/zface';
FETA_folder  = '/Users/wanqiaod/workspace/pipeline/FETA';
AU_folder    = '/Users/wanqiaod/workspace/pipeline/AU_detector';
run_zface    = true;
run_FETA     = true;
run_AU       = false;
create_out   = false;

runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
            run_zface,run_FETA,run_AU,create_out);


