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
    default_verbose    = false;
    default_log_fid    = -1;
    default_save_fit   = true;
    default_save_video = false;
    addOptional(p,'verbose',default_verbose);
    addOptional(p,'log_fid',default_log_fid);
    addOptional(p,'save_fit',default_save_fit);
    addOptional(p,'save_video',default_save_video);
    parse(p,varargin{:}); 
    verbose    = p.Results.verbose;   
    log_fid    = p.Results.log_fid;
    save_fit   = p.Results.save_fit;
    save_video = p.Results.save_video;

    if (~save_fit && ~save_video)
        % if not save fit or video, nothing to save, quit.
        return
    end

    if verbose
        printWrite(sprintf('%s Processing %s \n',getMyTime(),video_path),log_fid);
    end

    [~,video_fname,video_ext] = fileparts(video_path);

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
        if mod(frame_index,500) == 0 && verbose 
            msg = sprintf('%s -- %d frames tracked from %s\n',getMyTime(),...
                          frame_index,video_fname);
            printWrite(msg,log_fid);
        end

    end

    clear zf;

    if save_video
        close(h.fig);
        close(vw);
    end

    if save_fit
        save(fit_path,'fit');
    end

    if verbose
        printWrite(sprintf('%s %s tracking finished.\n',getMyTime(),video_path),log_fid);
    end

end
