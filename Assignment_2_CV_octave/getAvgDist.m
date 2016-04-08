% This function calculate average distance between controls points
% Which is used in 

function [avgDist] = getAvgDist(points, n) 
  sum = 0;

  % calculate difference current point and next point in contor
  for i = 1:n 
      sum = sum + norm(points(1:2, i) - points(1:2, mod(i,n)+1));
  end
  
  % normalize values
  avgDist = sum / n;

end