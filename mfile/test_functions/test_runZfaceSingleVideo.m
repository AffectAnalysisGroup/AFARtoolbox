test_video = '/Users/wanqiaod/workspace/data/test_video/';
test_out   = '/Users/wanqiaod/workspace/data/test_out/';
test_fname = 'F005_01.mp4';

video_dir    = test_video;
output_dir   = test_out;
zface_folder = '/Users/wanqiaod/workspace/pipeline/zface';
FETA_folder  = '/Users/wanqiaod/workspace/pipeline/FETA';
AU_folder    = '/Users/wanqiaod/workspace/pipeline/AU_detector';

[zface,~,~] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir,false);
zface.mesh  = fullfile(zface.folder,'ZFace_models','zf_ctrl49_mesh512.dat');
zface.alt2  = fullfile(zface.folder,'haarcascade_frontalface_alt2.xml');
video_path  = fullfile(video_dir,test_fname);
fit_path    = fullfile(zface.matOut,[test_fname '_fit.mat']);
zface_video_path = fullfile(zface.videoOut,[test_fname '_zface' '.avi']);

runZfaceSingleVideo(zface,video_path,zface_video_path,fit_path,...
                    'save_fit',false,'save_video',true);







