function h = InitDisplay( zf, I )

    % original display goes for default matlab window size. Since video is
    % saved from the figure window rendering, we need to preserve the
    % figure size by setting to image size
    h.fig = figure('name','ZFace v1.1 Demo','NumberTitle','off', 'Position', [0, 0, size(I, 2), size(I, 1)]);
    h.img = imshow(I);
    hold on;
	tmp = zeros( zf.GetPdmN(),2 );    
    h.pts2D = plot( tmp(:,1),tmp(:,1),'bx' ); 
    fc = zf.GetFaceContour();
    for i = 1:length(fc)
        ndx = fc{i};
        h.fc{i} = plot( tmp(ndx,1),tmp(ndx,2),'g','LineWidth',2);
    end

    h.pts3D = plot( tmp(:,1),tmp(:,1),'bx' ); 
    for i = 1:length(fc)
        ndx = fc{i};
        h.fc3D{i} = plot( tmp(ndx,1),tmp(ndx,2),'g','LineWidth',2);
    end   

    h.pts3DSide = plot( tmp(:,1),tmp(:,1),'bx' ); 
    for i = 1:length(fc)
        ndx = fc{i};
        h.fc3DSide{i} = plot( tmp(ndx,1),tmp(ndx,2),'g','LineWidth',2);
    end       
    
%     zlim([-100,100]);
    center = [0,0,999];
    headSize = 1;
    h.A_SIZE = 0.75;
    R = eye(3,3);
    h.A1 = arrow3D([center(1),center(2),center(3)], R*[headSize*h.A_SIZE,0,0]', 'y', 0.75, []);
    h.A2 = arrow3D([center(1),center(2),center(3)], R*[0,-headSize*h.A_SIZE,0]', 'm', 0.75, []);
    h.A3 = arrow3D([center(1),center(2),center(3)], R*[0,0,-headSize*h.A_SIZE]', 'c', 0.75, []);    
        
    set(h.fig,'renderer','opengl');
    % remove the gray boundary about figure
    set(gca, 'position', [0 0 1 1], 'units', 'normalized');
end

