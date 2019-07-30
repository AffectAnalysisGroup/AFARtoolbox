function runZfaceSingleVideo(zface_param,video_path,zface_video_path,...
                             fit_path,varargin)

% runZfaceSingleVideo saves zface video/fit files of a given video.
%   Input arguments:
%   - zface_param: a struct containing mesh/alt2 path and other parameters.
%   - video_path: char array, the path of the video folder. 
%   - zface_video_path: char array, the full path of the output zface video. 
%   - fit_path: char array, the full path of the output zface fit file.
%   Optional input arguments:
%   - save_fit: boolean, if not to save fit file. Default true.
%   - save_video: boolean, if to save the tracked face video. Default true.

    % Parse optional arguments
    p = inputParser;
    default_save_fit   = true;
    default_save_video = false;
    default_debug_mode = false;
    addOptional(p,'save_fit',default_save_fit);
    addOptional(p,'save_video',default_save_video);
    addOptional(p,'debug_mode',default_debug_mode);
    parse(p,varargin{:}); 
    save_fit   = p.Results.save_fit;
    save_video = p.Results.save_video;
    debug_mode = p.Results.debug_mode;

    if (~save_fit && ~save_video)
        % if not save fit or video, nothing to save, quit.
        return
    end

    if debug_mode
        log_file = 'zface_log';
        if isfile(log_file)
            fid = fopen(log_file,'a+');
        else
            fid = fopen(log_file,'w');
        end
        [~,v_fn,v_ext] = fileparts(video_path);
        video_fname    = [v_fn,v_ext];
        current_time   = getMyTime();
        fprintf(fid,'%s Start zface process on %s \n',current_time,...
                video_path);
    end

 	mesh_path  = zface_param.mesh;
    alt2_path  = zface_param.alt2;

    zf = CZFace(mesh_path,alt2_path);
    vo = VideoReader(video_path);

    if save_video
        vw = VideoWriter(zface_video_path);
        vw.FrameRate = vo.FrameRate;
        open(vw);
    end

    
    fit    = [];
    ctrl2D = [];
    vo.CurrentTime = 0;
    frame_index    = 0;
    while hasFrame(vo)
        % Track each frame
        I = readFrame(vo);
        if frame_index == 0 && save_video
            h = InitDisplay(zf,I);
        end
        frame_index = frame_index + 1;
      [ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );
        if save_video
            UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );
            F = getframe(h.fig);
            [X, Map] = frame2im(F);
            writeVideo(vw,X);
        end
        
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
        if mod(frame_index,500) == 0 && debug_mode 
            current_time = getMyTime();
            fprintf(fid,'%s -- %d frames tracked from %s\n', current_time,...
                    frame_index, video_fname);
        end

    end

    clear zf;

    if save_video
        close(h.fig);
        close(vw);
    end

    if debug_mode
        fclose(fid);
    end

    if save_fit
        save(fit_path,'fit');
    end

end
