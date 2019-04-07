function blink = getBlink(fit,blink_threhold)
% getBlink takes fit(output from zface) and a threshold of eyelid distance.
%   fit: struct, output from zface. Or maybe output from FETA for normalization
%   blink_threshold: double, a threshold for eyelid distance. If the distance 
%                    between eyelids is lower than this value, count it as a 
%                    blink. Otherwise, it's not a blink.
% Notes:
%   What about unregistered empty frames? The eyelid dist will be zero.

% parameters that may change into input args:
avg_time_window = 10;
frame_rate      = 30;

% the number of frames in the original video
frame_cnt = size(fit,2);
% get average distance between eye lids in every frame
avg_dist = zeros(frame_cnt,1);
for frame = 1 : frame_cnt
    % single_face is the 2D coordinates of all the landmarkers on face.
    single_face = fit(frame).pts_2d;
    if isempty(single_face)
        continue
    end
    avg_dist(frame,1) = getAvgDist(single_face);
end

% locate the frame when there is a blink;
blink_frame = [];
for frame = 2 : (frame_cnt-1)
    prev_dist = avg_dist(frame-1);
    next_dist = avg_dist(frame+1);
    curr_dist = avg_dist(frame);
    % if the current distance is lower than the threshold and a local minimum
    % then we consider it as a blink.
    if curr_dist < blink_threhold &  curr_dist < next_dist & curr_dist < prev_dist
        blink_frame = [blink_frame frame];
    end
end

% blink_bin is a binary vector with 1 for frame with a blink, and 0 without
blink_bin = zeros(1,frame_cnt);
blink_bin(blink_frame) = 1;

% calculate the avg blink times over a fixed interval(avg_interval)
% time interval for calculating average blink count.
avg_frame_window = frame_rate*avg_time_window;
window_cnt       = ceil(frame_cnt/avg_interval);
% padding
temp = zeros(1,window_cnt*avg_frame_window);
temp(1:length(blink_bin)) = blink_bin;
blink_bin = temp;
blink_bin = reshape(blink_bin, [window_cnt avg_frame_window]);
% row-wise sum, get the blink count over each time window.
blink_cnt_avg = sum(blink_bin,2);

% convert blink_cnt_avg into a vector with the same dimension as
% blink_bin but blink_avg_y has the avg blink cnt within the window period.
blink_avg_y   = repmat(blink_cnt_avg,[1 avg_frame_window]);
blink_avg_y   = reshape(blink_avg_y.',1,[]);
blink_avg_y   = blink_avg_y(1:frame_cnt);

% Output struct
blink = [];
blink.avg_blink_cnt = blink_avg_y;
blink.avg_dist      = avg_dist;

end

