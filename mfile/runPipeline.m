function runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
                     run_zface,run_FETA,run_AU_detector,varargin)
    % runPipeline processes the videos in the given folder thru zface, feta
    % and AU detector on the choice of callers.
    %   Input arguments:
    %       video_dir: the directory videos locate.
    %       output_dir: the top directory where the outputs will be.
    %       zface_folder: zface source code folder.
    %       FETA_folder: feta source code folder.
    %       AU_folder: au detector source code folder.
    %       run_zface: bool, if run videos thru zface.
    %       run_feta: bool, if run videos thru feta.
    %       run_AU_detector: bool, if run videos thru AU detector.
    %   Optional arguments:
    %       verbose: bool, if set to true, processing log will be printed. 
    %           Default set to false.
    %       save_log: bool, if set to true, processing log will be saved in a 
    %           txt file. Default set to false.
    %       zface_save_fit: bool, if set to true, zface tracking results will be
    %           saved as a mat file. Default set to true.
    %       zface_save_video: bool, if set to true, zface result visualization 
    %           videos will be saved. Default set to false.
    %       zface_parallel: bool, if set to true, zface will run in parallel. 
    %           Default set to false. Make sure you have the parallel toolbox
    %           installed before running it. 
    %       de_identify: bool, if set to true, zface visualization videos will
    %           come with a bar masking the tracked target. Default set to 
    %           false.
    %       feta_parallel: bool, if set to true, feta will run in parallel. 
    %           Default set to false.
    %       feta_resolution: double, side length of the normalization window.
    %           Default set to 200. (That means normalization result will be 
    %           a video with size of 200 x 200 pixel)
    %       feta_IOD: double, interocular distance. Default set to 80.
    %       feta_patch_size: double, feta path size. Default set to 32.
    %       au_meansub: bool, if set to true. AU occurrence detection will 
    %           run with mean substraction. Default set to false.
    %

    % TODO: change the optional arg to a struct to pass between functions.
    p = inputParser;
    default_verbose  = false;
    default_save_log = false;
    default_zface_save_fit   = true;
    default_zface_save_video = false;
    default_zface_parallel   = false;
    default_de_identify      = false;
    default_feta_parallel    = false;
    default_feta_resolution  = 200;
    default_feta_IOD         = 80;
    default_feta_patch_size  = 32;
    default_au_meansub       = false;
    addOptional(p,'verbose',default_verbose);
    addOptional(p,'save_log',default_save_log);
    addOptional(p,'zface_save_fit',default_zface_save_fit);
    addOptional(p,'zface_save_video',default_zface_save_video);
    addOptional(p,'zface_parallel',default_zface_parallel);
    addOptional(p,'de_identify',default_de_identify);
    addOptional(p,'feta_parallel',default_feta_parallel);
    addOptional(p,'feta_resolution',default_feta_resolution);
    addOptional(p,'feta_IOD',default_feta_IOD);
    addOptional(p,'feta_patch_size',default_feta_patch_size);
    addOptional(p,'au_meansub',default_au_meansub);
    parse(p,varargin{:});
    verbose  = p.Results.verbose;
    save_log = p.Results.save_log;
    % zface parameters
    zface_save_fit   = p.Results.zface_save_fit;
    zface_save_video = p.Results.zface_save_video;
    zface_parallel   = p.Results.zface_parallel;
    de_identify      = p.Results.de_identify;
    % FETA parameters
    feta_parallel    = p.Results.feta_parallel;
    feta_resolution  = p.Results.feta_resolution;
    feta_IOD         = p.Results.feta_IOD;
    feta_patch_size  = p.Results.feta_patch_size;
    % AU parameters
    au_meansub = p.Results.au_meansub;

    addpath(genpath('.'));

    if ~isfolder(output_dir), error('Given output folder is not valid.'); end
    
    log_fn = 'AFAR_process_log.txt';
    if save_log
        if isfile(log_fn), log_fid = fopen(log_fn,'a+');
        else, log_fid = fopen(log_fn,'w'); end
    else, log_fid = -1; end

    % video dir with no backslash(bs)
    video_dir_nobs = correctPathFormat(video_dir);

    % ZFace module
    if run_zface
        if verbose
            printWrite(sprintf('\n%s Running Zface on %s\n',getMyTime(),...
                       video_dir_nobs),log_fid);
        end
        runZface(video_dir,output_dir,zface_folder,'save_fit',...
                 zface_save_fit,'save_video',zface_save_video,'parallel',...
                 zface_parallel,'verbose',verbose,'log_fn',log_fn,...
                 'de_identify',de_identify);
    end
    
    % FETA module
    load('ms3D_v1024_low_forehead.mat');
    FETA_param = [];
    FETA_param.lmSS = ':';
    FETA_param.res  = feta_resolution;
    FETA_param.IOD  = feta_IOD;
    FETA_param.ms3D = ms3D;
    FETA_param.folder      = FETA_folder;
    FETA_param.normFeature = '2D_similarity';
    FETA_param.descFeature = 'HOG_OpenCV';
    FETA_param.patch_size  = feta_patch_size;
    if run_FETA
        if verbose
            printWrite(sprintf('\n%s Running FETA on %s\n',getMyTime(),...
                       video_dir_nobs),log_fid);
        end
        runFETA(FETA_param,video_dir,output_dir,'verbose',verbose,...
                'log_fn',log_fn,'parallel',feta_parallel);
    end

    % AU detection module
    % TODO: runAUdetector, add checking existing outputs part
    AU_param = [];
    AU_param.folder  = AU_folder;
    AU_param.meanSub = au_meansub;
    if run_AU_detector
        printWrite(sprintf('\n%s Running AU detector %s\n',getMyTime(),...
                   video_dir_nobs),log_fid,'no_action',~verbose);
        runAUdetector(FETA_param,AU_param,video_dir,output_dir,'verbose',...
                      verbose,'log_fid',log_fid);
    end

    if save_log
        fclose(log_fid);
    end
end


