function [X,Y] = getBarPos(top_left,top_right,p1,p2)
    % getBarPos get the corner coordinates of the de-identifying black bar
    d1 = norm(cross([top_left-top_right 0],[p1-top_right 0]))/norm(top_left-top_right);
    d2 = norm(cross([top_left-top_right 0],[p2-top_right 0]))/norm(top_left-top_right);
    h  = (d1+d2)/2;
    w  = norm(top_right-top_left);
    % patch, left top, right top, right bottom, left bottom
    left_x = top_left(1); right_x = left_x + w;
    top_y  = top_left(2); bottom_y = top_y - h;
    [delta,~] = cart2pol(w,h);
    X = [left_x right_x right_x left_x] - left_x;
    Y = [top_y top_y bottom_y bottom_y] - top_y;
    [theta,rho] = cart2pol(X,Y);
    [X,Y] = pol2cart(theta+delta,rho);
    
end




