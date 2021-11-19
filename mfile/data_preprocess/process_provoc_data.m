% input args
frame_rate = 30;

% TO BE IMPLEMENTED: function
if ismac
    target_path = '/Users/wanqiaod/workspace/data/aDBS/provoc/orig_behav/';
    output_path = '/Users/wanqiaod/workspace/data/aDBS/provoc/behav/';
    img_path    = '/Users/wanqiaod/workspace/data/aDBS/provoc/img/';
end

if ~ismac & isunix
    target_path = '/etc/VOLUME1/WanqiaoDing/aDBS/provoc/orig_behav/';
    output_path = '/etc/VOLUME1/WanqiaoDing/aDBS/provoc/behav/';
    img_path    = '/etc/VOLUME1/WanqiaoDing/aDBS/provoc/img';
end

target_ext  = [".mat"];
provoc_data_list = listExtFiles(target_path,target_ext);

for data_index = 1 : length(provoc_data_list)
    provoc_data_path = provoc_data_list(data_index);
    [~,fname,ext]    = fileparts(provoc_data_path);
    output_data_path = fullfile(output_path,[char(fname) char(ext)]);
    load(provoc_data_path);
    old_data = data;

    data = [];
    data.video_end    = old_data.video_end;
    data.video_start  = old_data.video_start;
    % combine 2 cell array into 1;
    behav = {[old_data.provoc_behav{1,1};old_data.provoc_behav{2,1}]};
    % full_behav is the feild provoc_behav from data loaded
    full_behav    = behav{1,1}; 
    behav_row_cnt = size(full_behav,1); % keep the trial number same
    behav_col_cnt = size(full_behav,2) - 2; % change column content
    % create new provoc_behav
    behav = cell([behav_row_cnt behav_col_cnt]);
    % Change img names, convert time stamps to frame index
    for row = 1:behav_row_cnt
        % change behav image file name
        orig_img_field = full_behav{row,2};
        if isempty(orig_img_field)
            new_img_field = 'fixation.jpg';
        else
            [~,img_index,~] = fileparts(orig_img_field);
            img_type = full_behav{row,4};
            if string(img_type) == "neutral" 
                new_img_field = 'neutral.jpg';
            else
                new_img_field = [img_type '_' img_index '.jpg'];
            end
        end 
        % change rating
        if isempty(full_behav{row,6}) 
            rating = -1;
        else
            rating = full_behav{row,6};
        end 
        % change onset timestamp to frame index
        onset_time   = full_behav{row,5};
        onset_frame  = floor(onset_time*frame_rate);
        if onset_frame == 0 onset_frame = 1; end % manually adjust onset frame
        rating_time  = full_behav{row,7};
        rating_frame = floor(rating_time*frame_rate);
        behav{row,1} = new_img_field;
        behav{row,2} = full_behav{row,4};
        behav{row,3} = onset_frame;
        behav{row,4} = rating;
        behav{row,5} = rating_frame;
    end
    data.provoc_behav = behav;
    % data.provoc_headers = old_data.provoc_headers;
    new_header = cell(1,5);
    new_header{1,1} = 'image file name';
    new_header{1,2} = 'stimulus type'; % fixation, standard, personal, neutral
    new_header{1,3} = 'stimulus onset frame index';
    new_header{1,4} = 'rating'; % -1 for fixation
    new_header{1,5} = 'rating frame index';
    data.provoc_header = new_header;
    save(output_data_path,'data');
end
