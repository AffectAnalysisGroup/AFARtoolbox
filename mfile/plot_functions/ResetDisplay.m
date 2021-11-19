function h = ResetDisplay(h, zf, varargin)

% remove_annotations does not disable annotations

p = inputParser;
default_remove_annotations = false;
addOptional(p,'remove_annotations',default_remove_annotations);

parse(p,varargin{:});
remove_annotations = p.Results.remove_annotations;

tmp = zeros( zf.GetPdmN(),2 );
h.pts2D = plot(tmp(:,1),tmp(:,1),'bx' );
h.pts2Da = plot(tmp(:,1),tmp(:,1),'b.');

h.pts3Da = scatter3(tmp(:,1),tmp(:,1),tmp(:,1),10,'blue','filled');
h.pts3Db = scatter3(tmp(:,1),tmp(:,1),tmp(:,1),10,'blue','filled');
h.pts3Dc = scatter3(tmp(:,1),tmp(:,1),tmp(:,1),10,'blue','filled');
h.patch  = patch([0 0 0 0],[0 0 0 0],'k');
fc = zf.GetFaceContour();

% primaryPts2D added to plot a scatter of 49 primary landmarks;
for i = 1:length(fc)
    ndx = fc{i};
    h.fc{i} = plot( tmp(ndx,1),tmp(ndx,2),'g','LineWidth',2);
    h.primaryPts2D{i} = scatter(tmp(ndx,1),tmp(ndx,2), 10, 'green','filled');
    if(remove_annotations)
        set(h.fc{i},'visible','off');
        set(h.primaryPts2D{i}, 'visible', 'off');
    end
end

%     zlim([-100,100]);
center = [0,0,999];
headSize = 1;
h.A_SIZE = 0.75;
R = eye(3,3);
h.A1 = arrow3D([center(1),center(2),center(3)], R*[headSize*h.A_SIZE,0,0]', 'y', 0.75, []);
h.A2 = arrow3D([center(1),center(2),center(3)], R*[0,-headSize*h.A_SIZE,0]', 'm', 0.75, []);
h.A3 = arrow3D([center(1),center(2),center(3)], R*[0,0,-headSize*h.A_SIZE]', 'c', 0.75, []);

if(remove_annotations)
    % remove all annotations when tracking fails
    set(h.A1,'visible','off');
    set(h.A2,'visible','off');
    set(h.A3,'visible','off');
end

set(h.fig,'renderer','opengl');
% remove the gray boundary about figure
set(gca, 'position', [0 0 1 1], 'units', 'normalized');
end