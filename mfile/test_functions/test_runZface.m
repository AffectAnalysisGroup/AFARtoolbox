test_video = '/Users/wanqiaod/workspace/data/test_video/';
test_out   = '/Users/wanqiaod/workspace/data/test_out/';
test_fname = 'F005_01.mp4';

video_dir    = test_video;
output_dir   = test_out;
zface_folder = '/Users/wanqiaod/workspace/pipeline/zface';
FETA_folder  = '/Users/wanqiaod/workspace/pipeline/FETA';
AU_folder    = '/Users/wanqiaod/workspace/pipeline/AU_detector';

[zface_param,~,~] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir,false);
zface_param.mesh  = fullfile(zface_param.folder,'ZFace_models','zf_ctrl49_mesh512.dat');
zface_param.alt2  = fullfile(zface_param.folder,'haarcascade_frontalface_alt2.xml');
runZface(zface_param,video_dir,'save_fit',true,'save_video',false,...
         'save_video_ext','.mp4');






