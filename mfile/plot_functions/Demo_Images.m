%% ------------------------------------------------------------------------
% ZFace SDK images demo
% 
% (c) Laszlo A. Jeni (laszlo.jeni@ieee.org), 2012-2015
%
%% ------------------------------------------------------------------------
clear all;

addpath('./ZFace_src');
addpath(genpath('./3rd_party/'));
zf = CZFace('C:\Users\wanqiao\Documents\MATLAB\pipeline\zface\ZFace_models\zf_ctrl49_mesh512.dat','C:\Users\wanqiao\Documents\MATLAB\pipeline\zface\haarcascade_frontalface_alt2.xml');

h = [];
%inFiles = dir('./test_images/*.jpg');
inFiles=dir('C:\Users\yad30\Desktop\try\image\sub1\*.png');
for i = 1:length(inFiles)
    %I = imread(['./test_images/' inFiles(i).name]);
    I = imread(['C:\Users\yad30\Desktop\try\image\sub1\', inFiles(i).name]);
    
    [ ctrl2D, ~, ~ ] = zf.Fit( I, [] );
    [ ctrl2D, mesh2D, mesh3D, pars ] = zf.Fit( I, ctrl2D );

    h = InitDisplay( zf, I );
%     DemoUpdateDisplay( h, zf, I, ctrl2D, mesh2D,,mesh3D, pars );    
    UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );    
    pause;
    close(h.fig);
end

clear zf;