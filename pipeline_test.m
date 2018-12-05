%% ------------------------------------------------------------------------
% ZFace SDK images demo
% 
% (c) Laszlo A. Jeni (laszlo.jeni@ieee.org), 2012-2015
%
%% ------------------------------------------------------------------------

addpath(genpath('.'));
zface_dir   = dir_full_path('zface');
feta_dir    = dir_full_path('feta');
au_dir      = dir_full_path('AU_detector');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%% Change your input and output directory here %%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
video_file = 'LeBlanc_short.mp4';
video_dir  = './test_video';
video_dir  = dir_full_path(video_dir);
output_dir = fullfile('.','out');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,fname,ext] = fileparts(video_file);
zface_out_dir = fullfile(output_dir,'zface_out');
feta_out_dir  = fullfile(output_dir,'feta_out');
au_out_dir    = fullfile(output_dir,'AU_detector_out');
if ~isfolder(output_dir) 
    mkdir(output_dir);
    mkdir(zface_out_dir);
    mkdir(feta_out_dir);
    mkdir(au_out_dir);
end
output_dir    = dir_full_path(output_dir);
zface_out_dir = dir_full_path(zface_out_dir);
feta_out_dir  = dir_full_path(feta_out_dir);
au_out_dir    = dir_full_path(au_out_dir);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Zface module
% mesh_path = fullfile(zface_dir,'ZFace_models','zf_ctrl49_mesh512.dat');
% alt2_path = fullfile(zface_dir,'haarcascade_frontalface_alt2.xml');
% video_path = fullfile(video_dir,video_file);
% zface_video_fname = [fname '_zface' ext];
% zface_video_path  = fullfile(zface_out_dir,zface_video_fname);

% zf = CZFace(mesh_path,alt2_path);
% vo = VideoReader(video_path);
% vw = VideoWriter(zface_video_path,'MPEG-4');
% vw.FrameRate = vo.FrameRate;
% open(vw);

% I = readFrame(vo);
% h = InitDisplay(zf,I);
% ctrl2D = [];

% fit = [];
% frame_index = 0;
% while hasFrame(vo)
%     I = readFrame(vo);
%     frame_index = frame_index + 1;
%   [ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );
%     UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );

%     F = getframe(h.fig);
%     [X, Map] = frame2im(F);
%     writeVideo(vw,X);
%     fit(frame_index).isTracked = ~isempty(ctrl2D);
%     if fit(frame_index).isTracked
%         fit(frame_index).pts_2d   = ctrl2D;
%         fit(frame_index).pts_3d   = mesh3D;
%         fit(frame_index).headPose = pars(4:6);
%         fit(frame_index).pdmPars  = pars;
%     else
%         fit(frame_index).pts_2d   = [];
%         fit(frame_index).pts_3d   = [];
%         fit(frame_index).headPose = [];
%         fit(frame_index).pdmPars  = [];
%     end    
%     pause(1/vo.FrameRate)
% end

% clear zf;
% close(h.fig);
% close(vw);
% fit_fname = [fname '_fit.mat'];
% fit_path  = fullfile(zface_out_dir,fit_fname);
% save(fit_path,'fit');


% FETA module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Change your input video directory here %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
video_list   = 'list_to_process.txt';
tracking_dir = video_dir;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Change FETA parameters here %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
normFeature = '2D_similarity';
descFeature = 'HOG_OpenCV';
patch_size  = 32;
saveNormVideo      = false;
saveNormLandmarks  = false;
saveVideoLandmarks = false;
lmSS = '1:end';
res  = 400;
IOD  = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('ms3D_v1024_low_forehead');
if ~isfile(video_list)
    fprintf('Cannot find provided list to process. Try changing input_list.\n');
    return
end

if normFeature == '2D_similarity'
    normFunc = @fet_norm_2D_similarity;
else
    fprintf('No function handle chosen for normFunc.');
    return
end

switch descFeature
    case {'HOG_OpenCV'}
        descFunc = @fet_desc_HOG_OpenCV;
    case {'No_feature'}
        descFunc = @fet_desc_No_Features;
    case {'Raw_Texture'}
        descFunc = @fet_desc_Raw_Texture;
    case {'SIFT_OpenCV'}
        descFunc = @fet_desc_SIFT_OpenCV;
    case {'SIFT_VLFeat'}
        descFunc = @fet_desc_SIFT_VLFeat;
    otherwise
        fprintf('No function handle chosen for descFunc.');
        return
end

% IOD normalization
e1 = mean(ms3D(37:42,:));
e2 = mean(ms3D(43:48,:));
d  = dist3D(e1,e2);

ms3D  = ms3D * (IOD/d);
minXY = min(ms3D(:,1:2),[],1);
maxXY = max(ms3D(:,1:2),[],1);

ms3D(:,1) = ms3D(:,1) - (maxXY(1) + minXY(1))/2 + res/2;
ms3D(:,2) = ms3D(:,2) - (maxXY(2) + minXY(2))/2 + res/2;

fprintf('input list:\t%s\n',video_list);
fprintf('tracking dir:\t%s\n',video_dir);
fprintf('output dir:\t%s\n',feta_out_dir);
fprintf('norm. function:\t%s\n',normFeature);
fprintf('desc. function:\t%s\n',descFeature);
fprintf('\n');

descExt = [];
fprintf('reading list: ');
fid = fopen(video_list);
C   = textscan(fid,'%q%q');
fprintf('found %d item(s) to process\n\n',length(C{1,1}));
fclose(fid);

p = gcp();
fit_dir = zface_out_dir;
nItems  = length(C{1,1});
for i = 1:nItems
    fn = C{1,1}{i,1};
    if length(C{1,2}) >= i
        strFr = C{1,2}{i,1};    
    else
        strFr = '';
    end
    fprintf(fn);
    f(i) = parfeval(p,@fet_process_single,0,fn,strFr,ms3D,tracking_dir,...
                    fit_dir,feta_out_dir,normFunc,res,IOD,lmSS,descFunc,...
                    patch_size,saveNormVideo,saveNormLandmarks,...
                    saveVideoLandmarks);
end

for i = 1:nItems
  [completedNdx] = fetchNext(f);
  fprintf('done: %s.\n', C{1,1}{completedNdx,1});
  display(f(completedNdx).Diary);
  fprintf('\n');
  progressbar(i/nItems);
end



