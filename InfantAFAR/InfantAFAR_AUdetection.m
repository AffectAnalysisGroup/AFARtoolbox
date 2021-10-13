
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Input: Normalized Video (FETA Output) obtained with the following parameters:
%%%% Resolution = 224
%%%% Interocular distance = 80
%%%%
%%%% Output: AU probabilities of the following 12 AUs:
%%%% AU4, AU6, AU12, AU20
%%%%
%%%% Requirements: importONNXNetwork function requires Deep Learning Toolbox.
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aus = [4, 6, 12, 20];
all_au_outputs = [];
for i = 1:numel(aus)
    fprintf('Running AU%d\n',aus(i))
    net = importONNXNetwork(['onnx_files/infantAFAR_AU' num2str(aus(i)) '.onnx'], ...
                             'OutputLayerType', 'regression');
    video_name = 'sample_video.mp4'; %%% update this line with your own normalized video
    v = VideoReader(video_name);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% Obtain AU probabilities %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mean_imagenet = [0.485, 0.456, 0.406];
    std_imagenet = [0.229, 0.224, 0.225];
    v = VideoReader(video_name);
    all_outputs = [];
    while hasFrame(v)
        I = readFrame(v);
        % I2= (double(I)/255 - mean_imagenet) ./ std_imagenet;
        I2 = zeros(size(I));
        I2(:,:,1) = (double(I(:,:,1))/255 - mean_imagenet(1) )./ std_imagenet(1);
        I2(:,:,2) = (double(I(:,:,2))/255 - mean_imagenet(2) )./ std_imagenet(2);
        I2(:,:,3) = (double(I(:,:,3))/255 - mean_imagenet(3) )./ std_imagenet(3);
        sample_output = predict(net,I2, 'ExecutionEnvironment','cpu');
             
        sample_output = sigm(sample_output);
        all_outputs = [all_outputs;sample_output];

    end

    all_au_outputs = [all_au_outputs all_outputs];
end

result = array2table(all_au_outputs, 'VariableNames', {'AU4', 'AU6', 'AU12', 'AU20'});
save_name = strsplit(video_name, '.');
save([save_name{1} '_results.mat'], 'result');



function y = sigm(x)
    y = 1.0 ./ (1 + exp(-x));
end
