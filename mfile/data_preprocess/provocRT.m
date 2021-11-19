behav_data = '/Users/wanqiaod/workspace/data/aDBS/provoc/behav/aDBS002_provoc_1017.mat';
load(behav_data)
behav = data.provoc_behav;
total_bin  = size(behav,1);
frame_rate = 30;
rt_time    = [];

for bin = 1 : total_bin
    if isempty(behav{bin,5})
        continue
    end
    reaction_frame = behav{bin,5} - behav{bin,3};
    rt_time = [rt_time reaction_frame/frame_rate];
end
neutral_rt  = [];
standard_rt = [];
personal_rt = [];
for behav_bin = 2 : 2 : total_bin
    bin = behav_bin/2;
    if string(behav{behav_bin,2}) == "neutral"
        neutral_rt = [neutral_rt rt_time(bin)];
    else
        neutral_rt = [neutral_rt 0];
    end
    if string(behav{behav_bin,2}) == "standard"
        standard_rt = [standard_rt rt_time(bin)];
    else
        standard_rt = [standard_rt 0];
    end
    if string(behav{behav_bin,2}) == "personal"
        personal_rt = [personal_rt rt_time(bin)];
    else
        personal_rt = [personal_rt 0];
    end
end
figure
bar(neutral_rt,'green');
hold on
bar(standard_rt,'yellow');
hold on
bar(personal_rt,'red');
legend('neutral stimulus','standard provocation stimulus','personal provocation stimulus')
hold off

