function runPipeline(video_dir,output_dir,run_zface,run_FETA,run_AU_detector)
    addpath(genpath('.'));
    zface = [];
    FETA  = [];
    AU    = [];
    zface.folder = dir_full_path('zface');
    FETA.folder  = dir_full_path('FETA');
    AU.folder    = dir_full_path('AU_detector');

    % output_dir = fullfile('.','out'); MAKE SURE OUTPUT DIR IS FULL DIR

    % [~,fname,ext] = fileparts(video_file);
    zface.outDir = fullfile(output_dir,'zface_out');
    FETA.outDir  = fullfile(output_dir,'feta_out');
    AU.outDir    = fullfile(output_dir,'AU_detector_out');
    zface.matOut = fullfile(zface.outDir,'zface_fit');
    FETA.normOut = fullfile(FETA.outDir,'feta_norm')
    FETA.featOut = fullfile(FETA.outDir,'feta_feat');
    zface.videoOut    = fullfile(zface.outDir,'zface_videos');
    FETA.annotatedOut = fullfile(FETA.outDir,'feta_norm_annotated_videos');
    FETA.fitNormOut   = fullfile(FETA.outDir,'feta_fit_norm');

    if ~isfolder(output_dir)
      mkdir(output_dir)
    end

    mkdir(zface.outDir);
    mkdir(FETA.outDir);
    mkdir(AU.outDir);
    mkdir(zface.matOut);
    mkdir(zface.videoOut);
    mkdir(FETA.normOut);
    mkdir(FETA.annotatedOut);
    mkdir(FETA.fitNormOut);
    mkdir(FETA.featOut);
    addpath(genpath(output_dir));
        
    output_dir   = dir_full_path(output_dir);
    zface.outDir = dir_full_path(zface.outDir);
    FETA.outDir  = dir_full_path(FETA.outDir);
    AU.outDir    = dir_full_path(AU.outDir);
    zface.matOut = dir_full_path(zface.matOut);
    FETA.normOut = dir_full_path(FETA.normOut);
    FETA.featOut = dir_full_path(FETA.featOut);
    zface.videoOut    = dir_full_path(videoOut);
    FETA.annotatedOut = dir_full_path(annotatedOut);
    FETA.fitNormOut   = dir_full_path(fitNormOut);

    if run_zface
        runZface(video_dir,zface);
    end
    % if run_FETA
    %     runFETA();
    % end
    % if run_AU_detector
    %     runAUDetector();
    % end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% FETA module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Change your input video directory here %%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% video_list   = 'list_to_process.txt';
% tracking_dir = video_dir;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%% Change FETA parameters here %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if run_FETA
%     lmSS = ':';
%     res  = 200;
%     IOD  = 80;
%     normFeature = '2D_similarity';
%     descFeature = 'HOG_OpenCV';
%     patch_size  = 32;
%     saveNormVideo      = true;
%     saveNormLandmarks  = true;
%     saveVideoLandmarks = true;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     load('ms3D_v1024_low_forehead');
%     if ~isfile(video_list)
%         fprintf('Cannot find provided list to process. Try changing input_list.\n');
%         return
%     end

%     if normFeature == '2D_similarity'
%         normFunc = @fet_norm_2D_similarity;
%     else
%         fprintf('No function handle chosen for normFunc.');
%         return
%     end

%     switch descFeature
%         case {'HOG_OpenCV'}
%             descFunc = @fet_desc_HOG_OpenCV;
%         case {'No_feature'}
%             descFunc = @fet_desc_No_Features;
%         case {'Raw_Texture'}
%             descFunc = @fet_desc_Raw_Texture;
%         case {'SIFT_OpenCV'}
%             descFunc = @fet_desc_SIFT_OpenCV;
%         case {'SIFT_VLFeat'}
%             descFunc = @fet_desc_SIFT_VLFeat;
%         otherwise
%             fprintf('No function handle chosen for descFunc.');
%             return
%     end

%     % IOD normalization
%     e1 = mean(ms3D(37:42,:));
%     e2 = mean(ms3D(43:48,:));
%     d  = dist3D(e1,e2);

