function runZfaceSingleVideo(zface_param,video_path,zface_video_path,...
                             fit_path,varargin)

% runZfaceSingleVideo saves zface video/fit files of a given video.
%   Input arguments:
%   - zface_param: a struct containing mesh/alt2 path.
%   - video_path: char array, the path of the video folder. 
%   - zface_video_path: char array, the full path of the output zface video. 
%   - fit_path: char array, the full path of the output zface fit file.
%   Optional input arguments:
%   - verbose: boolean, verbose option
%   - log_fn: char array, file name of the log that verbose writes to
%   - save_fit: boolean, if not to save fit file. Default true.
%   - save_video: boolean, if to save the tracked face video. Default true.
%   - save_dynamics: boolean, if to save the head movement dynamics(head 
%                    movement/diplacement), blink rate and mouth opening
%   - start_frame: integer, start frame of tracking
%   - end_frame: integer, end frame of tracking

    % Parse optional arguments
    p = inputParser;
    default_verbose  = false;
    default_log_fn   = '';
    default_save_fit    = true;
    default_save_video  = false;
    default_start_frame = -1;
    default_end_frame   = -1;
    default_save_dynamics = true;
    default_de_identify   = false;
    default_display_dense_mesh = false;
    default_demo_mode = false;

    addOptional(p,'verbose',default_verbose);
    addOptional(p,'log_fn',default_log_fn);
    addOptional(p,'save_fit',default_save_fit);
    addOptional(p,'save_video',default_save_video);
    addOptional(p,'start_frame',default_start_frame);
    addOptional(p,'end_frame',default_end_frame);
    addOptional(p,'save_dynamics',default_save_dynamics);
    addOptional(p,'de_identify',default_de_identify);
    addOptional(p,'display_dense_mesh',default_display_dense_mesh);
    addOptional(p,'demo_mode',default_demo_mode);

    parse(p,varargin{:}); 
    verbose = p.Results.verbose;   
    log_fn  = p.Results.log_fn;
    save_fit    = p.Results.save_fit;
    save_video  = p.Results.save_video;
    start_frame = p.Results.start_frame;
    end_frame   = p.Results.end_frame;
    de_identify = p.Results.de_identify;
    save_dynamics = p.Results.save_dynamics;
    display_img = p.Results.verbose;
    display_mesh = p.Results.display_dense_mesh;
    demo_mode   = p.Results.demo_mode;

% maneesh changed these lines
%     display_img = true;
%     demo_mode   = true;

    if verbose
        if ~isempty(log_fn)
            log_fid = fopen(log_fn,'a+');
        else
            log_fid = -1; % provide an invalid fid if file name not provided
        end
        printWrite(sprintf('%s Processing zface on %s \n',getMyTime(),...
                   correctPathFormat(video_path)),log_fid);
        % Print if fid is not valid. Write to the file if fid is valid
    end

    [~,video_fname,video_ext] = fileparts(video_path);
    if (~save_fit && ~save_video)
        % if not save fit or video, nothing to save, quit.
        printWrite(sprintf('Zface output %s already exists, skipped.\n',...
                   video_fname),log_fid);
        return
    end

 	mesh_path  = zface_param.mesh;
    alt2_path  = zface_param.alt2;
    zf = CZFace(mesh_path,alt2_path); % zface object
    vo = VideoReader(video_path);     % video object(reader)

    if save_video
        vw = VideoWriter(zface_video_path); % video writer
        vw.FrameRate = vo.FrameRate; % match the frame rate
        open(vw);
    end
    
    fit    = [];
    ctrl2D = [];
    vo.CurrentTime  = 0;
    frame_index     = 0;
    fit_frame_index = 0;

    while hasFrame(vo)

        % Track each frame
        I = readFrame(vo);
        if frame_index == 0 && display_img% first frame
            if demo_mode; h = DemoInitDisplay(zf,I);
            else; h = InitDisplay(zf,I);
            end
        end
        frame_index = frame_index + 1;
                
        if (start_frame < 0 && end_frame < 0)
        % If input arg doesn't specify the start/end frame, use frame_index.
        % Otherwise, check if current frame_index is within the given range.
            fit_frame_index = frame_index;
        else
            if (frame_index >= start_frame && frame_index <= end_frame)
            % if input args specify the start/end frame, incr fit_frame_index 
            % every iteration. Otherwise, skip this iteration.
                fit_frame_index = fit_frame_index + 1;
            else
                continue;
            end
        end


      [ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );

        if display_img
            if demo_mode
                DemoUpdateDisplay(h,zf,I,ctrl2D,mesh2D,mesh3D,pars, 'dense_mesh', display_mesh, 'de_identify', de_identify);
                F = getframe(h.fig);
            else
                UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );
                F = getframe(h.fig);
            end
            [X, Map] = frame2im(F);
            if save_video
                writeVideo(vw,X);
            end
        end

        
        fit(fit_frame_index).frame     = frame_index;
        fit(fit_frame_index).isTracked = ~isempty(ctrl2D);
        if fit(fit_frame_index).isTracked
            fit(fit_frame_index).pts_2d   = ctrl2D;
            fit(fit_frame_index).pts_3d   = mesh3D;
            fit(fit_frame_index).headPose = pars(4:6);
            fit(fit_frame_index).pdmPars  = pars;
        else
            fit(fit_frame_index).pts_2d   = [];
            fit(fit_frame_index).pts_3d   = [];
            fit(fit_frame_index).headPose = [];
            fit(fit_frame_index).pdmPars  = [];
        end    
        if mod(fit_frame_index,5) == 0 && verbose 
            msg = sprintf('%s -- %d frames tracked from %s\n',getMyTime(),...
                          fit_frame_index,video_fname);
            printWrite(msg,log_fid);
        end

    end

    clear zf;

    if display_img
        close(h.fig);
        if save_video
            close(vw);
        end
    end

    if save_fit;save(fit_path,'fit');end

    if verbose
        printWrite(sprintf('%s %s tracking saved.\n',getMyTime(),...
                   correctPathFormat(video_path)),log_fid);
        if ~isempty(log_fn);fclose(log_fid);end
    end

end
