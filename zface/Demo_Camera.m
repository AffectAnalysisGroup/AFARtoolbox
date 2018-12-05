%% ------------------------------------------------------------------------
% ZFace SDK camera demo
% 
% (c) Laszlo A. Jeni (laszlo.jeni@ieee.org), 2012-2015
%
%% ------------------------------------------------------------------------
clear all;

addpath('.\ZFace_src');
addpath(genpath('.\3rd_party\'));
zf = CZFace('.\ZFace_models\zf_ctrl49_mesh512.dat','haarcascade_frontalface_alt2.xml');

cap = cv.VideoCapture(0);
I = cap.read;
h = InitDisplay( zf, I );
ctrl2D = [];

global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
set(gcf, 'KeyPressFcn', @myKeyPressFcn)

isRunning = true;
while isRunning
    I = cap.read;
    
	[ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );        
    UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );

    if strcmp(KEY_IS_PRESSED,'escape')
        isRunning = false;
    end

    if strcmp(KEY_IS_PRESSED,'space')
        ctrl2D = [];
        KEY_IS_PRESSED = '';
    end
end

cap.delete;
clear cap;
clear zf;
close(h.fig);