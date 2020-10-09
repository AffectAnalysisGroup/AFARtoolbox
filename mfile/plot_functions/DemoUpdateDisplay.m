function DemoUpdateDisplay(h,zf,I,ctrl2D,mesh2D,mesh3D,pars )

    set(h.img,'cdata',I);
    if ~isempty(ctrl2D)

        set(h.pts2D,'xdata',mesh2D(:,1),'ydata',mesh2D(:,2));

        x = mesh3D(:,1); y = mesh3D(:,2); z = mesh3D(:,3);
        theta = -pi/6;
        Xb = x*cos(theta) + z*sin(theta);Yb = y;Zb = z*cos(theta) - x*sin(theta);
        Xc = x*cos(-theta) + z*sin(-theta);Yc = y;Zc = z*cos(-theta) - x*sin(-theta);
        set(h.pts3Da,'xdata',x*200+100,'ydata',y*200+100,'zdata',z*200+100);
        set(h.pts3Db,'xdata',Xb*200+100,'ydata',Yb*200+300,'zdata',Zb*200+100);
        set(h.pts3Dc,'xdata',Xc*200+100,'ydata',Yc*200+500,'zdata',Zc*200+100);

        img_wh = [h.img.XData(2) h.img.YData(2)];
        %bl = flipud(img_wh - mesh2D(246,:)); tr = flipud(img_wh - mesh2D(444,:));
        bl = mesh2D(246,:); tr = mesh2D(444,:);
        patch_x = [bl(1) tr(1) tr(1) bl(1)];
        patch_y = [bl(2) bl(2) tr(2) tr(2)];
        set(h.patch,'xdata',patch_x,'ydata',patch_y);

        fc = zf.GetFaceContour();
        for i = 1:length(fc)
            ndx = fc{i};
            set(h.fc{i},'xdata',ctrl2D(ndx,1),'ydata',ctrl2D(ndx,2));
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

