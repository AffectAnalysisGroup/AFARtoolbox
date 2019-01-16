function [zface,FETA,AU] = initOutDir(zface_folder, FETA_folder, AU_folder, ...
									  output_dir, creat_new_outDir)

	% if ~(isfolder(zface_folder))
	% need to check if args are valid.
	
	if nargin > 4
		mkdir_new = creat_new_outDir;
	else
		mkdir_new = true;
	end

	zface = [];
	FETA  = [];
	AU    = [];

	zface.folder = dir_full_path(zface_folder);
	FETA.folder  = dir_full_path(FETA_folder);
	AU.folder    = dir_full_path(AU_folder);

	zface.outDir = fullfile(output_dir,'zface_out');
	FETA.outDir  = fullfile(output_dir,'feta_out');
	AU.outDir    = fullfile(output_dir,'AU_detector_out');
	zface.matOut = fullfile(zface.outDir,'zface_fit');
	FETA.normOut = fullfile(FETA.outDir,'feta_norm_videos');
	FETA.featOut = fullfile(FETA.outDir,'feta_feat');
	zface.videoOut    = fullfile(zface.outDir,'zface_videos');
	FETA.annotatedOut = fullfile(FETA.outDir,'feta_norm_annotated_videos');
	FETA.fitNormOut   = fullfile(FETA.outDir,'feta_fit_1norm');

	if mkdir_new
		fprintf('Create folders for output results.\n');
		mkdir(zface.outDir);
		mkdir(FETA.outDir);
		mkdir(AU.outDir);
		mkdir(zface.matOut);
		mkdir(zface.videoOut);
		mkdir(FETA.normOut);
		mkdir(FETA.annotatedOut);
		mkdir(FETA.fitNormOut);
		mkdir(FETA.featOut);
	end

	addpath(genpath(output_dir));
	    
	output_dir   = dir_full_path(output_dir);
	zface.outDir = dir_full_path(zface.outDir);
	FETA.outDir  = dir_full_path(FETA.outDir);
	AU.outDir    = dir_full_path(AU.outDir);
	zface.matOut = dir_full_path(zface.matOut);
	FETA.normOut = dir_full_path(FETA.normOut);
	FETA.featOut = dir_full_path(FETA.featOut);
	zface.videoOut    = dir_full_path(zface.videoOut);
	FETA.annotatedOut = dir_full_path(FETA.annotatedOut);
	FETA.fitNormOut   = dir_full_path(FETA.fitNormOut);

end
