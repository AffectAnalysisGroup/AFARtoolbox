function runFETA(video_dir,zface,FETA)

	tracking_dir = video_dir;

	ms3D = FETA.ms3D;
	IOD  = FETA.IOD;
	res  = FETA.res;

	if ~isfile(FETA.video_list)
		fprintf('Cannot find provided list to process. Try changing input_list.\n');
	        return
	    end

	if FETA.normFeature == '2D_similarity'
	    normFunc = @fet_norm_2D_similarity;
	else
	    fprintf('No function handle chosen for normFunc.');
	    return
	end

	switch FETA.descFeature
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

	fprintf('input list:\t%s\n',FETA.video_list);
	fprintf('tracking dir:\t%s\n',video_dir);
	fprintf('output dir:\t%s\n',FETA.outDir);
	fprintf('norm. function:\t%s\n',FETA.normFeature);
	fprintf('desc. function:\t%s\n',FETA.descFeature);
	fprintf('\n');

	descExt = [];
	fprintf('reading list: ');
	fid = fopen(FETA.video_list);
	C   = textscan(fid,'%q%q');
	fprintf('found %d item(s) to process\n\n',length(C{1,1}));
	fclose(fid);

	p = gcp();
	fit_dir = zface.matOut;
	nItems  = length(C{1,1});
	for i = 1:nItems
	    fn = C{1,1}{i,1};
	    if length(C{1,2}) >= i
	        strFr = C{1,2}{i,1};    
	    else
	        strFr = '';
	    end
	    fprintf([fn '\n']);
	    f(i) = parfeval(p,@fet_process_single,0,fn,strFr,ms3D,tracking_dir,...
	                    fit_dir,FETA.outDir,normFunc,res,IOD,...
	                    FETA.lmSS,descFunc,FETA.patch_size,...
	                    FETA.saveNormVideo,FETA.saveNormLandmarks,...
	                    FETA.saveVideoLandmarks);
	end

	for i = 1:nItems
	  [completedNdx] = fetchNext(f);
	  fprintf('done: %s.\n', C{1,1}{completedNdx,1});
	  display(f(completedNdx).Diary);
	  fprintf('\n');
	  progressbar(i/nItems);
	end

end