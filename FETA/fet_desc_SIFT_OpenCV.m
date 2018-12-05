function [ phi, descExt ] = fet_desc_SIFT_OpenCV( I, pts, patchSize, descExt )

    if isempty(descExt)
        descExt = cv.DescriptorExtractor( 'SIFT' );
    end
    
    if size(I,3) > 1
        I = rgb2gray(I);
    end    
        
    kp = struct([]);
    for i = 1:size(pts,1)
        kp(i).pt = pts(i,:);
        kp(i).size = patchSize;
    end
    phi = descExt.compute(I,kp);
%     phi = phi(:)';
    
end

