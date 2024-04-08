clc;
clear all;
close all;


%% AFAR toolbox has been validated on the following environment, later versions/environments should be tried at own-risk
% Windows 10
% MATLAB 2020b (later versions of matlab break AFAR due to its updated deeplearning toolbox)
% Visual Studio 2015
% OpenCV 3.4.1


% add mexopencv and opencv compiled dependencies to matlab environment
addpath(genpath('C:\dev'));

% add paths to different modules that constitute AFAR
zface_dir = '<PATH TO AFARTOOLBOX>/zface/';
FETA_dir  = '<PATH TO AFARTOOLBOX>/FETA/';
AU_dir    = '<PATH TO AFARTOOLBOX>/AU_detector/';


% add all modules to matlab environment 

addpath(genpath(zface_dir))
addpath(genpath(FETA_dir))
addpath(genpath(AU_dir))



% Your directory of videos that need to be processed and where they should be saved
video_dir = './test_video';
out_dir   = './test_out';

% What modules need to be run on the videos
run_zface = true;
run_FETA  = true;
run_AU    = true;

%% verbose might enable some visualizations of Z-face
verbose = true;
% if you want to save zface output
save_zface_video = false;
% would you like to conceal the identity of the person in the video using a black bar across eyes
de_identify = true;

% run-time visualization only works on serial processing
% set the following flags in runZfaceSingleVideo.m for mesh+headpose visualizations
% visualization of zface
%     display_img = true;
%     demo_mode   = true;
% furthermore plot_functions/DemoUpdateDisplay.m has components that can be turned on-off to manage
% visualization components


%% call different AFAR modules to process the video_dir content and output is saved to out_dir
% x_parallel sets the x-module to process input in parallel on matlab. Note that for visualization, it should be disabled by setting to false
runPipeline(video_dir,out_dir,zface_dir,FETA_dir,AU_dir,run_zface,run_FETA,run_AU,...
            'zface_save_video',save_zface_video,...
            'de_identify',de_identify,...
            'verbose',verbose, 'zface_parallel', true, 'feta_parallel', true);




