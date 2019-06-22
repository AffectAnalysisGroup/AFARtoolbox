function runZfaceSingleVideo(zface_param,video_path,zface_video_path,...
                             fit_path,varargin)

% runZfaceSingleVideo saves zface video/fit files of a given video.
%   Input arguments:
%   -zface_param: a struct containing mesh/alt2 path and other parameters.
%   -video_path: the path of the video folder. 
%   -zface_video_path: the full path of the output zface video. 
%   -fit_path: the full path of the output zface fit file.
%   Optional input arguments:
%   -save_fit: if or not to save fit file. Default is true.
%   -save_video: if or not to save the tracked face video. Default is true.

    % Parse optional arguments
    p = inputParser;
    default_save_fit   = true;
    default_save_video = true;
    addOptional(p,'save_fit',default_save_fit);
    addOptional(p,'save_video',default_save_video);
    parse(p,varargin{:}); 
    save_fit   = p.Results.save_fit;
    save_video = p.Results.save_video;

    if (~save_fit && ~save_video)
        % if not save fit or video, nothing to save, quit.
        return
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

    I = readFrame(vo);
    h = InitDisplay(zf,I);
    ctrl2D = [];

    fit = [];
    vo.CurrentTime = 0;
    frame_index    = 0;
    while hasFrame(vo)
        % Track each frame
        I = readFrame(vo);
        frame_index = frame_index + 1;
      [ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );
        UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );

        F = getframe(h.fig);
        [X, Map] = frame2im(F);
        if save_video
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
    end

    clear zf;
    close(h.fig);

    if save_video
        close(vw);
    end

    if save_fit
        save(fit_path,'fit');
    end

end
