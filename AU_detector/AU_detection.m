    
% 1: python
% 2: GUI. Executable.
% 3: Emotion assignment.
% 4: 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Input: Normalized Video (FETA Output) obtained with the following parameters:
%%%% Resolution = 200
%%%% Interocular distance = 80
%%%%
%%%% Output: AU probabilities of the following 12 AUs:
%%%% AU1, AU2, AU4, AU6, AU7, AU10, AU12, AU14, AU15, AU17, AU23, AU24 
%%%%
%%%% Requirements: importKerasNetwork function requires MATLAB 2018a or
%%%% later version and Deep Learning Toolbox.
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

net = importKerasNetwork('cnn_model.json', 'WeightFile', 'weights.h5', 'OutputLayerType', 'regression');
nAU = 12;
video_name = 'sample_video_norm.mp4'; %%% update this line with your own normalized video
v = VideoReader(video_name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Compute mean of video %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum_fr = zeros(200,200);
counter = 1;
while hasFrame(v)
        I = readFrame(v);
        if size(I,1) ~= 200 || size(I,2) ~= 200
            error('Frame size should be 200 x 200.')
        end
        I2 = rgb2gray(I);
        if sum(I2(:)) < 10
            continue
        end
        I2_conv = (double(I2)/255);
        sum_fr = sum_fr + I2_conv;
        counter = counter + 1;
end
mean_video = mean(sum_fr(:))/counter;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Obtain AU probabilities for 12 AUS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = VideoReader(video_name);
all_outputs = [];
while hasFrame(v)
        I = readFrame(v);
        I2 = rgb2gray(I);
        I2_conv = (double(I2)/255) - mean_video;
        sample_output = predict(net,I2_conv);
        all_outputs = [all_outputs;sample_output];

end

result = array2table(all_outputs, 'VariableNames', {'AU1', 'AU2', 'AU4', 'AU6', 'AU7', 'AU10', 'AU12', 'AU14', 'AU15', 'AU17', 'AU23', 'AU24'});
save_name = strsplit(video_name, '.');
save([save_name{1} '_result.mat'], 'result');
