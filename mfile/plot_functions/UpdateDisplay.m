function UpdateDisplay( h, zf, I, ctrl2D, mesh2D, pars )

    set(h.img,'cdata',I);
    if ~isempty(ctrl2D)
        set(h.pts2D,'xdata',mesh2D(:,1),'ydata',mesh2D(:,2));
        fc = zf.GetFaceContour();
        for i = 1:length(fc)
            ndx = fc{i};
            set(h.fc{i},'xdata',ctrl2D(ndx,1),'ydata',ctrl2D(ndx,2));
        end

        p2 = pars;
        p2(1) = 200;
        p2(2) = 100;
        p2(3) = 120;
        p2(4:6) = [35*pi/180;45*pi/180;0];
        s3D = zf.Shape3DFromParameters(p2);
        s3D = [s3D(1:3:end), s3D(2:3:end), s3D(3:3:end)];
        set(h.pts3D,'xdata',s3D(:,1),'ydata',s3D(:,2));                
        for i = 1:length(fc)
            ndx = fc{i};
            set(h.fc3D{i},'xdata',s3D(ndx,1),'ydata',s3D(ndx,2));
        end
        
        p2(1) = 200;
        p2(2) = 100;
        p2(3) = 120+240;
        p2(4:6) = [0;90*pi/180;0];
        s3D = zf.Shape3DFromParameters(p2);
        s3D = [s3D(1:3:end), s3D(2:3:end), s3D(3:3:end)];
        set(h.pts3DSide,'xdata',s3D(:,1),'ydata',s3D(:,2));                
        for i = 1:length(fc)
            ndx = fc{i};
            set(h.fc3DSide{i},'xdata',s3D(ndx,1),'ydata',s3D(ndx,2));
        end
        
%         zlim([-100,100]);
        center = double([mean(ctrl2D),999]);
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
        set(h.pts2D,'xdata',zeros(zf.GetPdmN(),1),'ydata',zeros(zf.GetPdmN(),1));
        fc = zf.GetFaceContour();
        for i = 1:length(fc)
            cn = length(fc{i});
            set(h.fc{i},'xdata',zeros(cn,1),'ydata',zeros(cn,1));
        end        
        set(h.A1,'visible','off');
        set(h.A2,'visible','off');
        set(h.A3,'visible','off');        
    end
    drawnow;
end

