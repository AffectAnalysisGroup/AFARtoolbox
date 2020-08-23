% TODO: add zface dynamics outputs:
%   TODO: blink_rate, mouth opening, head movements(displacement and velocity)
%       1. Add optional arguments for all functions, runPipeline, runZface, runZfaceSingleVideo
%       2. 
%   TODO: frame level parallel

video_dir = '~/workspace/pipeline/example/test_video';
out_dir   = '~/workspace/pipeline/example/test_out';
zface_dir = '~/workspace/pipeline/zface/';
FETA_dir  = '~/workspace/pipeline/FETA/';
AU_dir    = '~/workspace/pipeline/AU_detector/';

run_zface = true;
run_FETA  = false;
run_AU    = false;

% runPipeline(video_dir,out_dir,zface_dir,FETA_dir,AU_dir,run_zface,run_FETA,...
%             run_AU,'zface_save_video',true,'verbose',true);
log_fn = 'pipeline_log.txt';
runZface(video_dir,out_dir,zface_dir,'save_fit',true,'save_video',false,...
         'parallel',false,'verbose',true,'log_fn',log_fn);

% optional arguments for runPipeline

