function [outImage] = plotShapeRGB(p_image,p_shape,p_color)

    outImage = p_image;
    
    p_shape = round(p_shape);
    N = size(p_shape,1);
    sizeX = size(outImage,2);
    sizeY = size(outImage,1);
    for i = 1:N
        if ((p_shape(i,1) > 2)&(p_shape(i,1) < sizeX-1)&...
            (p_shape(i,2) > 2)&(p_shape(i,2) < sizeY-1))
        
%             for j = 2
                outImage(p_shape(i,2),p_shape(i,1),:) = p_color;
                outImage(p_shape(i,2)+1,p_shape(i,1),:) = p_color;
                outImage(p_shape(i,2)-1,p_shape(i,1),:) = p_color;
                outImage(p_shape(i,2),p_shape(i,1)+1,:) = p_color;
                outImage(p_shape(i,2),p_shape(i,1)-1,:) = p_color;
                outImage(p_shape(i,2)+1,p_shape(i,1)+1,:) = p_color;
                outImage(p_shape(i,2)+1,p_shape(i,1)-1,:) = p_color;
                outImage(p_shape(i,2)-1,p_shape(i,1)+1,:) = p_color;
                outImage(p_shape(i,2)-1,p_shape(i,1)-1,:) = p_color;
                outImage(p_shape(i,2)+2,p_shape(i,1),:) = p_color;
                outImage(p_shape(i,2)-2,p_shape(i,1),:) = p_color;
                outImage(p_shape(i,2),p_shape(i,1)+2,:) = p_color;
                outImage(p_shape(i,2),p_shape(i,1)-2,:) = p_color;     
%             end
        end;
    end;    
    
end