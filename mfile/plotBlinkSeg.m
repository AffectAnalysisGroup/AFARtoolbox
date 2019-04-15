if ismac
    video_path      = '/Users/wanqiaod/workspace/data/test_video/F005_01.avi';
    zface_fit_path  = '/Users/wanqiaod/workspace/data/out/zface_out/zface_fit/1080_provoc_1017_fit.mat';
    out_video_path  = '/Users/wanqiaod/workspace/data/visualization/aDBS002_1017_provoc_blink_out.avi';
    behav_data      = '/Users/wanqiaod/workspace/data/aDBS/provoc/behav/aDBS002_provoc_1017.mat';
    img_path        = '/users/wanqiaod/workspace/data/aDBS/provoc/img/';
end

if isunix & ~ismac
    video_path      = '/etc/VOLUME1/WanqiaoDing/aDBS/cropped_video/provoc_1017_1080p.avi';
    zface_fit_path  = '/etc/VOLUME1/WanqiaoDing/aDBS/out_cropped/zface_out/zface_fit/provoc_1017_1080p_fit.mat';
    out_video_path  = '/etc/VOLUME1/WanqiaoDing/aDBS/visualization/aDBS002_provoc_1017.avi';
    behav_data      = '/etc/VOLUME1/WanqiaoDing/aDBS/provoc/behav/aDBS002_provoc_1017.mat';
    img_path        = '/etc/VOLUME1/WanqiaoDing/aDBS/provoc/img/';
end

% load behavioral data
load(behav_data)
behav = data.provoc_behav;

% Input args
start_frame = 1;
end_frame   = 0;
debug_mode  = true;
total_bin   = 0;
seg_time_width  = 2000; % width in frame number
blink_threshold = 0.1;
show_orig_video = false;

load(zface_fit_path);
total_frame = size(fit,2);
if end_frame == 0
    end_frame = total_frame;
end

% time course of the plots (x axis)
time_x     = start_frame:end_frame;
% get blink information
blink = getBlink(fit,blink_threshold);
% avg distance between eye lids.
avg_dist = blink.avg_dist(start_frame:end_frame);       
% inter-blink interval in secs.
interval = blink.blink_interval(start_frame:end_frame);
% Padding: 0, 0, 0, ..., 0, [original avg_dist/blink_interval], 0, 0, 0
half_seg_time_width = round(seg_time_width/2);
orig_indices = half_seg_time_width : (half_seg_time_width+size(interval,1)-1);
padded_avg_dist = zeros((size(avg_dist,1)+seg_time_width),1);
padded_avg_dist(orig_indices) = avg_dist;
% padding for the sliding window x-axis
padded_interval = zeros((size(interval,1)+seg_time_width),1);
padded_interval(orig_indices) = interval;

% dimensions of the whole window
window_x0 = 100;
window_y0 = 100;
window_w  = 1000;
window_h  = 700;

% open the original video and output video
orig_video = VideoReader(video_path);
if ~debug_mode
    out_video  = VideoWriter(out_video_path);
    open(out_video);
end

figure
% open the plot window and set background white
set(gcf,'position',[window_x0,window_y0,window_w,window_h])
set(gcf,'color','white');
set(gca,'Clipping','off');

video_pos    = [0.05 0.55 0.25 0.4]; % original video
eye_pnt_pos  = [0.4 0.55 0.2 0.2]; % eye outline landmarks
img_pos      = [0.7 0.55 0.25 0.25]; % provoc image
avg_dist_pos = [0.1 0.15 0.8 0.08]; % average eyelid distance 
interval_pos = [0.1 0.05 0.8 0.08]; % average blink count over time
avg_dist_seg_pos = [0.1 0.25 0.8 0.08]; % one segment of avg_dist
interval_seg_pos = [0.1 0.35 0.8 0.08]; % one segment of inter-blink interval

% get the axes for each plot
video_ax    = subplot('Position',video_pos);
eye_pnt_ax  = subplot('Position',eye_pnt_pos);
img_ax      = subplot('Position',img_pos);
avg_dist_ax = subplot('Position',avg_dist_pos);
interval_ax = subplot('Position',interval_pos);
avg_dist_seg_ax = subplot('Position',avg_dist_seg_pos);
interval_seg_ax = subplot('Position',interval_seg_pos);

