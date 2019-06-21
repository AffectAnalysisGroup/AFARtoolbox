% Testing runZface.m

video_dir    = '/Users/wanqiaod/workspace/data/FG_video';
output_dir   = '/Users/wanqiaod/workspace/data/FG_out';
zface_folder = '/Users/wanqiaod/workspace/pipeline/zface';
FETA_folder  = '/Users/wanqiaod/workspace/pipeline/FETA';
AU_folder    = '/Users/wanqiaod/workspace/pipeline/AU_detector';
run_zface    = false;
run_FETA     = false;
run_AU       = true;
create_out   = false;
% % Test initOutDir()
% [zface,FETA,AU] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir,...
% 							 false);
% addpath(genpath('.'));

% runZface(video_dir,zface);

runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
            run_zface,run_FETA,run_AU,create_out);


