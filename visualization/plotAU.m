% function plotAU(auIndexVect,origVideoPath,auDir,fetaNormAnnotatedDir)
% function msg = plotAU(auIndexVect,origVideoPath,auDir,fetaNormAnnotatedDir)
% Input args below:
auDir = '/Users/wanqiaod/workspace/pipeline/out/AU_detector_out/';
auIndexVect = [1,2,3,4,5,9];
origVideoPath = '/Users/wanqiaod/workspace/pipeline/test_video/LeBlanc_short.mp4';
normAnnotatedVideoDir = '/Users/wanqiaod/workspace/pipeline/out/feta_out/feta_norm_annotated_videos/';
% startFrame 
% endFrame   
% Input args above

[~,origFname,~]  = fileparts(origVideoPath);
annotatedVideoFN = fullfile(normAnnotatedVideoDir,[origFname '_norm_annotated.mp4']);
auFname          = fullfile(auDir,[origFname '_au_out.mat']);
origVideo        = VideoReader(origVideoPath);
annotatedVideo   = VideoReader(annotatedVideoFN);

startFrame = 1;
endFrame   = floor(annotatedVideo.Duration * annotatedVideo.FrameRate);

% Load AU result
load(auFname);
auNameCell = result.Properties.VariableNames;
frame_cnt  = floor(origVideo.Duration * origVideo.FrameRate);
y_pred     = table2array(result);

x = linspace(1,size(y_pred,1),size(y_pred,1));
x = x(startFrame:endFrame);

window_x0 = 100;
window_y0 = 100;
window_w  = 800;
window_h  = 700;

figure
set(gcf,'position',[window_x0,window_y0,window_w,window_h])
set(gca,'Clipping','off');

% x0, w, lowest_y0 are magic numbers. Might need update
auCnt = length(auIndexVect);
x0    = 0.05;
h     = (1 - 0.3)/auCnt;
w     = 0.9;
highest_y0 = 0.84;
vertical_space = (1 - 0.04*2 - h*auCnt)/(auCnt-1);

cell_lines = num2cell(lines(auCnt),2);
for n = 1 : auCnt
    % Set subplot position
    y0  = highest_y0 - (vertical_space+h)*(n-1);
    if n == 6
        x0 = 0.045;
    else
        x0 = 0.05;
    end
    pos = [x0 y0 w h];
    ax = subplot('Position',pos);
    % Plot AU instensity
    handle = plot(ax,x,y_pred(:,auIndexVect(n)),'LineWidth',2);
    set(handle,{'color'},cell_lines(n));
    % Set legend text
    legendTxt    = [auNameCell{n} '   '];
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
    % if n == 1
    %     ax1 = ax;
    % end
end
% hold on
% set(gca,'Clipping','off');
% x1 = 0;
% y1 = 1;
% timeLine = line([x1 x1],[0 20]);
% set(timeLine,'LineWidth',1,'Color','r');



% Load img from video
% Write to output video

% end
