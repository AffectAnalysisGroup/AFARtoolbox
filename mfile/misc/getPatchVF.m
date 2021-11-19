function patch_vf = getPatchVF(fit,behav,plot_h)

total_bin   = size(behav,1);
total_frame = size(fit,2);
% get vertices for each bin (one bin for one stimulus)
v_coords = [];
for bin_cnt = 1 : (total_bin)
    x_coord = behav{bin_cnt,3};
    bottom_coord = [x_coord 0];
    top_coord    = [x_coord plot_h];
    v_coords     = [v_coords;bottom_coord top_coord];
end

bottom_coord = [total_frame 0];
top_coord    = [total_frame plot_h];
v_coords     = [v_coords;bottom_coord top_coord];

% vertices of the patches
v = [];
for bin_cnt = 1 : (total_bin)
    a = v_coords(bin_cnt,1:2);
    b = v_coords(bin_cnt+1,1:2);
    c = v_coords(bin_cnt+1,3:4);
    d = v_coords(bin_cnt,3:4);
    v = [v;a;b;c;d];
end
% vertices divided into different stimulus type
v_group{1,1} = [];
v_group{1,2} = [];
v_group{1,3} = [];
v_group{1,4} = [];
for bin_cnt = 1 : (total_bin)
    a = v((bin_cnt-1)*4 + 1,:);
    b = v((bin_cnt-1)*4 + 2,:);
    c = v((bin_cnt-1)*4 + 3,:);
    d = v((bin_cnt-1)*4 + 4,:);
    if string(behav{bin_cnt,2}) == "fixation"
        v_group{1,1} = [v_group{1,1};a;b;c;d]; end
    if string(behav{bin_cnt,2}) == "neutral"
        v_group{1,2} = [v_group{1,2};a;b;c;d]; end
    if string(behav{bin_cnt,2}) == "standard"
        v_group{1,3} = [v_group{1,3};a;b;c;d]; end
    if string(behav{bin_cnt,2}) == "personal"
        v_group{1,4} = [v_group{1,4};a;b;c;d]; end
end
% faces corresponding to the vertice group
f{1,1} = 1:size(v_group{1,1},1);
f{1,2} = 1:size(v_group{1,2},1);
f{1,3} = 1:size(v_group{1,3},1);
f{1,4} = 1:size(v_group{1,4},1);
for n = 1:4
    f_n = f{1,n};
    f_n = reshape(f_n,[4 length(f_n)/4]);
    f{1,n} = f_n';
end

patch_vf = [];
patch_vf.v = v_group;
patch_vf.f = f;

end
