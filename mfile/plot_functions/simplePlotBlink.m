
video_path      = '/Users/wanqiaod/workspace/data/test_video/F005_01.avi';
zface_fit_path  = '/Users/wanqiaod/workspace/data/out/zface_out/zface_fit/F005_01_fit.mat';
out_video_path  = '/Users/wanqiaod/workspace/data/visualization/F005_01_blink.avi';
blink_threshold = 35;

% load behavioral data
behav_data = '/Users/wanqiaod/workspace/data/aDBS002_1017_provoc.mat';
load(behav_data)

load(zface_fit_path);
start_frame = 1;
end_frame   = 0;
total_frame = size(fit,2);
if end_frame == 0
    end_frame = total_frame;
end

% time course of the plots (x axis)
plot_x   = start_frame:end_frame;
blink    = getBlinkFreq(fit,blink_threshold);
avg_dist = blink.avg_dist(start_frame:end_frame);
avg_blink_cnt = blink.avg_blink_cnt(start_frame:end_frame);

% dimensions of the whole window
window_x0 = 100;
window_y0 = 100;
window_w  = 1000;
window_h  = 700;

% open the original video and output video
orig_video = VideoReader(video_path);
out_video  = VideoWriter(out_video_path);
open(out_video);

figure
% open the plot window and set background white
set(gcf,'position',[window_x0,window_y0,window_w,window_h])
set(gcf,'color','white');
set(gca,'Clipping','off');
video_pos     = [0.1 0.4 0.3 0.5]; % original video
eye_pnt_pos   = [0.6 0.4 0.3 0.3]; % eye outline landmarks
avg_dist_pos  = [0.1 0.15 0.8 0.08]; % average eyelid distance 
blink_cnt_pos = [0.1 0.05 0.8 0.08]; % average blink count over time

% get the axes for each plot
video_ax     = subplot('Position',video_pos);
eye_pnt_ax   = subplot('Position',eye_pnt_pos);
avg_dist_ax  = subplot('Position',avg_dist_pos);
blink_cnt_ax = subplot('Position',blink_cnt_pos);

% plot average eyelid distance
plot(avg_dist_ax,plot_x,avg_dist);
axis(avg_dist_ax,'tight');
% plot average blink count
plot(blink_cnt_ax,plot_x,avg_blink_cnt);
axis(blink_cnt_ax,'tight');


% get the height of red time line.
blink_timeline_height = ceil(max(avg_blink_cnt));
dist_timeline_height  = ceil(max(avg_dist));
% In each iteration: plot orig video frame, eye outline landmarks,
% average eyelid distance, average blink count and moving red line.
for frame_index = start_frame : end_frame
    % plot orig video
    frame_img = orig_video.read(frame_index);
    image(video_ax,frame_img);
    axis(video_ax,'off'); % no axis shown
    % plot eye outline landmarks
    singleface = fit(frame_index).pts_2d;
    singleface = singleface(20:31,:); % eye part landmarks
    scatter(eye_pnt_ax,singleface(:,1),singleface(:,2),'filled');
    axis(eye_pnt_ax,'equal'); % set x/y axes equal scale
    % plot moving time line.
    blink_timeline = line(blink_cnt_ax,[frame_index frame_index],...
                          [0 blink_timeline_height]);
    dist_timeline  = line(avg_dist_ax,[frame_index frame_index],...
                          [0 dist_timeline_height]);
    % set timeline width and color
    set(blink_timeline,'LineWidth',1,'Color','r');
    set(dist_timeline,'LineWidth',1,'Color','r');
    drawnow
    % get and write the output frame
    frame = getframe(gcf);
    img   = frame2im(frame);
    writeVideo(out_video,img);
    % delete the timeline after done writing the frame
    set(blink_timeline,'Visible','off');
    set(dist_timeline,'Visible','off');
end

close(out_video);



