
video_dir = '/etc/Volume1-2TB/WanqiaoDing/GFT_videos/';
% out_dir   = '/run/user/1435550896/gvfs/smb-share:server=terracotta.psychology.pitt.edu,share=rawdata/GFT_Sayette/pipeline_out/';
out_dir   = '/etc/Volume1-2TB/WanqiaoDing/GFT_out/';
%video_dir = '/home/wanqiao/workspace/data/test_video/';
%out_dir   = '/home/wanqiao/workspace/data/test_out/';
zface_dir = '/home/wanqiao/workspace/pipeline/zface/';
FETA_dir  = '/home/wanqiao/workspace/pipeline/FETA/';
AU_dir    = '/home/wanqiao/workspace/pipeline/AU_detector/';

run_zface = true;
run_FETA  = false;
run_AU    = false;

runPipeline(video_dir,out_dir,zface_dir,FETA_dir,AU_dir,run_zface,run_FETA,...
            run_AU,'zface_save_video',true,'verbose',true,...
            'zface_parallel',true);




