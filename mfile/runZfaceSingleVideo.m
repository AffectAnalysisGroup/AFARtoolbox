function runZfaceSingleVideo(zface,video_path,zface_video_path,fit_path,save_fit)

 	mesh_path  = zface.mesh;
    alt2_path  = zface.alt2;

    zf = CZFace(mesh_path,alt2_path);
    vo = VideoReader(video_path);
    vw = VideoWriter(zface_video_path,'MPEG-4');
    vw.FrameRate = vo.FrameRate;
    open(vw);

    I = readFrame(vo);
    h = InitDisplay(zf,I);
    ctrl2D = [];

    fit = [];
    frame_index = 0;
    while hasFrame(vo)
        I = readFrame(vo);
        frame_index = frame_index + 1;
      [ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );
        UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );

        F = getframe(h.fig);
        [X, Map] = frame2im(F);
        writeVideo(vw,X);
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
        % pause(1/vo.FrameRate)
    end

    clear zf;
    close(h.fig);
    close(vw);

    if save_fit
        save(fit_path,'fit');
    end
end