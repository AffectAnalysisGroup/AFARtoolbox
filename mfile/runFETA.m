function runFETA(FETA_param,video_dir,out_dir,varargin)

% runFETA generates normalized outputs for AU detector.
%   Input arguments:
%   - FETA_param: FETA_param struct, output from initOutDir().
%   - video_dir: char array, the absolute path of the videos.
%   - out_dir: char array, the absolute path of the AFAR outputs.
    
    p = inputParser;
    % FETA_out/feta_feat.mat is always saved.
    default_verbose  = false;
    default_log_fn   = '';
    default_parallel = false;
    default_save_norm_video     = true;  % FETA_out/feta_norm_videos
    default_save_fit_norm       = true; % FETA_out/feta_fit_norm
    default_save_norm_annotated = false; % FETA_out/feta_norm_annotated.
    addOptional(p,'verbose',default_verbose);
    addOptional(p,'log_fn',default_log_fn);
    addOptional(p,'parallel',default_parallel);
    addOptional(p,'save_norm_video',default_save_norm_video);
    addOptional(p,'save_fit_norm',default_save_fit_norm);
    addOptional(p,'save_norm_annotated',default_save_norm_annotated);
    parse(p,varargin{:});
    verbose  = p.Results.verbose;
    log_fn   = p.Results.log_fn;
    parallel = p.Results.parallel;
    FETA_param.save_norm_video     = p.Results.save_norm_video;
    FETA_param.save_fit_norm       = p.Results.save_fit_norm;
    FETA_param.save_norm_annotated = p.Results.save_norm_annotated;

	tracking_dir = video_dir;

	ms3D = FETA_param.ms3D;
	IOD  = FETA_param.IOD;
	res  = FETA_param.res;

	if FETA_param.normFeature == '2D_similarity'
	    normFunc = @fet_norm_2D_similarity;
	else
	    fprintf('No function handle chosen for normFunc.');
	    return
	end

    % TODO: choose desc feature from input arg
	switch FETA_param.descFeature
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
	        fprintf('No function handle chosen for descFunc.\n');
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

    log_fid = -1;
    if verbose
        if ~isempty(log_fn)
            log_fid = fopen(log_fn,'a+');
        end
        % print feta setting summary
        video_dir_nobs = correctPathFormat(video_dir); 
        % no back slash char array for print.
        printWrite(sprintf('%s Running feta on %s.\n',getMyTime(),...
                   video_dir_nobs),log_fid);
        printWrite(sprintf('\t norm. function: %s \n',...
                   FETA_param.normFeature),log_fid);
        printWrite(sprintf('\t desc. function: %s \n',...
                   FETA_param.descFeature),log_fid);
    end

    fit_dir      = out_dir;
    process_list = getFetaProcessList(tracking_dir,FETA_param,out_dir);
    video_cnt    = length(process_list);
    if video_cnt == 0
        printWrite('Nothing to process for FETA.\n',log_fid);
        return
    end

    if parallel
        p = gcp();
        for i = 1 : video_cnt 
            v = process_list(i);
            video_path = fullfile(video_dir,v.path);
            f(i) = parfeval(p,@runFetaSingleVideo,0,video_path,'',ms3D,...
                fit_dir,out_dir,normFunc,res,IOD,FETA_param.lmSS,...
                descFunc,FETA_param.patch_size,v.save_norm_video,...
                v.save_fit_norm,v.save_norm_annotated,'verbose',verbose,...
                'log_fn',log_fn);
        end
        for i = 1 : video_cnt
            v = process_list(i);
            [completedNdx] = fetchNext(f);
            msg = sprintf(' -- %s done: %s \n',getMyTime(),...
                          correctPathFormat(v.path));
            printWrite(msg,log_fid);
            % display(f(completedNdx).Diary);
        end
    else
        for i = 1 : video_cnt 
            v = process_list(i);
            video_path = fullfile(video_dir,v.path);
            runFetaSingleVideo(video_path,'',ms3D,fit_dir,out_dir,...
                normFunc,res,IOD,FETA_param.lmSS,descFunc,...
                FETA_param.patch_size,v.save_norm_video,v.save_fit_norm,...
                v.save_norm_annotated,'verbose',verbose,'log_fn',log_fn);
        end
    end

    if log_fid ~= -1
        fclose(log_fid);
    end
	
end
