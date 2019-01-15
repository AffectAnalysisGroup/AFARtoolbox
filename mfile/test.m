% Testing runZface.m

video_dir  = '/Users/wanqiaod/workspace/pipeline/test_video';
output_dir = '/Users/wanqiaod/workspace/pipeline/out';
zface_folder = '/Users/wanqiaod/workspace/pipeline/zface';
FETA_folder  = '/Users/wanqiaod/workspace/pipeline/FETA';
AU_folder    = '/Users/wanqiaod/workspace/pipeline/AU_detector';
[zface,FETA,AU] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir,...
							 false);
addpath(genpath('.'));



