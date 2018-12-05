function [ phi, descExt ] = fet_desc_Raw_Texture( I, pts, patchSize, descExt )
   
    if size(I,3) > 1
        I = rgb2gray(I);
    end    
        
%     phi = zeros(patchSize,size(pts,1));
    phi = zeros(size(pts,1),patchSize*patchSize);
    
    r = floor(patchSize/2);
    for i = 1:size(pts,1)
        tmpPts = round(pts(i,:));
        stX = tmpPts(1,1)-r;
        stY = tmpPts(1,2)-r;
        enX = tmpPts(1,1)+r-1;
        enY = tmpPts(1,2)+r-1;
                
        tmpPatch = I(stY:enY,stX:enX);
  
        phi(i,:) = tmpPatch(:);
%         stP = (i-1)*patchSize + 1;
%         enP = i*patchSize;
%         phi(:,stP:enP) = tmpPatch;
    end
    phi = single(phi);
%     phi = phi(:)';
    
end

