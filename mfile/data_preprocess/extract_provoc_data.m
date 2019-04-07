provoc_data_path = '/Users/wanqiaod/workspace/data/aDBS002_1017_provoc.mat';
%[fpath,fname,ext] = fileparts(provoc_data_path);

load(provoc_data_path);
old_data = data;

data = [];
data.video_end      = old_data.video_end;
data.video_start    = old_data.video_start;
data.provoc_behav   = old_data.provoc_behav;
data.provoc_headers = old_data.provoc_headers;

% Overwrite the old data
% delete provoc_data_path;
save(provoc_data_path,'data');

