%% ------------------------------------------------------------------------
% ZFace SDK images demo
% 
% (c) Laszlo A. Jeni (laszlo.jeni@ieee.org), 2012-2015
%
%% ------------------------------------------------------------------------
clear all;

addpath('.\ZFace_src');
addpath(genpath('.\3rd_party\'));
zf = CZFace('.\ZFace_models\zf_ctrl49_mesh512.dat','haarcascade_frontalface_alt2.xml');

vo = VideoReader('.\test_video\LeBlanc_short.mp4');
vw = VideoWriter('.\test_video\LeBlanc_short_zface.mp4','MPEG-4');
vw.FrameRate = vo.FrameRate;
open(vw);

I = read(vo,1);
h = InitDisplay( zf, I );
ctrl2D = [];

fit = [];
for i = 1:vo.NumberOfFrames
    I = read(vo,i);
    
	[ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );      
    UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );

    F = getframe(h.fig);
    [X, Map] = frame2im(F);    
    writeVideo(vw,X);

    fit(i).isTracked = ~isempty(ctrl2D);
    if fit(i).isTracked
        fit(i).pts_2d = ctrl2D;
        fit(i).pts_3d = mesh3D;
        fit(i).headPose = pars(4:6);
        fit(i).pdmPars = pars;
    else
        fit(i).pts_2d = [];
        fit(i).pts_3d = [];
        fit(i).headPose = [];
        fit(i).pdmPars = [];
    end    
    
end

clear zf;
close(h.fig);
close(vw);
save('.\test_video\LeBlanc_short_fit.mat','fit');