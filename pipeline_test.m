% 1: python
% 2: GUI. Executable.
% 3: Emotion assignment.

%% ------------------------------------------------------------------------
% ZFace SDK images demo
% 
% (c) Laszlo A. Jeni (laszlo.jeni@ieee.org), 2012-2015
%
%% ------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% For debugging purpose only %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run_zface = false;
run_FETA  = false;
run_AU_detector = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('.'));
zface_dir = dir_full_path('zface');
feta_dir  = dir_full_path('feta');
au_dir    = dir_full_path('AU_detector');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Change your input and output directory here %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
video_file = 'LeBlanc_short.mp4';
video_dir  = './test_video';
video_dir  = dir_full_path(video_dir);
output_dir = fullfile('.','out');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,fname,ext] = fileparts(video_file);
zface_out_dir = fullfile(output_dir,'zface_out');
feta_out_dir  = fullfile(output_dir,'feta_out');
au_out_dir    = fullfile(output_dir,'AU_detector_out');
zface_out_mat = fullfile(zface_out_dir,'zface_fit');
feta_out_norm = fullfile(feta_out_dir,'feta_norm_videos');
feta_out_feat = fullfile(feta_out_dir,'feta_feat');
zface_out_video    = fullfile(zface_out_dir,'zface_videos');
feta_out_annotated = fullfile(feta_out_dir,'feta_norm_annotated_videos');
feta_out_fitNorm   = fullfile(feta_out_dir,'feta_fit_norm');

if ~isfolder(output_dir) 
    mkdir(output_dir);
    mkdir(zface_out_dir);
    mkdir(feta_out_dir);
    mkdir(au_out_dir);
    mkdir(zface_out_mat);
    mkdir(zface_out_video);
    mkdir(feta_out_norm);
    mkdir(feta_out_annotated);
    mkdir(feta_out_fitNorm);
    mkdir(feta_out_feat);
    addpath(genpath(output_dir));
end
output_dir    = dir_full_path(output_dir);
zface_out_dir = dir_full_path(zface_out_dir);
feta_out_dir  = dir_full_path(feta_out_dir);
au_out_dir    = dir_full_path(au_out_dir);
zface_out_mat = dir_full_path(zface_out_mat);
feta_out_norm = dir_full_path(feta_out_norm);
feta_out_feat = dir_full_path(feta_out_feat);
zface_out_video    = dir_full_path(zface_out_video);
feta_out_annotated = dir_full_path(feta_out_annotated);
feta_out_fitNorm   = dir_full_path(feta_out_fitNorm);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zface module
if run_zface
    mesh_path = fullfile(zface_dir,'ZFace_models','zf_ctrl49_mesh512.dat');
    alt2_path = fullfile(zface_dir,'haarcascade_frontalface_alt2.xml');
    video_path = fullfile(video_dir,video_file);
    zface_video_fname = [fname '_zface' ext];
    zface_video_path  = fullfile(zface_out_video,zface_video_fname);

    zf = CZFace(mesh_path,alt2_path);
    vo = VideoReader(video_path);
    vw = VideoWriter(zface_video_path,'MPEG-4');
    vw.FrameRate = vo.FrameRate;
    open(vw);

    I = readFrame(vo);
    h = InitDisplay(zf,I);
    ctrl2D = [];

    fit = [];
    frame_index = 0;
    while hasFrame(vo)
        I = readFrame(vo);
        frame_index = frame_index + 1;
      [ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );
        UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );

        F = getframe(h.fig);
        [X, Map] = frame2im(F);
        writeVideo(vw,X);
        fit(frame_index).frame     = frame_index;
        fit(frame_index).isTracked = ~isempty(ctrl2D);
        if fit(frame_index).isTracked
            fit(frame_index).pts_2d   = ctrl2D;
            fit(frame_index).pts_3d   = mesh3D;
            fit(frame_index).headPose = pars(4:6);
            fit(frame_index).pdmPars  = pars;
        else
            fit(frame_index).pts_2d   = [];
            fit(frame_index).pts_3d   = [];
            fit(frame_index).headPose = [];
            fit(frame_index).pdmPars  = [];
        end    
        pause(1/vo.FrameRate)
    end

    clear zf;
    close(h.fig);
    close(vw);
    fit_fname = [fname '_fit.mat'];
    fit_path  = fullfile(zface_out_mat,fit_fname);
    save(fit_path,'fit');
end

% FETA module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Change your input video directory here %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
video_list   = 'list_to_process.txt';
tracking_dir = video_dir;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Change FETA parameters here %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if run_FETA
    lmSS = ':';
    res  = 200;
    IOD  = 80;
    normFeature = '2D_similarity';
    descFeature = 'HOG_OpenCV';
    patch_size  = 32;
    saveNormVideo      = true;
    saveNormLandmarks  = true;
    saveVideoLandmarks = true;
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
    fit_dir = zface_out_mat;
    nItems  = length(C{1,1});
    for i = 1:nItems
        fn = C{1,1}{i,1};
        if length(C{1,2}) >= i
            strFr = C{1,2}{i,1};    
        else
            strFr = '';
        end
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
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Input: Normalized Video (FETA Output) obtained with the following parameters:
%% Resolution = 200
%% Interocular distance = 80
%%
%% Output: AU probabilities of the following 12 AUs:
%% AU1, AU2, AU4, AU6, AU7, AU10, AU12, AU14, AU15, AU17, AU23, AU24 
%%
%% Requirements: importKerasNetwork function requires MATLAB 2018a or
%% later version and Deep Learning Toolbox.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if run_AU_detector
    norm_fn   = [fname,'_norm.mp4'];
    norm_path = fullfile(feta_out_norm,norm_fn);
    net = importKerasNetwork('cnn_model.json', 'WeightFile', 'weights.h5', ...
                             'OutputLayerType', 'regression');
    nAU = 12;
    video_name = norm_path; %%% update this line with your own normalized video
    v = VideoReader(video_name);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%% Compute mean of video %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sum_fr = zeros(200,200);
    counter = 1;
    while hasFrame(v)
            I = readFrame(v);
            if size(I,1) ~= 200 || size(I,2) ~= 200
                error('Frame size should be 200 x 200.')
            end
            I2 = rgb2gray(I);
            if sum(I2(:)) < 10
                continue
            end
            I2_conv = (double(I2)/255);
            sum_fr = sum_fr + I2_conv;
            counter = counter + 1;
    end
    mean_video = mean(sum_fr(:))/counter;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% Obtain AU probabilities for 12 AUS %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    v = VideoReader(video_name);
    all_outputs = [];
    while hasFrame(v)
            I = readFrame(v);
            I2 = rgb2gray(I);
            I2_conv = (double(I2)/255) - mean_video;
            sample_output = predict(net,I2_conv);
            all_outputs = [all_outputs;sample_output];

    end

    result = array2table(all_outputs, 'VariableNames', ...
                        {'AU1', 'AU2', 'AU4', 'AU6', 'AU7', 'AU10', 'AU12', ...
                         'AU14', 'AU15', 'AU17', 'AU23', 'AU24'});
    au_out_fn   = [fname,'_au_out.mat'];
    au_out_path = fullfile(au_out_dir,au_out_fn);
    save(au_out_path, 'result');
end


