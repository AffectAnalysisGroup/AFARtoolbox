function runAUSingleVideo(fname,FETA_param,AU_param,varargin)

    p = inputParser;
    default_verbose = false;
    default_log_fid = -1;
    addOptional(p,'verbose',default_verbose);
    addOptional(p,'log_fid',default_log_fid);
    parse(p,varargin{:});
    verbose = p.Results.verbose;
    log_fid = p.Results.log_fid;

	% fname is the one without extension.
	norm_fn   = [fname '_norm.avi'];
    norm_path = fullfile(FETA_param.normOut,norm_fn)
    norm_path_nobs = correctPathFormat(norm_path);

    if verbose
        printWrite(sprintf('%s Processing AU detection on %s.\n',getMyTime(),...
                   norm_path_nobs),log_fid);
    end


    if AU_param.meanSub
        net = importONNXNetwork('bp4d_ep10.onnx', 'OutputLayerType', ...
                                'regression');
    else
        net = importONNXNetwork('bp4d_ep10_no_meansub.onnx', 'OutputLayerType', 'regression');
    end

    au_out_dir = AU_param.outDir;
    video_name = norm_path; 

    v   = VideoReader(video_name);
    nAU = AU_param.nAU;

    sum_fr  = zeros(FETA_param.res,FETA_param.res);
    frame_cnt = 1;
    while hasFrame(v)
        I = readFrame(v);
        if size(I,1) ~= FETA_param.res || size(I,2) ~= FETA_param.res
            error('Frame size should be 200 x 200.')
        end
        I2 = rgb2gray(I);
        if sum(I2(:)) < 10
            continue
        end
        I2_conv = (double(I2)/255);
        sum_fr  = sum_fr + I2_conv;
        frame_cnt = frame_cnt + 1;
    end

    if AU_param.meanSub
        mean_video = sum_fr/frame_cnt;
    else
        mean_video = mean(sum_fr(:))/frame_cnt;
    end

    v = VideoReader(video_name);
    all_outputs = [];
    frame_cnt = 0;
    while hasFrame(v)
        frame_cnt = frame_cnt + 1;
        I  = readFrame(v);
        I2 = rgb2gray(I);
        I2_conv = (double(I2)/255) - mean_video;
        sample_output = predict(net,I2_conv,'ExecutionEnvironment','cpu');
        sample_output = sigm(sample_output);

        if mod(frame_cnt,500) == 0 && verbose
            msg = sprintf('%s -- %d frames predicted from %s\n',getMyTime(),...
                          frame_cnt,fname);
            printWrite(msg,log_fid);
        end

        all_outputs = [all_outputs;sample_output];
    end

    result = array2table(all_outputs, 'VariableNames', ...
                        {'AU1', 'AU2', 'AU4', 'AU6', 'AU7', 'AU10', 'AU12', ...
                         'AU14', 'AU15', 'AU17', 'AU23', 'AU24'});

    au_out_fn   = [fname,'_au_out.mat'];
    au_out_path = fullfile(au_out_dir,au_out_fn);
    save(au_out_path, 'result');

    printWrite(sprintf('%s AU detection result saved as %s.\n',getMyTime(),...
               correctPathFormat(au_out_path)),log_fid,'no_action',verbose);

end

