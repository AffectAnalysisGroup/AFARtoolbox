function fet_process_single(fn,strFr,ms3D,trackingDir,fit_dir,out_dir,...
                            normFunc,res,IOD,lmSS,descFunc,patchSize,...
                            saveNormVideo,saveNormLandmarks,saveVideoLandmarks)
% fet_process_single saves feta outputs with given original video and zface output.
%   Input arguments:
%   - fn: char array, original video path.
%   - strFr: string, string of frames to process.
%   - ms3D: matrix, ms3D loaded.
%   - trackingDir: char array, original video directory. TODO: need to remove
%   - fit_dir: char array, zface fit mat file directory.
%   - out_dir: char array, output directory.
%   - normFunc: char array, norm function.
%   - res: double, resolution of output video.
%   - IOD: double, IOD.
%   - lmSS: char array, frame range. TODO: might need update
%   - descFunc: char array, desc function.
%   - patchSize: double, patch size.
%   - saveNormVideo: bool, if save normalized videos.
%   - saveNormLandmarks: bool, if save normalized landmarks.
%   - saveVideoLandmarks: bool, if save annotated videos.

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

    if ~isfile(video_path)
        fprintf(['skipped! can''t find video file: ' video_path '\n\n']);   
    else    
        fit_file = [fnName '_fit.mat']
        fit_path = fullfile(fit_dir,fit_file);
        if ~isfile(fit_path)
            fprintf('fit_path: %s\n',fit_path);
            fprintf('skipped! can''t find tracking file\n\n');
        else
            fprintf('- loading tracking: ');
            fitOld = load(fit_path);
            fprintf('done!\n');
            fitOld = fitOld.fit;
            fitOldRange = cell2mat({fitOld(:).frame}');

            fprintf('- opening video: ');
            vo = VideoReader(fn);
            fprintf('done!\n');

            fprintf('- reading last frame: ');
            fprintf('skipped (%d frames)\n',vo.NumberOfFrames);
            if isempty(strFr)
                strFr = 'all frames';
                fr = 1:vo.NumberOfFrames;
            else
                fr = eval(strFr);
                strFr = ['frames ' strFr];        
            end                        

            if saveNormVideo
                out_video_fn = [fnName '_norm.avi'];
                out_video_path = fullfile(out_norm_dir,out_video_fn);
                % TODO: add ext option
                vwNorm = VideoWriter(out_video_path);
                vwNorm.FrameRate = vo.FrameRate;
                open(vwNorm);
            end

            if saveVideoLandmarks
                out_annotated_fn = [fnName '_norm_annotated.avi'];
                out_annotated_path = fullfile(out_annotated_dir,out_annotated_fn); 
                vwNormLand = VideoWriter(out_annotated_path);
                vwNormLand.FrameRate = vo.FrameRate;
                open(vwNormLand);
            end

            fprintf('processing %s: ',strFr);
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
            for j = 1:nFrames
                l = true;
                try
                    I = read(vo,fr(j));
                catch
                    l = false;
                end

                pts = [];
                ndx = find(fitOldRange == fr(j));
                if (~isempty(ndx)) && (~isempty(fitOld(ndx).pts_2d)) && (l)
                    pts = fitOld(ndx).pts_2d;
                end

                if ~isempty(pts)
                    [ I_AS, pts_AS ] = normFunc(I, pts, ms3D, res, IOD, lmSS);
                    [ phi, descExt ] = descFunc(I_AS, pts_AS, patchSize, descExt);
                    if ~isempty(phi)
                        eval(['phi = phi(' lmSS ',:);']);
                        phi = phi';
                        phi = phi(:)';
                    end                    
                else
                    pts_AS = [];
                    I_AS = zeros(res,res,3,'uint8');
                    phi = [];
                end

                if (~isempty(ndx)) && (l)
                    fitNorm(j).frame = fitOld(ndx).frame;
                    fitNorm(j).isTracked = fitOld(ndx).isTracked;
                    fitNorm(j).pts_2d = pts_AS;
                    feat(j).frame = fitOld(ndx).frame;
                    feat(j).isTracked = fitOld(ndx).isTracked;
                    feat(j).feature = phi;
                    if saveNormVideo
                        writeVideo(vwNorm,I_AS);
                    end

                    if saveVideoLandmarks
                        I_AS = plotShapeRGB(I_AS,pts_AS,[0,255,0]); 
                        writeVideo(vwNormLand,I_AS);
                    end
                end
            end
            fprintf('done!\n');
            fprintf('saving tracking result: ');
            if saveNormVideo
                close(vwNorm);
            end    
            if saveVideoLandmarks
                close(vwNormLand);
            end      
            if saveNormLandmarks
                out_fit_norm_fn = [fnName '_fitNorm.mat'];
                out_fit_norm_path = fullfile(out_fitNorm_dir,out_fit_norm_fn);
                save(out_fit_norm_path,'fitNorm');
            end

            out_feat_fn = [fnName '_feat.mat'];
            out_feat_path = fullfile(out_feat_dir,out_feat_fn);
            save(out_feat_path,'feat');
            fprintf('done!\n\n');    
        end
    end
end

