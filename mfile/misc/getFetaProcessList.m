function process_list = getFetaProcessList(video_dir,feta_param,out_dir)

process_list = [];
video_list   = listDirItems(video_dir,'is_file',true);

old_feat_list     = listDirItems(out_dir,'file_ext','.mat');
old_fit_norm_list = listDirItems(out_dir,'file_ext','.mat');
old_norm_video_list     = listDirItems(out_dir,'file_ext','.avi');
old_norm_annotated_list = listDirItems(out_dir,'file_ext','.avi');

for n = 1 : length(video_list)
    video_path_str  = video_list(n);
    video_path_char = convertStringsToChars(video_path_str);
    [~,fn,~]   = fileparts(video_path_char);
    if ~isVideoFile(fullfile(video_dir,video_path_char));
        continue;
    end

    feat_fn       = convertCharsToStrings([fn '_feat.mat']);
    norm_video_fn = convertCharsToStrings([fn '_norm.avi']);
    fit_norm_fn   = convertCharsToStrings([fn '_fitNorm.mat']);
    norm_annotated_fn = convertCharsToStrings([fn '_norm_annoatated.avi']);

    if ~isempty(old_feat_list)
        % if there are files in the output dir, check if this video's output
        % output in the folder. If it's already in there, set save_* false;
        save_feat = ~ismember(feat_fn,old_feat_list);
    else
        % if the output dir is empty set save_* as user input.
        % for save_feat, its default is true.
        save_feat = true;
    end
    % check fit norm output
    if ~isempty(old_fit_norm_list)
        save_fit_norm = feta_param.save_fit_norm && ...
                        ~ismember(fit_norm_fn,old_fit_norm_list);
    else
        save_fit_norm = feta_param.save_fit_norm;
    end
    % check norm video output
    if ~isempty(old_norm_video_list)
        save_norm_video = feta_param.save_norm_video && ...
                          ~ismember(norm_video_fn,old_norm_video_list);
    else
        save_norm_video = feta_param.save_norm_video;
    end
    % check norm annotated output
    if ~isempty(old_norm_annotated_list)
        save_norm_annotated = feta_param.save_norm_annotated && ...
                              ~ismember(norm_annotated_fn,old_norm_annotated_list);  
    else
        save_norm_annotated = feta_param.save_norm_annotated;
    end
    % if no save, exclude the video from the process_list
    if ~save_feat && ~save_norm_video && ~save_fit_norm && ~save_norm_annotated
        continue;
    end

    video_info      = [];
    video_info.path = video_path_char;
    video_info.save_fit_norm   = save_fit_norm;
    video_info.save_norm_video = save_norm_video;
    video_info.save_norm_annotated = save_norm_annotated;
    process_list = [process_list video_info];
end

end
