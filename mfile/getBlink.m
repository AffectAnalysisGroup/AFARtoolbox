function blink = getBlink(fit,blink_threshold)
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
normalizeDist   = true;

% the number of frames in the original video
total_frame = size(fit,2);
% get average distance between eye lids in every frame
avg_dist = zeros(total_frame,1);
for frame = 1 : total_frame
    % single_face is the 2D coordinates of all the landmarkers on face.
    single_face = fit(frame).pts_2d;
    if isempty(single_face)
        continue
    end
    avg_dist(frame,1) = getAvgDist(single_face);
end

% locate the frame when there is a blink;
blink_frame = [];

% Normalize eyelid distance.
avg_IOD = getAvgIOD(fit);
if normalizeDist == false
    avg_IOD = 1;
end
avg_dist = avg_dist/avg_IOD;

for frame = 2 : (total_frame-1)
    prev_dist = avg_dist(frame-1);
    next_dist = avg_dist(frame+1);
    curr_dist = avg_dist(frame);
    % if the current distance is lower than the threshold and a local minimum
    % then we consider it as a blink.
    is_local_min = (curr_dist < next_dist & curr_dist < prev_dist);
    nonzero_below_threshold = (curr_dist < blink_threshold & curr_dist ~= 0);
    if is_local_min & nonzero_below_threshold  
        blink_frame = [blink_frame,frame];
    end
end

% get the intervals between blinks
shifted_blink_frame = [0 blink_frame(1:(length(blink_frame)-1))];
blink_interval = blink_frame - shifted_blink_frame;

% get the full_blink_interval, which has the same length of total frames
blink_cnt = 0;
full_blink_interval = zeros(total_frame,1);
for frame = 1 : total_frame
    % get time interval over the entire time course
    full_blink_interval(frame) = blink_interval(blink_cnt+1);

    % if reach the next blink frame, increase blink_cnt
    if blink_cnt ~= (length(blink_frame)-1) & frame == blink_frame(blink_cnt+1) 
        blink_cnt = 1 + blink_cnt; 
    end
end
full_blink_interval = full_blink_interval/frame_rate;

% Output struct
blink = [];
% blink.avg_blink_cnt  = blink_avg_y;
blink.avg_dist       = avg_dist;
blink.blink_frame    = blink_frame';
blink.blink_interval = full_blink_interval;
end

