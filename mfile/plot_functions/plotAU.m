function plotAU(auIndexVect,origVideoPath,auOutDir,normAnnotatedVideoDir,outDir,vargin)
    
% Input args below:
% auOutDir = '/Users/wanqiaod/workspace/pipeline/out/AU_detector_out/';
% auIndexVect = [1,2,3,4,5,7];
% origVideoPath = '/Users/wanqiaod/workspace/pipeline/test_video/LeBlanc_short.mp4';
% normAnnotatedVideoDir = '/Users/wanqiaod/workspace/pipeline/out/feta_out/feta_norm_annotated_videos/';
% startFrame 
% endFrame   

defaultOutDir = '/Users/wanqiaod/workspace/pipeline'

window_x0 = 100;
window_y0 = 100;
window_w  = 1000;
window_h  = 700;
x0_offset = 0.4;
w_offset  = 0.4;
% Input args above

[~,origFname,~]  = fileparts(origVideoPath);
annotatedVideoFN = fullfile(normAnnotatedVideoDir,[origFname '_norm_annotated.avi']);
auFname          = fullfile(auOutDir,[origFname '_au_out.mat']);
outVideoFname    = fullfile(outDir,[origFname '_out_video.avi']);
origVideo        = VideoReader(origVideoPath);
annotatedVideo   = VideoReader(annotatedVideoFN);
outVideo         = VideoWriter(outVideoFname); 

startFrame = 1;
endFrame   = floor(annotatedVideo.Duration * annotatedVideo.FrameRate);

% Load AU result
load(auFname);
auNameCell = result.Properties.VariableNames;
frame_cnt  = floor(origVideo.Duration * origVideo.FrameRate);
y_pred     = table2array(result);

x = linspace(1,size(y_pred,1),size(y_pred,1));
x = x(startFrame:endFrame);

figure
set(gcf,'position',[window_x0,window_y0,window_w,window_h])
set(gcf,'color','white');
set(gca,'Clipping','off');
open(outVideo);

% x0, w, lowest_y0 are magic numbers. Might need update
auCnt = length(auIndexVect);
x0    = 0.05 + x0_offset;
h     = (1 - 0.3)/auCnt;
w     = 0.9 - w_offset;
highest_y0 = 1 - h - 0.04;
vertical_space = (1 - 0.04*2 - h*auCnt)/(auCnt-1);

cell_lines = num2cell(lines(auCnt),2);
for n = 1 : auCnt
    % Set subplot position
    y0  = highest_y0 - (vertical_space+h)*(n-1);
    % I don't why the last subplot is shifted a little bit.
    if n == 6
        subplot_offset = 5/window_w;
    else
        subplot_offset = 0;
    end
    x0 = x0 - subplot_offset;
    % Manual shifting above
    pos = [x0 y0 w h];
    ax = subplot('Position',pos);
    % Plot AU instensity
    handle = plot(ax,x,y_pred(:,auIndexVect(n)),'LineWidth',2);
    set(handle,{'color'},cell_lines(n));
    legendTxt    = [auNameCell{auIndexVect(n)} '   '];
    [~,hobj,~,~] = legend(ax,legendTxt,'Location','westoutside',...
                         'Orientation', 'horizontal');
    handleLine = findobj(hobj,'type','line');
    set(handleLine,'LineWidth',2); %legend line
    legend(ax,'boxoff');
    handleTxt = findobj(hobj,'type','text');
    set(handleTxt,'Color', 'black');
    % Set axe tick
    set(ax,'xticklabel',[])
    set(ax,'ytick',[0 0.5 1])
    set(ax,'yticklabel',[0 0.5 1])
    % Set axe limit
    xlim(ax,[startFrame endFrame]);
    ylim(ax,[0 1])

end

% hold on
set(gca,'Clipping','off');
video_ax_top_pos    = [0.07 0.55 0.35 0.35];
video_ax_bottom_pos = [0.07 0.05 0.35 0.35];
video_ax_top    = subplot('Position',video_ax_top_pos);
video_ax_bottom = subplot('Position',video_ax_bottom_pos);

for frameIndex = startFrame : endFrame
    x1 = frameIndex;
    timeLine = line(ax,[x1 x1],[0 20]);
    image(video_ax_top,origVideo.read(frameIndex));
    set(video_ax_top,'YTick',[]);
    set(video_ax_top,'XTick',[]);
    image(video_ax_bottom,annotatedVideo.read(frameIndex));
    set(video_ax_bottom,'YTick',[]);
    set(video_ax_bottom,'YTick',[]);
    set(timeLine,'LineWidth',1,'Color','r');
    % pause(0.1)    
    drawnow
    frame = getframe(gcf);
    img   = frame2im(frame);
    writeVideo(outVideo,img);
    set(timeLine,'Visible','off');
end
close(outVideo);
close all

end

