mkdir 'test_out/';

<<<<<<< HEAD

if isunix
    video_dir = './test_video';
    out_dir   = './test_out';
    zface_dir = '../zface/';
    FETA_dir  = '../FETA/';
    AU_dir    = '../AU_detector/';
else
    video_dir = '.\test_video\';
    out_dir   = '.\test_out\';
    zface_dir = '..\zface\';
    FETA_dir  = '..\FETA\';
    AU_dir    = '..\AU_detector';
end
=======
video_dir = '/etc/Volume1-2TB/WanqiaoDing/GFT_videos/';
% out_dir   = '/run/user/1435550896/gvfs/smb-share:server=terracotta.psychology.pitt.edu,share=rawdata/GFT_Sayette/pipeline_out/';
out_dir   = '/etc/Volume1-2TB/WanqiaoDing/GFT_out/';
%video_dir = '/home/wanqiao/workspace/data/test_video/';
%out_dir   = '/home/wanqiao/workspace/data/test_out/';
zface_dir = '/home/wanqiao/workspace/pipeline/zface/';
FETA_dir  = '/home/wanqiao/workspace/pipeline/FETA/';
AU_dir    = '/home/wanqiao/workspace/pipeline/AU_detector/';
>>>>>>> feta_debug

run_zface = true;
run_FETA  = false;
run_AU    = false;

runPipeline(video_dir,out_dir,zface_dir,FETA_dir,AU_dir,run_zface,run_FETA,...
<<<<<<< HEAD
            run_AU,'verbose',true,'zface_save_video',true);
=======
            run_AU,'zface_save_video',true,'verbose',true,...
            'zface_parallel',true);
>>>>>>> feta_debug




