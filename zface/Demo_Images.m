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

h = [];
inFiles = dir('.\test_images\*.jpg');

for i = 1:length(inFiles)
    I = imread(['.\test_images\' inFiles(i).name]);
    
    [ ctrl2D, ~, ~ ] = zf.Fit( I, [] );
    [ ctrl2D, mesh2D, ~, pars ] = zf.Fit( I, ctrl2D );

    h = InitDisplay( zf, I );
    UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars );    
    
    pause;
    close(h.fig);
end

clear zf;