clc;

STR_MODELS = {'dense','49 markers','66 markers','77 markers'};

fprintf('Feature Extraction Toolbox - batch version\n');
fprintf('(c) Laszlo A. Jeni, www.laszlojeni.com\n');
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');

load('ms3D_v1024_low_forehead');

% IOD normalization
e1 = mean(ms3D(37:42,:));
e2 = mean(ms3D(43:48,:));
d = dist3D(e1,e2);
ms3D = ms3D * (IOD/d) + res/2;

descExt = [];

fprintf('input list:\t%s\n',inFile);
fprintf('tracking dir:\t%s\n',trackingDir);
fprintf('output dir:\t%s\n',outDir);
fprintf('norm. function:\t%s\n',normFunc);
fprintf('desc. function:\t%s\n',descFunc);
fprintf('\n');

fprintf('reading list: ');
fid = fopen(inFile);
C = textscan(fid,'%q%q');
fprintf('found %d item(s) to process\n\n',length(C{1,1}));
fclose(fid);

nItems = length(C{1,1});
hPB = progressbar('Files','Frames');

for i = 1:nItems
    fn = C{1,1}{i,1};
    [fnPath,fnName,fnExt] = fileparts(fn);
    fprintf('opening %s and processing: ',fn);    
    
    fitOld = load([trackingDir '\' fnName '_fit.mat']);
    fitOld = fitOld.fit;
    
    vo = VideoReader(fn);
    fprintf('done! (%d frames)\n',vo.NumberOfFrames);  
    
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
    
    if length(C{1,2}) >= i
        strFr = C{1,2}{i,1};    
    else
        strFr = '';
    end
    if isempty(strFr)
        strFr = 'all frames';
        fr = 1:vo.NumberOfFrames;
    else
        fr = eval(strFr);
        strFr = ['frames ' strFr];        
    end
    
    fprintf('processing %s: ',strFr);
    nFrames = length(fr);
    pts = [];
    pars.normFunc = normFunc;
    pars.normIOD = IOD;
    pars.normRes = res;
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
        if (length(fitOld) >= fr(j)) && (l)
            pts = fitOld(fr(j)).pts_2d;
        end
        
        if ~isempty(pts)
            eval(['[ I_AS, pts_AS ] = fet_norm_' normFunc '( I, pts, ms3D, res );']);
            eval(['[ phi, descExt ] = fet_desc_' descFunc '( I, pts, patchSize, descExt );']);
        else
            pts_AS = [];
            I_AS = zeros(res,res,3,'uint8');
            phi = [];
        end
        
        if (length(fitOld) >= fr(j)) && (l)
            fitNorm(j).frame = fitOld(fr(j)).frame;
            fitNorm(j).isTracked = fitOld(fr(j)).isTracked;
            fitNorm(j).pts_2d = pts_AS;

            feat(j).frame = fitOld(fr(j)).frame;
            feat(j).isTracked = fitOld(fr(j)).isTracked;
            feat(j).feature = phi;

            if saveNormVideo
                writeVideo(vwNorm,I_AS);
            end

            if saveVideoLandmarks
                I_AS = plotShapeRGB(I_AS,pts_AS,[0,255,0]); 
                writeVideo(vwNormLand,I_AS);
            end
        end
        
        progressbar((i-1)/nItems,j/nFrames);
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
    
end

progressbar(1,1);

msgbox('Tracking finished without errors!','zface');
