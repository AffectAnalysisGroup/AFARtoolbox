video_path = '/Users/wanqiaod/workspace/pipeline/test_video/F005_01.avi';
zface_fit_path = '/Users/wanqiaod/workspace/pipeline/out/zface_out/zface_fit/F005_01_fit.mat';
% zface_fit_path = '/Users/wanqiaod/workspace/pipeline/out/zface_out/zface_fit/1080_provoc_1017_fit.mat';
out_video_path = '/Users/wanqiaod/workspace/pipeline/visualization/F005_01_blink.avi';
load(zface_fit_path);
start_frame = 1;
end_frame   = 0;
total_frame = size(fit,2);
if end_frame == 0
    end_frame = total_frame;
end
plot_x      = start_frame:end_frame;
blink_threshold = 35;
getBlinkFreq(fit,blink_threshold);
load('blink_info.mat');
avg_dist = avg_dist(start_frame:end_frame);
blink_avg_y = blink_avg_y(start_frame:end_frame);

window_x0 = 100;
window_y0 = 100;
window_w  = 1000;
window_h  = 700;

orig_video = VideoReader(video_path);
out_video  = VideoWriter(out_video_path);
open(out_video);


figure
set(gcf,'position',[window_x0,window_y0,window_w,window_h])
set(gcf,'color','white');
set(gca,'Clipping','off');
video_pos   = [0.1 0.4 0.3 0.5];
eye_pnt_pos = [0.6 0.4 0.3 0.3];
avg_dist_pos  = [0.1 0.15 0.8 0.08];
blink_cnt_pos = [0.1 0.05 0.8 0.08];

video_ax    = subplot('Position',video_pos);
eye_pnt_ax  = subplot('Position',eye_pnt_pos);
avg_dist_ax  = subplot('Position',avg_dist_pos);
blink_cnt_ax = subplot('Position',blink_cnt_pos);

plot(avg_dist_ax,plot_x,avg_dist);
axis(avg_dist_ax,'tight');
plot(blink_cnt_ax,plot_x,blink_avg_y);
axis(blink_cnt_ax,'tight');

for frame_index = start_frame : end_frame
    frame_img = orig_video.read(frame_index);
    image(video_ax,frame_img);
    axis(video_ax,'off');
    singleface = fit(frame_index).pts_2d;
    singleface = singleface(20:31,:);
    scatter(eye_pnt_ax,singleface(:,1),singleface(:,2),'filled');
    axis(eye_pnt_ax,'equal');
    timeline = line(blink_cnt_ax,[frame_index frame_index],[0 3]);
    timeline2 = line(avg_dist_ax,[frame_index frame_index],[0 45]);
    set(timeline,'LineWidth',1,'Color','r');
    set(timeline2,'LineWidth',1,'Color','r');
    drawnow
    frame = getframe(gcf);
    img   = frame2im(frame);
    writeVideo(out_video,img);
    set(timeline,'Visible','off');
    set(timeline2,'Visible','off');
end
close(out_video);

% target_frame = 200;
% frame_img  = orig_video.read(target_frame);
% singleface = fit(target_frame).pts_2d;
% singleface = singleface(20:31,:);
% 
% scatter(eye_pnt_ax,singleface(:,1),singleface(:,2),'filled');



