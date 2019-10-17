function fet_process_single(fn,strFr,ms3D,fit_dir,out_dir,...
                            normFunc,res,IOD,lmSS,descFunc,patchSize,...
                            saveNormVideo,saveFitNorm,saveNormAnnotated)

% fet_process_single saves feta outputs with given original video and zface output.
%   Input arguments:
%   - fn: char array, original video path.
%   - strFr: string, string of frames to process.
%   - ms3D: matrix, ms3D loaded.
%   - fit_dir: char array, zface fit mat file directory.
%   - out_dir: char array, output directory.
%   - normFunc: char array, norm function.
%   - res: double, resolution of output video.
%   - IOD: double, IOD.
%   - lmSS: char array, frame range. TODO: might need update
%   - descFunc: char array, desc function.
%   - patchSize: double, patch size.
%   - saveNormVideo: bool, if save normalized videos.
%   - saveFitNorm: bool, if save normalized landmarks.
%   - saveNormAnnotated: bool, if save annotated videos.

    descExt       = [];
    [~,fnName,~]  = fileparts(fn);    
    video_path    = fn;

    out_norm_dir      = fullfile(out_dir,'feta_norm_videos');
    % normalized video directory
    out_annotated_dir = fullfile(out_dir,'feta_norm_annotated_videos');
    % annotated video directory
    out_fitNorm_dir   = fullfile(out_dir,'feta_fit_norm');
    % normalized fit directory
    out_feat_dir      = fullfile(out_dir,'feta_feat');
    % feature mat file directory

    if ~isfile(video_path) % if the given original video file is not valid
        fprintf(['skipped! can''t find video file: ' video_path '\n\n']);   
        return
    end

    fit_file = [fnName '_fit.mat']
    fit_path = fullfile(fit_dir,fit_file);
    if ~isfile(fit_path)
        fprintf('fit_path: %s\n',fit_path);
        fprintf('skipped! can''t find tracking file\n\n');
        return
    end

    zfaceFit = load(fit_path);
    zfaceFit = zfaceFit.fit;
    zfaceFitRange = cell2mat({zfaceFit(:).frame}');
    origVideoObj = VideoReader(fn); % original video object

    if isempty(strFr) % get frames range
        strFr = 'all frames';
        fr = 1:origVideoObj.NumberOfFrames;
    else
        fr = eval(strFr);
        strFr = ['frames ' strFr];        
    end                        

    if saveNormVideo % if save normalized video
        out_video_fn = [fnName '_norm.avi'];
        out_video_path = fullfile(out_norm_dir,out_video_fn);
        % TODO: add ext option
        vwNorm = VideoWriter(out_video_path);
        vwNorm.FrameRate = origVideoObj.FrameRate;
        open(vwNorm);
    end

    if saveNormAnnotated % if save normalized annotated video
        out_annotated_fn   = [fnName '_norm_annotated.avi'];
        out_annotated_path = fullfile(out_annotated_dir,out_annotated_fn); 
        vwNormAnnotated    = VideoWriter(out_annotated_path);
        vwNormAnnotated.FrameRate = origVideoObj.FrameRate;
        open(vwNormAnnotated);
    end

    nFrames = length(fr);
    pts = [];
    pars.normFunc = normFunc;
    pars.normIOD = IOD;
    pars.normRes = res;
    pars.landmarks = lmSS;
    pars.descFunc = descFunc;
    pars.descPatchSize = patchSize;
    feat = struct([]);
    feat(1).pars = pars;
    fitNorm = struct([]);
    fitNorm(1).pars = pars;

    for frameIdx = 1:nFrames
        is_valid_frame = true;
        try
            I = read(origVideoObj,fr(frameIdx));
        catch
            is_valid_frame = false;
        end

        pts = [];
        % find the corresponding frame in zface fit from the frame in the orig video
        zfaceFitIdx = find(zfaceFitRange == fr(frameIdx));
        if (~isempty(zfaceFitIdx)) && (~isempty(zfaceFit(zfaceFitIdx).pts_2d)) && (is_valid_frame)
        % if the current frame is within the zfaceFit range of interest, and 
        % the frame is not empty(there is a face succefully tracked in the 
        % frame), and the frame is valid in the orig video.
            pts = zfaceFit(zfaceFitIdx).pts_2d;
        end

        if ~isempty(pts) % if can find valid pts_2d in zface fit for the current frame
            % get normalized I and pts.
            [ I_AS, pts_AS ] = normFunc(I, pts, ms3D, res, IOD, lmSS);
            [ phi, descExt ] = descFunc(I_AS, pts_AS, patchSize, descExt);
            if ~isempty(phi)
                eval(['phi = phi(' lmSS ',:);']);
                phi = phi';
                phi = phi(:)';
            end                    
        else % if there is no valid pts_2d, write the frame as an empty image.
            pts_AS = [];
            I_AS = zeros(res,res,3,'uint8');
            phi = [];
        end

        if (~isempty(zfaceFitIdx)) && (is_valid_frame) 
            % if the current frame is within the zfaceFit range of interest,  
            % and the frame is valid in the orig video
            
            % get normalized fit for the current frame.
            fitNorm(frameIdx).frame     = zfaceFit(zfaceFitIdx).frame;
            fitNorm(frameIdx).pts_2d    = pts_AS; % update pts_2d field
            fitNorm(frameIdx).isTracked = zfaceFit(zfaceFitIdx).isTracked;
            % get feature for the current frame.
            feat(frameIdx).frame     = zfaceFit(zfaceFitIdx).frame;
            feat(frameIdx).feature   = phi;
            feat(frameIdx).isTracked = zfaceFit(zfaceFitIdx).isTracked;
            if saveNormVideo
                writeVideo(vwNorm,I_AS);
            end

            if saveNormAnnotated
                I_AS = plotShapeRGB(I_AS,pts_AS,[0,255,0]); 
                writeVideo(vwNormAnnotated,I_AS);
            end
        end
    end

    if saveNormVideo
        close(vwNorm);
    end    

    if saveNormAnnotated
        close(vwNormAnnotated);
    end      

    if saveFitNorm
        out_fit_norm_fn = [fnName '_fitNorm.mat'];
        out_fit_norm_path = fullfile(out_fitNorm_dir,out_fit_norm_fn);
        save(out_fit_norm_path,'fitNorm');
    end

    out_feat_fn = [fnName '_feat.mat'];
    out_feat_path = fullfile(out_feat_dir,out_feat_fn);
    save(out_feat_path,'feat');

end

