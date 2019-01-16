function runAUSingleVideo(fname,FETA,AU)
	% fname is the one without extension.

	norm_fn   = [fname,'_norm.mp4'];
    % norm_path = fullfile(feta_out_norm,norm_fn); => changed
    norm_path = fullfile(FETA.normOut,norm_fn);

    net = importKerasNetwork('cnn_model.json', 'WeightFile', 'weights.h5', ...
                             'OutputLayerType', 'regression');
    nAU = AU.nAU;
    au_out_dir = AU.outDir;
    video_name = norm_path; %%% update this line with your own normalized video
    v = VideoReader(video_name);

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

    v = VideoReader(video_name);
    all_outputs = [];
    while hasFrame(v)
        I = readFrame(v);
        I2 = rgb2gray(I);
        I2_conv = (double(I2)/255) - mean_video;
        sample_output = predict(net,I2_conv);
        all_outputs = [all_outputs;sample_output];
    end

    result = array2table(all_outputs, 'VariableNames', ...
                        {'AU1', 'AU2', 'AU4', 'AU6', 'AU7', 'AU10', 'AU12', ...
                         'AU14', 'AU15', 'AU17', 'AU23', 'AU24'});

    au_out_fn   = [fname,'_au_out.mat'];
    au_out_path = fullfile(au_out_dir,au_out_fn);
    save(au_out_path, 'result');

end