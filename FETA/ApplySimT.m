function [ pts_AS, I_AS ] = ApplySimT( pts, I, Tr, res )

    pts_AS = [];
    I_AS = [];
    
    if ~isempty(pts)
        pts_AS = pts;  
        n = size(pts,1);
        for i = 1:n
            pts_AS(i,1) = Tr.a*pts(i,1) - Tr.b*pts(i,2) + Tr.tx; 
            pts_AS(i,2) = Tr.b*pts(i,1) + Tr.a*pts(i,2) + Tr.ty; 
        end
    end
    
    if ~isempty(I)            
        M = [Tr.a -Tr.b Tr.tx; Tr.b Tr.a Tr.ty];
        I_AS = cv.warpAffine(I, M,'DSize',[res,res],...
            'Interpolation','Linear','BorderType','Replicate');
    end
    
end

