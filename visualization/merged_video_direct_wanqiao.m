
v1 = VideoReader(['GH060051_norm_short.mp4']);
aus= [1,2,4,6,7,10,12,14,15,17,23,24];
load('GH060051_norm_short.mp4.mat')
% y_pred contains AU probability outputs of the pipeline
v = VideoWriter(['output_video.avi']);

fig = figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf, 'color', 'k'); 

pos1 = [0.05 0.17 0.4 0.66];
pos2 = [0.5 0.84 0.45 0.14];
pos3 = [0.5 0.68 0.45 0.14];
pos4 = [0.5 0.52 0.45 0.14];
pos5 = [0.5 0.36 0.45 0.14];
pos6 = [0.5 0.20 0.45 0.14];
pos7 = [0.5 0.04 0.45 0.14];

ax1 = subplot('Position', pos1);
ax2 = subplot('Position', pos2);
ax3 = subplot('Position', pos3);
ax4 = subplot('Position', pos4);
ax5 = subplot('Position', pos5);
ax6 = subplot('Position', pos6);
ax7 = subplot('Position', pos7);

x = linspace(1,size(y_pred,1),size(y_pred,1));

limit1 = 1;
limit2 = 500; % number of frames to be visualized (can be v1.NumberOfFrames);
y_pred = y_pred(limit1:limit2,:);
x = x(limit1:limit2);