%     ms3D  = ms3D * (IOD/d);
%     minXY = min(ms3D(:,1:2),[],1);
%     maxXY = max(ms3D(:,1:2),[],1);

%     ms3D(:,1) = ms3D(:,1) - (maxXY(1) + minXY(1))/2 + res/2;
%     ms3D(:,2) = ms3D(:,2) - (maxXY(2) + minXY(2))/2 + res/2;

%     fprintf('input list:\t%s\n',video_list);
%     fprintf('tracking dir:\t%s\n',video_dir);
%     fprintf('output dir:\t%s\n',feta_out_dir);
%     fprintf('norm. function:\t%s\n',normFeature);
%     fprintf('desc. function:\t%s\n',descFeature);
%     fprintf('\n');

%     descExt = [];
%     fprintf('reading list: ');
%     fid = fopen(video_list);
%     C   = textscan(fid,'%q%q');
%     fprintf('found %d item(s) to process\n\n',length(C{1,1}));
%     fclose(fid);

%     p = gcp();
%     fit_dir = zface_out_mat;
%     nItems  = length(C{1,1});
%     for i = 1:nItems
%         fn = C{1,1}{i,1};
%         if length(C{1,2}) >= i
%             strFr = C{1,2}{i,1};    
%         else
%             strFr = '';
%         end
%         f(i) = parfeval(p,@fet_process_single,0,fn,strFr,ms3D,tracking_dir,...
%                         fit_dir,feta_out_dir,normFunc,res,IOD,lmSS,descFunc,...
%                         patch_size,saveNormVideo,saveNormLandmarks,...
%                         saveVideoLandmarks);
%     end

%     for i = 1:nItems
%       [completedNdx] = fetchNext(f);
%       fprintf('done: %s.\n', C{1,1}{completedNdx,1});
%       display(f(completedNdx).Diary);
%       fprintf('\n');
%       progressbar(i/nItems);
%     end
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%
% %% Input: Normalized Video (FETA Output) obtained with the following parameters:
% %% Resolution = 200
% %% Interocular distance = 80
% %%
% %% Output: AU probabilities of the following 12 AUs:
% %% AU1, AU2, AU4, AU6, AU7, AU10, AU12, AU14, AU15, AU17, AU23, AU24 
% %%
% %% Requirements: importKerasNetwork function requires MATLAB 2018a or
% %% later version and Deep Learning Toolbox.
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if run_AU_detector
%     norm_fn   = [fname,'_norm.mp4'];
%     norm_path = fullfile(feta_out_norm,norm_fn);
%     net = importKerasNetwork('cnn_model.json', 'WeightFile', 'weights.h5', ...
%                              'OutputLayerType', 'regression');
%     nAU = 12;
%     video_name = norm_path; %%% update this line with your own normalized video
%     v = VideoReader(video_name);

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%% Compute mean of video %%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     sum_fr = zeros(200,200);
%     counter = 1;
%     while hasFrame(v)
%             I = readFrame(v);
%             if size(I,1) ~= 200 || size(I,2) ~= 200
%                 error('Frame size should be 200 x 200.')
%             end
%             I2 = rgb2gray(I);
%             if sum(I2(:)) < 10
%                 continue
%             end
%             I2_conv = (double(I2)/255);
%             sum_fr = sum_fr + I2_conv;
%             counter = counter + 1;
%     end
%     mean_video = mean(sum_fr(:))/counter;

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%% Obtain AU probabilities for 12 AUS %%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     v = VideoReader(video_name);
%     all_outputs = [];
%     while hasFrame(v)
%             I = readFrame(v);
%             I2 = rgb2gray(I);
%             I2_conv = (double(I2)/255) - mean_video;
%             sample_output = predict(net,I2_conv);
%             all_outputs = [all_outputs;sample_output];

%     end

%     result = array2table(all_outputs, 'VariableNames', ...
%                         {'AU1', 'AU2', 'AU4', 'AU6', 'AU7', 'AU10', 'AU12', ...
%                          'AU14', 'AU15', 'AU17', 'AU23', 'AU24'});
%     au_out_fn   = [fname,'_au_out.mat'];
%     au_out_path = fullfile(au_out_dir,au_out_fn);
%     save(au_out_path, 'result');
% end


