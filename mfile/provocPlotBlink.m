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
debug_mode  = false;
total_bin   = 0;
seg_time_width  = 2000; % width in frame number
blink_threshold = 0.1;
show_orig_video = true;

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
avg_dist_pos = [0.1 0.05 0.8 0.08]; % average eyelid distance 
interval_pos = [0.1 0.15 0.8 0.08]; % average blink count over time
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

% get the height of red time line.
dist_timeline_height = max(avg_dist)+0.02;
intv_timeline_height = ceil(max(interval));
seg_dist_timeline_height = max(avg_dist) + 0.02;
seg_intv_timeline_height = ceil(max(interval));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get color patch
if total_bin == 0 total_bin = size(behav,1); end
h = [dist_timeline_height,intv_timeline_height];
c = {[0.5 0.5 0.5],'green','yellow','red'};
patch_axes = {avg_dist_ax,interval_ax};
for ax_index = 1:2
    patch_ax = patch_axes{1,ax_index};
    patch_vf = getPatchVF(fit,behav,h(ax_index));
    v = patch_vf.v;
    f = patch_vf.f;
    for n = 1:4
        patch(patch_ax,'Faces',f{1,n},'Vertices',v{1,n},...
              'FaceColor',c{1,n},'FaceAlpha',0.3);
    end
end

% In each iteration: plot orig video frame, eye outline landmarks,
% average eyelid distance, average blink count and moving red line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load provocation stimulus
curr_bin = 1;
first_bin = 0;
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
    avg_dist_seg   = padded_avg_dist(seg_time_x);

    seg_plot_x_ax = (frame_index - half_seg_time_width) : (frame_index + half_seg_time_width);

    plot(avg_dist_seg_ax,seg_plot_x_ax,avg_dist_seg);
    axis(avg_dist_seg_ax,'tight');
    hold on
    avg_dist_seg_line = line(avg_dist_seg_ax,[seg_timeline_x seg_timeline_x],...
    [0 seg_dist_timeline_height]);
    set(avg_dist_seg_line,'LineWidth',2,'Color','r');
    hold off

    plot(interval_seg_ax,seg_plot_x_ax,interval_seg);
    axis(interval_seg_ax,'tight');
    hold on
    interval_seg_line = line(interval_seg_ax,[seg_timeline_x seg_timeline_x],...
    [0 seg_intv_timeline_height]);
    set(interval_seg_line,'LineWidth',2,'Color','r');
    hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot the background patch on the sliding window.

    h_group  = [seg_intv_timeline_height seg_dist_timeline_height];
    ax_group = [interval_seg_ax avg_dist_seg_ax];
    seg_rating_line_group = []; 
    for group_index = 1:2
        h  = h_group(group_index);
        ax = ax_group(group_index);
        if seg_plot_x_ax(1)>0 & first_bin == 0  
            first_bin = 1;
        end
        if first_bin > 0 & first_bin < total_bin & frame_index == behav{first_bin+1,3}
            first_bin = first_bin + 1;
        end

        prev_bin  = first_bin;
        next_bin  = prev_bin+1;
        end_frame = seg_time_x(length(seg_time_x));
        end_frame = seg_plot_x_ax(length(seg_plot_x_ax));
        %if first_bin == 0
        while behav{next_bin,3} < end_frame
            if prev_bin == first_bin
                a = [seg_plot_x_ax(1) 0];
                d = [seg_plot_x_ax(1) h];
            else
                a = [behav{prev_bin,3} 0];
                d = [behav{prev_bin,3} h];
            end

            if behav{next_bin,3} >= end_frame 
                b = [end_frame 0];
                c = [end_frame h];
            else
                b = [behav{next_bin,3} 0];
                c = [behav{next_bin,3} h];
            end
            if prev_bin == 0
                face_color = [0.5 0.5 0.5];
            else
                face_color = getFaceColor(behav{prev_bin,2});
            end
            patch(ax,'Faces',[1 2 3 4],'Vertices',[a;b;c;d],'FaceColor',face_color,...
            'FaceAlpha',0.3);
            rating_frame = behav{next_bin,5};
            if ~isempty(rating_frame)
                seg_rating_line = line(ax,[rating_frame rating_frame],...
                                       [0 h]);
                set(seg_rating_line,'LineWidth',0.5,'Color','r');
                seg_rating_line_group = [seg_rating_line_group;seg_rating_line];
            end
            prev_bin = next_bin;
            next_bin = next_bin + 1;
        end
        a = b;
        d = c;
        b = [end_frame 0];
        c = [end_frame h];
        face_color = getFaceColor(behav{prev_bin,2});
        patch(ax,'Faces',[1 2 3 4],'Vertices',[a;b;c;d],'FaceColor',face_color,...
              'FaceAlpha',0.3);
    end
    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    for line_index = 1 : length(seg_rating_line_group)
        set(seg_rating_line_group(line_index),'Visible','off');
    end
end

if ~debug_mode
    close(out_video);
end


