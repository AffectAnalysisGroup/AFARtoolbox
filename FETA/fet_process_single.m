function fet_process_single(fn,strFr,ms3D,trackingDir,fit_dir,outDir,normFunc,res,IOD,lmSS,descFunc,patchSize,saveNormVideo,saveNormLandmarks,saveVideoLandmarks)

    descExt = [];
    [~,fnName,~] = fileparts(fn);
    fprintf('processing "%s"\n',fn);    
    
    %if exist(fn,'file') 
    %    if exist([trackingDir '\' fnName '_fit.mat'],'file')         
    if isfile(fn)
        fit_file = [fnName '_fit.mat'];
        if isfile(fit_file)

            fprintf('- loading tracking: ');
            fitOld = load([trackingDir '\' fnName '_fit.mat']);
            fprintf('done!\n');
            fitOld = fitOld.fit;
            fitOldRange = cell2mat({fitOld(:).frame}');

            fprintf('- opening video: ');
            vo = VideoReader(fn);
            fprintf('done!\n');
            
            fprintf('- reading last frame: ');
            fprintf('skipped (%d frames)\n',vo.NumberOfFrames); 
%             read(vo,inf);
%             fprintf('done! (%d frames)\n',vo.NumberOfFrames); 
            
            if isempty(strFr)
                strFr = 'all frames';
                fr = 1:vo.NumberOfFrames;
            else
                fr = eval(strFr);
                strFr = ['frames ' strFr];        
            end                        

            if saveNormVideo
                vwNorm = VideoWriter([outDir '\' sprintf('(%.4d)_%s_norm.mp4',i,fnName)],'MPEG-4');
                vwNorm.FrameRate = vo.FrameRate;
                open(vwNorm);
            end

            if saveVideoLandmarks
                vwNormLand = VideoWriter([outDir '\' sprintf('(%.4d)_%s_norm_annotated.mp4',i,fnName)],'MPEG-4');
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
        %         fr(j)
                l = true;
                try
                    I = read(vo,fr(j));
                catch
                    l = false;
                end

                pts = [];
                %if (length(fitOld) >= fr(j)) && (l)
                ndx = find(fitOldRange == fr(j));
                if (~isempty(ndx)) && (~isempty(fitOld(ndx).pts_2d)) && (l)
                    pts = fitOld(ndx).pts_2d;
                end

                if ~isempty(pts)
                    eval(['[ I_AS, pts_AS ] = fet_norm_' normFunc '( I, pts, ms3D, res, IOD, lmSS );']);
                    eval(['[ phi, descExt ] = fet_desc_' descFunc '( I_AS, pts_AS, patchSize, descExt );']);
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
                    %fitNorm(j).frame = fitOld(fr(j)).frame;
                    fitNorm(j).frame = fitOld(ndx).frame;
                    %fitNorm(j).isTracked = fitOld(fr(j)).isTracked;
                    fitNorm(j).isTracked = fitOld(ndx).isTracked;
                    fitNorm(j).pts_2d = pts_AS;

                    %feat(j).frame = fitOld(fr(j)).frame;
                    feat(j).frame = fitOld(ndx).frame;
                    %feat(j).isTracked = fitOld(fr(j)).isTracked;
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

        %         dataPB{2*actN-1} = (i-1)/nItems;
        %         dataPB{2*actN} = j/nFrames;
        %         progressbar(dataPB{:});
        %         progressbar((i-1)/nItems,j/nFrames);
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
                save([outDir '\' sprintf('(%.4d)_%s_fitNorm.mat',i,fnName)],'fitNorm');
            end

            save([outDir '\' sprintf('(%.4d)_%s_feat.mat',i,fnName)],'feat');
            fprintf('done!\n\n');    
        else
            fprintf('skipped! can''t find tracking file\n\n');    
        end
    else
        fprintf('skipped! can''t find video file\n\n');    
    end
    
end

% dataPB{2*actN-1} = 1;
% dataPB{2*actN} = 1;
% progressbar(dataPB{:});

% progressbar(1,1);

% msgbox('Tracking finished without errors!','zface');

% end
