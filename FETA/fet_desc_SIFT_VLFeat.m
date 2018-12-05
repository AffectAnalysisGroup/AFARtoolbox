function [ phi, descExt ] = fet_desc_SIFT_VLFeat( I, pts, patchSize, descExt )

%     if isempty(descExt)
%         descExt = cv.DescriptorExtractor( 'SIFT' );
%     end
%         
%     kp = struct([]);
%     for i = 1:size(pts,1)
%         kp(i).pt = pts(i,:);
%         kp(i).size = patchSize;
%     end
%     phi = descExt.compute(I,kp);
%     phi = phi(:)';

    if size(I,3) > 1
        I = rgb2gray(I);
    end
    I = single(I)./255;
    p = double([pts';3*ones(1,size(pts,1));zeros(1,size(pts,1))]);
    [~,phi] = vl_sift(I,'frames',double(p));
    phi = single(phi');
%     phi = phi(:)';
end