% plot average eyelid distance
plot(avg_dist_ax,time_x,avg_dist);
axis(avg_dist_ax,'tight');
% plot blink interval
plot(interval_ax,time_x,interval);
axis(interval_ax,'tight');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get color patch
if total_bin == 0 total_bin = size(behav,1); end
% axis_width = avg_dist_pos(3);
% patch_pos_x        = zeros(total_bin,4);
% dist_patch_pos_y   = zeros(total_bin,4);
% blink_patch_pos_y  = zeros(total_bin,4);
% dist_patch_bottom  = avg_dist_pos(2);
% dist_patch_top     = dist_patch_bottom + avg_dist_pos(4);
% blink_patch_bottom = interval_pos(2);
% blink_patch_top    = blink_patch_bottom + interval_pos(4);
% 
% for bin_index = 1 : total_bin
%     axis_left   = avg_dist_pos(1) + (behav{bin_index,5}-1)/total_frame;
%     patch_width = ((behav{bin_index+1,5}-1)/total_frame) * axis_width;
%     axis_right  = avg_dist_pos(1) + patch_width;
%     % x change, y fixed, width change, height fixed
%     patch_x = [axis_left axis_right axis_left axis_right];
%     dist_patch_y = [dist_patch_bottom dist_patch_bottom dist_patch_top ...
%                     dist_patch_top];
%     blink_patch_y = [blink_patch_bottom blink_patch_bottom blink_patch_top ...
%                      blink_patch_top];
%     patch_pos_x(bin_index,:) = patch_x;
%     dist_patch_pos_y(bin_index,:) = dist_patch_y;
%     blink_patch_pos_y(bin_index,:) = blink_patch_y;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the height of red time line.
dist_timeline_height = max(avg_dist)+0.02;
intv_timeline_height = ceil(max(interval));
seg_dist_timeline_height = max(avg_dist) + 0.02;
seg_intv_timeline_height = ceil(max(interval));

% In each iteration: plot orig video frame, eye outline landmarks,
% average eyelid distance, average blink count and moving red line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load provocation stimulus
curr_bin = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for frame_index = start_frame : end_frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Move bin
    if curr_bin < total_bin & frame_index == behav{curr_bin+1,3}
        curr_bin = curr_bin + 1;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot orig video
    if show_orig_video
        frame_img = orig_video.read(frame_index);
        image(video_ax,frame_img);
        axis(video_ax,'off'); % no axis shown
    end

    % plot eye outline landmarks
    singleface = fit(frame_index).pts_2d;
    singleface = singleface(20:31,:); % eye part landmarks
    scatter(eye_pnt_ax,singleface(:,1),singleface(:,2),'filled');
    axis(eye_pnt_ax,'equal'); % set x/y axes equal scale

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Show provocation image.
    fname = [img_path behav{curr_bin,1}];
    img   = imread(fname);
    image(img_ax,img);
    axis(img_ax,'off');
    if behav{curr_bin,4} ~= -1 
        rate_txt = ['  rate: ' num2str(behav{curr_bin,4})]; 
    else
        rate_txt = '';
    end
    title_str = [behav{curr_bin,2} rate_txt];
    title(img_ax,title_str);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot the sliding windows of avg distance and inter-blink interval
    seg_time_x     = frame_index : frame_index + seg_time_width;
    seg_timeline_x = frame_index;
    interval_seg   = padded_interval(seg_time_x);
    % seg_timeline_x = round(mean([frame_index (frame_index+seg_time_width)]));
    % seg_timeline_x = frame_index + half_seg_time_width;
    avg_dist_seg   = padded_avg_dist(seg_time_x);

    seg_plot_x_ax = (frame_index - half_seg_time_width) : (frame_index + half_seg_time_width);

    plot(avg_dist_seg_ax,seg_plot_x_ax,avg_dist_seg);
    axis(avg_dist_seg_ax,'tight');
    hold on
    avg_dist_seg_line = line(avg_dist_seg_ax,[seg_timeline_x seg_timeline_x],...
    [0 seg_dist_timeline_height]);
    set(avg_dist_seg_line,'LineWidth',1,'Color','r');
    hold off

    plot(interval_seg_ax,seg_plot_x_ax,interval_seg);
    axis(interval_seg_ax,'tight');
    hold on
    interval_seg_line = line(interval_seg_ax,[seg_timeline_x seg_timeline_x],...
    [0 seg_intv_timeline_height]);
    set(interval_seg_line,'LineWidth',1,'Color','r');
    hold off
    % drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot moving time line.
    dist_timeline = line(avg_dist_ax,[frame_index frame_index],...
                          [0 dist_timeline_height]);
    intv_timeline = line(interval_ax,[frame_index frame_index],...
                          [0 intv_timeline_height]);
    % set timeline width and color
    set(dist_timeline,'LineWidth',1,'Color','r');
    set(intv_timeline,'LineWidth',1,'Color','r');
    drawnow

    % get and write the output frame
    if ~debug_mode
        frame = getframe(gcf);
        img   = frame2im(frame); 
        writeVideo(out_video,img);
    end
    % delete the timeline after done writing the frame
    rating_frame = behav{curr_bin,5};
    if isempty(rating_frame) | (rating_frame ~= frame_index)
        set(dist_timeline,'Visible','off');
        set(intv_timeline,'Visible','off');
    end
end

if ~debug_mode
    close(out_video);
end


