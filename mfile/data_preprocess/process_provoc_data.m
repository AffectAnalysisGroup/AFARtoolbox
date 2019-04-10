% provoc_data_path = '/Users/wanqiaod/workspace/data/aDBS002_1017_provoc.mat';
%[fpath,fname,ext] = fileparts(provoc_data_path);
target_path = '/etc/VOLUME1/WanqiaoDing/aDBS/provoc_behav/aDBS002_provoc_1017.mat';
target_ext  = [".mat"];
provoc_data_list = listExtFiles(target_path,target_ext);
for data_index = 1 : length(provoc_data_list)
    provoc_data_path = provoc_data_list(data_index);
    load(provoc_data_path);
    old_data = data;

    data = [];
    data.video_end      = old_data.video_end;
    data.video_start    = old_data.video_start;
    data.provoc_behav   = old_data.provoc_behav;
    data.provoc_headers = old_data.provoc_headers;

    % Overwrite the old data
    save(provoc_data_path,'data');
end
