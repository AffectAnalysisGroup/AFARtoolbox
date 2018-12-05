function arrowHandle = arrow3D(pos, deltaValues, colorCode, stemRatio, h)

% arrowHandle = arrow3D(pos, deltaValues, colorCode, stemRatio) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     Used to plot a single 3D arrow with a cylindrical stem and cone arrowhead
%     pos = [X,Y,Z] - spatial location of the starting point of the arrow (end of stem)
%     deltaValues = [QX,QY,QZ] - delta parameters denoting the magnitude of the arrow along the x,y,z-axes (relative to 'pos')
%     colorCode - Color parameters as per the 'surf' command.  For example, 'r', 'red', [1 0 0] are all examples of a red-colored arrow
%     stemRatio - The ratio of the length of the stem in proportion to the arrowhead.  For example, a call of:
%                 arrow3D([0,0,0], [100,0,0] , 'r', 0.82) will produce a red arrow of magnitude 100, with the arrowstem spanning a distance
%                 of 82 (note 0.82 ratio of length 100) while the arrowhead (cone) spans 18.  
% 
%     Example:
%       arrow3D([0,0,0], [4,3,7]);  %---- arrow with default parameters
%       axis equal;
% 
%    Author: Shawn Arseneau
%    Created: September 14, 2006
%    Updated: September 18, 2006
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin<2 || nargin>5
        error('Incorrect number of inputs to arrow3D');     
    end
    if numel(pos)~=3 || numel(deltaValues)~=3
        error('pos and/or deltaValues is incorrect dimensions (should be three)');
    end
    if nargin<3                 
        colorCode = 'interp';                               
    end
    if nargin<4                 
        stemRatio = 0.75;                                   
    end    

    X = pos(1); %---- with this notation, there is no need to transpose if the user has chosen a row vs col vector
    Y = pos(2);
    Z = pos(3);
    
    [sphi, stheta, srho] = cart2sph(deltaValues(1), deltaValues(2), deltaValues(3));  
    
    %******************************************* CYLINDER == STEM *********************************************
    cylinderRadius = 0.03*srho;
    cylinderLength = srho*stemRatio;
    [CX,CY,CZ] = cylinder(cylinderRadius);      
    CZ = CZ.*cylinderLength;    %---- lengthen
    
    %----- ROTATE CYLINDER
    [row, col] = size(CX);      %---- initial rotation to coincide with X-axis
    
    newEll = rotatePoints([0 0 -1], [CX(:), CY(:), CZ(:)]);
    CX = reshape(newEll(:,1), row, col);
    CY = reshape(newEll(:,2), row, col);
    CZ = reshape(newEll(:,3), row, col);
    
    [row, col] = size(CX);    
    newEll = rotatePoints(deltaValues, [CX(:), CY(:), CZ(:)]);
    stemX = reshape(newEll(:,1), row, col);
    stemY = reshape(newEll(:,2), row, col);
    stemZ = reshape(newEll(:,3), row, col);

    %----- TRANSLATE CYLINDER
    stemX = stemX + X;
    stemY = stemY + Y;
    stemZ = stemZ + Z;
    
    %******************************************* CONE == ARROWHEAD *********************************************
    coneLength = srho*(1-stemRatio);
    coneRadius = cylinderRadius*1.5;
%     coneRadius = 0.5*srho;
    incr = 4;  %---- Steps of cone increments
    coneincr = coneRadius/incr;    
    [coneX, coneY, coneZ] = cylinder(cylinderRadius*2:-coneincr:0);  %---------- CONE 
    coneZ = coneZ.*coneLength;
    
    %----- ROTATE CONE 
    [row, col] = size(coneX);    
    newEll = rotatePoints([0 0 -1], [coneX(:), coneY(:), coneZ(:)]);
    coneX = reshape(newEll(:,1), row, col);
    coneY = reshape(newEll(:,2), row, col);
    coneZ = reshape(newEll(:,3), row, col);
    
    newEll = rotatePoints(deltaValues, [coneX(:), coneY(:), coneZ(:)]);
    headX = reshape(newEll(:,1), row, col);
    headY = reshape(newEll(:,2), row, col);
    headZ = reshape(newEll(:,3), row, col);
    
    %---- TRANSLATE CONE
    V = [0, 0, srho*stemRatio];    %---- centerline for cylinder: the multiplier is to set the cone 'on the rim' of the cylinder
    Vp = rotatePoints([0 0 -1], V);
    Vp = rotatePoints(deltaValues, Vp);
    headX = headX + Vp(1) + X;
    headY = headY + Vp(2) + Y;
    headZ = headZ + Vp(3) + Z;
    %************************************************************************************************************    
	if isempty(h)
%         shading flat 
%         hStem = surf(stemX, stemY, stemZ, 'FaceColor', [1 1 1], 'EdgeColor', 'none','FaceAlpha',0.3);         
        hStem = surf(stemX, stemY, stemZ, 'FaceColor', colorCode, 'EdgeColor', 'none','FaceAlpha',0.2); 
%         hStem = surf(stemX, stemY, stemZ, 'FaceColor', colorCode, 'EdgeColor', 'none'); 
        hold on;  
        hHead = surf(headX, headY, headZ, 'FaceColor', colorCode, 'EdgeColor', 'none','FaceAlpha',1);
%         hHead = surf(headX, headY, headZ, 'FaceColor', colorCode, 'EdgeColor', 'none');
        if nargout==1   
            arrowHandle = [hStem, hHead]; 
        end        
    else
        set(h(1),'xdata',stemX,'ydata',stemY,'zdata',stemZ);
        set(h(2),'xdata',headX,'ydata',headY,'zdata',headZ);
        arrowHandle = h;
    end
%     hStem = surf(stemX, stemY, stemZ, 'FaceColor', colorCode, 'EdgeColor', 'none'); 
%     hold on;  
%     hHead = surf(headX, headY, headZ, 'FaceColor', colorCode, 'EdgeColor', 'none');
%     

    
    

































