function [ phi, descExt ] = fet_desc_HOG_OpenCV( I, pts, patchSize, descExt )

    if isempty(descExt)
        descExt = cv.HOGDescriptor();
        descExt.WinSize = [patchSize,patchSize];
        descExt.BlockSize = [patchSize,patchSize];
        descExt.BlockStride = [patchSize,patchSize];
        descExt.CellSize = [round(patchSize/4),round(patchSize/4)];
        descExt.NBins = 8;    
    end
    
    if size(I,3) > 1
        I = rgb2gray(I);
    end    

    pts = pts - patchSize/2;
    phi = descExt.compute(I,'Locations',mat2cell(pts,ones(size(pts,1),1),2));
%     phi = phi(:)';
    
end