i1 = limit1;
open(v)
while i1 < limit2 %v1.NumberOfFrames
    i1 = i1+1;
    line_pos = i1
    
    if ishandle(ax1) % original video
        image(ax1, v1.read(i1));
        set(ax1,'YTick',[]);
        set(ax1,'XTick',[]);
        %set(get(ax1, 'title'), 'string', ['DBS multiple AUs'])
    end
    %%%%%%%%%%%%%%%% ax2%%%%%%%%%%%%%%%%%%%%%
    if ishandle(ax2)
        labels = y_pred(:,1); %AU1
        h = plot(ax2,x,labels, 'LineWidth', 2);
        hold(ax2,'on')
        
        cell_lines = num2cell(lines(6),2);
        set(h, {'color'}, cell_lines(1));
        
        %%%legend
        [~, hobj, ~, ~] = legend(ax2,['AU1' '   '], 'Location', 'eastoutside', 'Orientation', 'horizontal');
        hl = findobj(hobj,'type','line'); % legend line
        set(hl,'LineWidth',2);
        legend(ax2, 'boxoff') % remove legend box
        ht = findobj(hobj,'type','text'); % update legend text
        set(ht,'FontSize',20, 'Color', 'white');
        
        set(ax2,'xticklabel',[])
        set(ax2,'ytick',[0 0.5 1])
        set(ax2,'yticklabel',[0 0.5 1])
        
        xlim(ax2, [limit1 limit2])
        ylim(ax2,[0 1])
        x1= line_pos;
        y1=get(ax2,'ylim');
        plot(ax2,[x1 x1],y1, 'Color', 'r') % moving red line
        hold(ax2,'off')
    end
    
    %%%%%%%%%%%%%%% ax 3
    
    if ishandle(ax3)
        labels = y_pred(:,2); %AU2
        h = plot(ax3,x,labels, 'LineWidth', 2);
        hold(ax3,'on')
        
        cell_lines = num2cell(lines(6),2);
        set(h, {'color'}, cell_lines(2));
        
        [~, hobj, ~, ~] = legend(ax3,['AU2' '   '], 'Location', 'eastoutside', 'Orientation', 'horizontal');
        hl = findobj(hobj,'type','line');
        set(hl,'LineWidth',2);
        legend(ax3, 'boxoff')
        ht = findobj(hobj,'type','text');
        set(ht,'FontSize',20, 'Color', 'white');
        
        set(ax3,'xticklabel',[])
        set(ax3,'ytick',[0 0.5 1])
        set(ax3,'yticklabel',[0 0.5 1])
        
        xlim(ax3, [limit1 limit2])
        ylim(ax3,[0 1])
        x1= line_pos;
        y1=get(ax3,'ylim');
        plot(ax3,[x1 x1],y1, 'Color', 'r')
        hold(ax3,'off')
    end
    
    %%%%%%%%%%%%%%% ax4
    
    if ishandle(ax4)
        labels = y_pred(:,3); %AU4
        h = plot(ax4,x,labels, 'LineWidth', 2);
        hold(ax4,'on')
        
        cell_lines = num2cell(lines(6),2);
        set(h, {'color'}, cell_lines(3));
        
        [~, hobj, ~, ~] = legend(ax4,['AU4' '   '], 'Location', 'eastoutside', 'Orientation', 'horizontal');
        hl = findobj(hobj,'type','line');
        set(hl,'LineWidth',2);
        legend(ax4, 'boxoff')
        ht = findobj(hobj,'type','text');
        set(ht,'FontSize',20, 'Color', 'white');
        
        set(ax4,'xticklabel',[])
        set(ax4,'ytick',[0 0.5 1])
        set(ax4,'yticklabel',[0 0.5 1])
        
        xlim(ax4, [limit1 limit2])
        ylim(ax4,[0 1])
        x1= line_pos;
        y1=get(ax4,'ylim');
        plot(ax4,[x1 x1],y1, 'Color', 'r')
        hold(ax4,'off')
    end
    
    %%%%%%%%%%%%%%% ax5
    
    if ishandle(ax5)
        labels = y_pred(:,4); %AU6
        h = plot(ax5,x,labels, 'LineWidth', 2);
        hold(ax5,'on')
        
        cell_lines = num2cell(lines(6),2);
        set(h, {'color'}, cell_lines(4));
        
        [~, hobj, ~, ~] = legend(ax5,['AU6' '   '], 'Location', 'eastoutside', 'Orientation', 'horizontal');
        hl = findobj(hobj,'type','line');
        set(hl,'LineWidth',2);
        legend(ax5, 'boxoff')
        ht = findobj(hobj,'type','text');
        set(ht,'FontSize',20, 'Color', 'white');
        
        set(ax5,'xticklabel',[])
        set(ax5,'ytick',[0 0.5 1])
        set(ax5,'yticklabel',[0 0.5 1])
        
        xlim(ax5, [limit1 limit2])
        ylim(ax5,[0 1])
        x1= line_pos;
        y1=get(ax5,'ylim');
        plot(ax5,[x1 x1],y1, 'Color', 'r')
        hold(ax5,'off')
    end
    
    %%%%%%%%%%%%%%% ax6
    
    if ishandle(ax6)
        labels = y_pred(:,5); %AU7
        h = plot(ax6,x,labels, 'LineWidth', 2);
        hold(ax6,'on')
        
        cell_lines = num2cell(lines(6),2);
        set(h, {'color'}, cell_lines(5));
        
        [~, hobj, ~, ~] = legend(ax6,['AU7' '   '], 'Location', 'eastoutside', 'Orientation', 'horizontal');
        hl = findobj(hobj,'type','line');
        set(hl,'LineWidth',2);
        legend(ax6, 'boxoff')
        ht = findobj(hobj,'type','text');
        set(ht,'FontSize',20, 'Color', 'white');
        
        set(ax6,'xticklabel',[])
        set(ax6,'ytick',[0 0.5 1])
        set(ax6,'yticklabel',[0 0.5 1])
        
        xlim(ax6, [limit1 limit2])
        ylim(ax6,[0 1])
        x1= line_pos;
        y1=get(ax6,'ylim');
        plot(ax6,[x1 x1],y1, 'Color', 'r')
        hold(ax6,'off')
    end
    
    %%%%%%%%%%%%%%% ax7
    
    if ishandle(ax7)
        labels = y_pred(:,7); %AU12
        h = plot(ax7,x,labels, 'LineWidth', 2);
        hold(ax7,'on')
        
        cell_lines = num2cell(lines(6),2);
        set(h, {'color'}, cell_lines(6));
        
        [~, hobj, ~, ~] = legend(ax7,['AU12' '   '], 'Location', 'eastoutside', 'Orientation', 'horizontal');
        hl = findobj(hobj,'type','line');
        set(hl,'LineWidth',2);
        legend(ax7, 'boxoff')
        ht = findobj(hobj,'type','text');
        set(ht,'FontSize',20, 'Color', 'white');
        
        set(ax7,'xticklabel',[])
        set(ax7,'ytick',[0 0.5 1])
        set(ax7,'yticklabel',[0 0.5 1])
        
        xlim(ax7, [limit1 limit2])
        ylim(ax7,[0 1])
        x1= line_pos;
        y1=get(ax7,'ylim');
        plot(ax7,[x1 x1],y1, 'Color', 'r')
        hold(ax7,'off')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    drawnow
    frame = getframe(gcf);
    img = frame2im(frame);
    writeVideo(v,img);
end
close(v)