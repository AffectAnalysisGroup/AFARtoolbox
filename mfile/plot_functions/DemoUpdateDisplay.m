function DemoUpdateDisplay(h,zf,I,ctrl2D,mesh2D,mesh3D,pars, varargin)

p = inputParser;
default_dense_mesh = false;
default_primary_facial_points = true;
default_de_identify = true;

addOptional(p,'dense_mesh',default_dense_mesh);
addOptional(p,'primary_facial_points',default_primary_facial_points);
addOptional(p,'de_identify',default_de_identify);

parse(p,varargin{:});
dense_mesh = p.Results.dense_mesh;
primary_facial_points = p.Results.primary_facial_points;
de_identification_patch = p.Results.de_identify;

set(h.img,'cdata',I);
if ~isempty(ctrl2D)
    
    if(dense_mesh)
        set(h.pts2D,'xdata',mesh2D(:,1),'ydata',mesh2D(:,2));
        set(h.pts2D,'visible','on')
        
        % Plot the side views with different camera angles
        x = mesh3D(:,1); y = mesh3D(:,2); z = mesh3D(:,3);
        theta = -pi/6;
        Xb = x*cos(theta) + z*sin(theta);Yb = y;Zb = z*cos(theta) - x*sin(theta);
        Xc = x*cos(-theta) + z*sin(-theta);Yc = y;Zc = z*cos(-theta) - x*sin(-theta);
        set(h.pts3Da,'xdata',x*200+100,'ydata',y*200+100,'zdata',z*200+100);
        set(h.pts3Db,'xdata',Xb*200+100,'ydata',Yb*200+300,'zdata',Zb*200+100);
        set(h.pts3Dc,'xdata',Xc*200+100,'ydata',Yc*200+500,'zdata',Zc*200+100);
        set(h.pts3Da,'visible','off');
        set(h.pts3Db,'visible','off');
        set(h.pts3Dc,'visible','off');
        
        x = (mesh2D(:,1)-mean(mesh2D(:,1)))*0.7+150;
        y = (mesh2D(:,2)-mean(mesh2D(:,2)))*0.7+200;
        set(h.pts2Da,'xdata',x,'ydata',y);
        set(h.pts2Da,'visible','on');
        
        %         %bl = mesh2D(246,:); tr = mesh2D(444,:);
        %         %patch_x = [bl(1) tr(1) tr(1) bl(1)];
        %         %patch_y = [bl(2) bl(2) tr(2) tr(2)];
    end
    
    if(primary_facial_points)
        eyebrow_lcorner = ctrl2D(1,:);  eye_lcorner = ctrl2D(20,:);
        eyebrow_rcorner = ctrl2D(10,:); eye_rcorner = ctrl2D(29,:);
        
        if(de_identification_patch)
            [bar_x,bar_y] = getBarPos(eyebrow_lcorner,eyebrow_rcorner,eye_lcorner,eye_rcorner);
            set(h.patch,'xdata',bar_x,'ydata',bar_y);
        end
        
        fc = zf.GetFaceContour();
        for i = 1:length(fc)
            ndx = fc{i};
%             scatter(ctrl2D(ndx, 1), ctrl2D(ndx, 2), 7, 'x', 'g');
            set(h.primaryPts2D{i}, 'xdata',ctrl2D(ndx,1),'ydata',ctrl2D(ndx,2));
            set(h.primaryPts2D{i}, 'visible', 'on');
            % join landmarks from 49 primary keypoints
%             set(h.fc{i},'xdata',ctrl2D(ndx,1),'ydata',ctrl2D(ndx,2));
%             set(h.fc{i},'visible','on');
        end
        
        %         zlim([-100,100]);
        center = double([mean(ctrl2D),999]);
    end
    headSize = double(pars(1));
    headPose = pars(4:6);
    
    R = zf.Euler2Rot( headPose(1), headPose(2), headPose(3) );
    
    h.A1 = arrow3D([center(1),center(2),center(3)], R*[headSize*h.A_SIZE,0,0]', 'y', 0.75, h.A1);
    h.A2 = arrow3D([center(1),center(2),center(3)], R*[0,-headSize*h.A_SIZE,0]', 'm', 0.75, h.A2);
    h.A3 = arrow3D([center(1),center(2),center(3)], R*[0,0,-headSize*h.A_SIZE]', 'c', 0.75, h.A3);
    
    set(h.A1,'visible','on');
    set(h.A2,'visible','on');
    set(h.A3,'visible','on');
else
%     [h] = ResetDisplay(h, zf, 'remove_annotations', true);
    set(h.pts2D,'xdata',zeros(zf.GetPdmN(),1),'ydata',zeros(zf.GetPdmN(),1));
    fc = zf.GetFaceContour();
    for i = 1:length(fc)
        cn = length(fc{i});
        set(h.fc{i},'xdata',zeros(cn,1),'ydata',zeros(cn,1));
        set(h.fc{i},'visible','off');
        set(h.primaryPts2D{i}, 'xdata',zeros(cn,1),'ydata',zeros(cn,1));
        set(h.primaryPts2D{i}, 'visible', 'off');
    end
    
    set(h.A1,'visible','off');
    set(h.A2,'visible','off');
    set(h.A3,'visible','off');
end
drawnow;
end

