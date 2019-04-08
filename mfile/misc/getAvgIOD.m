function avgIOD = getAvgIOD(fit)

  total_frame = size(fit,2);
  IOD = zeros(1,total_frame);
  for frame_index = 1 : total_frame 
      single_face = fit(frame_index).pts_2d(20:31,:);
      left_dist   = pdist([single_face(1,:);single_face(7,:)],'euclidean');
      right_dist  = pdist([single_face(4,:);single_face(10,:)],'euclidean');
      current_IOD = mean([left_dist right_dist]);
      IOD(frame)  = current_IOD;
  end
  avgIOD = mean(IOD);

end
