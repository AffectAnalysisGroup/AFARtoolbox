function h = DemoInitDisplay( zf, I )
% original display goes for default matlab window size. Since video is
% saved from the figure window rendering, we need to preserve the
% figure size by setting to image size
h.fig = figure('name','ZFace v1.1 Demo','NumberTitle','off', 'Position', [1, 1, size(I, 2), size(I, 1)]);
%h.img = imshow(I);
h.img = image(I);
set(gca,'YTick',[]);
set(gca,'XTick',[]);
set(gca, 'box', 'off');
hold on;
h = ResetDisplay(h, zf);
% tmp = zeros( zf.GetPdmN(),2 );
% h.pts2D = plot(tmp(:,1),tmp(:,1),'bx' );
% h.pts2Da = plot(tmp(:,1),tmp(:,1),'b.');
% 
% h.pts3Da = scatter3(tmp(:,1),tmp(:,1),tmp(:,1),10,'blue','filled');
% h.pts3Db = scatter3(tmp(:,1),tmp(:,1),tmp(:,1),10,'blue','filled');
% h.pts3Dc = scatter3(tmp(:,1),tmp(:,1),tmp(:,1),10,'blue','filled');
% h.patch  = patch([0 0 0 0],[0 0 0 0],'k');
% fc = zf.GetFaceContour();
% 
% % primaryPts2D added to plot a scatter of 49 primary landmarks;
% for i = 1:length(fc)
%     ndx = fc{i};
%     h.fc{i} = plot( tmp(ndx,1),tmp(ndx,2),'g','LineWidth',2);
%     h.primaryPts2D{i} = scatter(tmp(ndx,1),tmp(ndx,2), 10, 'green','filled');
%     
% end
% 
% %     zlim([-100,100]);
% center = [0,0,999];
% headSize = 1;
% h.A_SIZE = 0.75;
% R = eye(3,3);
% h.A1 = arrow3D([center(1),center(2),center(3)], R*[headSize*h.A_SIZE,0,0]', 'y', 0.75, []);
% h.A2 = arrow3D([center(1),center(2),center(3)], R*[0,-headSize*h.A_SIZE,0]', 'm', 0.75, []);
% h.A3 = arrow3D([center(1),center(2),center(3)], R*[0,0,-headSize*h.A_SIZE]', 'c', 0.75, []);
% 
% set(h.fig,'renderer','opengl');
% % remove the gray boundary about figure
% set(gca, 'position', [0 0 1 1], 'units', 'normalized');
end

