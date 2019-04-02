function avg_dist = getAvgDist(single_face)
single_face = single_face(20:31,:);
left_dist_1  = pdist([single_face(2,:);single_face(6,:)], 'euclidean');
left_dist_2  = pdist([single_face(3,:);single_face(5,:)], 'euclidean');
right_dist_1 = pdist([single_face(8,:);single_face(12,:)], 'euclidean');
right_dist_2 = pdist([single_face(9,:);single_face(11,:)], 'euclidean');
avg_dist = mean([left_dist_1, left_dist_2, right_dist_1, right_dist_2]);

end

