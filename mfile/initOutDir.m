function [zface_param,FETA_param,AU_param] = initOutDir(zface_folder, ...
         FETA_folder, AU_folder, output_dir)
% TODO: need a new function, initArgs, which will be based on initOutDir.
% initOutDir initialized output folder structure and set up parameters for the 
% pipeline
%   Input arguments:
%   - zface_folder: char array, path of zface source. 
%   - FETA_folder: char array, path of FETA source.
%   - AU_folder: char array, path of AU detector source.
%   - output_dir: char array, path of the output directory.

    if ~(isfolder(zface_folder))
        error('Given path of ZFace source is invalid\n');
    end

    if ~(isfolder(FETA_folder))
        error('Given path of FETA source is invalid\n')
    end

    if ~(isfolder(AU_folder))
        error('Given path of AU detector source is invalid\n')
    end

    fprintf('Initializing pipeline modules'' parameters.\n');

	zface_param = [];
	FETA_param  = [];
	AU_param    = [];

	zface_param.folder = dir_full_path(zface_folder);
	FETA_param.folder  = dir_full_path(FETA_folder);
	AU_param.folder    = dir_full_path(AU_folder);

	zface_param.outDir = fullfile(output_dir,'zface_out');
	FETA_param.outDir  = fullfile(output_dir,'feta_out');
	AU_param.outDir    = fullfile(output_dir,'AU_detector_out');
	zface_param.matOut = fullfile(zface_param.outDir,'zface_fit');
	FETA_param.normOut = fullfile(FETA_param.outDir,'feta_norm_videos');
	FETA_param.featOut = fullfile(FETA_param.outDir,'feta_feat');
	zface_param.videoOut    = fullfile(zface_param.outDir,'zface_videos');
	FETA_param.annotatedOut = fullfile(FETA_param.outDir,...
                                       'feta_norm_annotated_videos');
	FETA_param.fitNormOut   = fullfile(FETA_param.outDir,'feta_fit_norm');

	createDir(zface_param.outDir);
	createDir(FETA_param.outDir);
	createDir(AU_param.outDir);
	createDir(zface_param.matOut);
	createDir(zface_param.videoOut);
	createDir(FETA_param.normOut);
	createDir(FETA_param.annotatedOut);
	createDir(FETA_param.fitNormOut);
	createDir(FETA_param.featOut);

% 	addpath(genpath(output_dir));
	    
	output_dir   = dir_full_path(output_dir);
	zface_param.outDir = dir_full_path(zface_param.outDir);
	FETA_param.outDir  = dir_full_path(FETA_param.outDir);
	AU_param.outDir    = dir_full_path(AU_param.outDir);
	zface_param.matOut = dir_full_path(zface_param.matOut);
	FETA_param.normOut = dir_full_path(FETA_param.normOut);
	FETA_param.featOut = dir_full_path(FETA_param.featOut);
	zface_param.videoOut    = dir_full_path(zface_param.videoOut);
	FETA_param.annotatedOut = dir_full_path(FETA_param.annotatedOut);
	FETA_param.fitNormOut   = dir_full_path(FETA_param.fitNormOut);

    fprintf('Initialization finished.\n');

end
