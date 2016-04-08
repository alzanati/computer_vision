function [ chain_code ] = chainCode( points, threshold )
  
  % number of points, 
  [m ,n] = size( points );
  
  % crop points
  cropped = points( 1:2, 1:n );
  
  % theta and chain_code vectors
  theta = zeros(1, n);
  chain_code = zeros(1, n);
  
  % for loop for each point in vector
  for i = 1 : n
    
    % remove indecies problem
    if( i == n )
      i = 1;
    end
    
    % make sure no index outside vector
    i = mod(i, n);
    
    % read prevois x,y
    cx1 = cropped(1, i);
    cy1 = cropped(2, i);
    cx2 = cropped(1, i+1);
    cy2 = cropped(2, i+1);
    
    % difference of x and y
    tmpx = cx1 - cx2;
    tmpy = cy1 - cy2;
    
    % offest to detect direction
    offest = 0;
    
    % detect direction of x & y 
    if( tmpx < 0  && tmpy < 0)
      offest = 0;
    elseif( tmpx > 0 && tmpy < 0 )
      offest = 90;
    elseif( tmpx < 0 && tmpy > 0 )
      offest = 180;
    elseif( tmpx > 0 && tmpy > 0 )
      offest = 270;
    end
    
    % calculate angle
    theta(i) = atan( abs( tmpx ) / abs( tmpy ) );
    theta(i) = rad2deg( theta(i) );
    
    % offest to detect which direction of theta
    theta(i) = theta(i) + offest;
    
    % angles after threshold
    angle1 = 90 - threshold;
    angle2 = 90 + threshold;
    angle3 = 180 - threshold;
    angle4 = 180 + threshold;
    angle5 = 270 - threshold;
    angle6 = 270 + threshold;
    angle7 = 360 - threshold;
    
    % fill chain code vector with spacified angle 
    if( theta(i) > 0 && theta(i) < threshold )
      chain_code(i) = 0;
    elseif( theta(i) > threshold && theta(i) < angle1 )
      chain_code(i) = 1;
    elseif( theta(i) > angle1 && theta(i) < angle2 )
      chain_code(i) = 2;
    elseif( theta(i) > angle2 && theta(i) < angle3 )
      chain_code(i) = 3;
    elseif( theta(i) > angle3 && theta(i) < angle4 )
      chain_code(i) = 4;
    elseif( theta(i) > angle4 && theta(i) < angle5 )
      chain_code(i) = 5;
    elseif( theta(i) > angle5 && theta(i) < angle6 )
      chain_code(i) = 6;
    elseif( theta(i) > angle6 && theta(i) < angle7 )
      chain_code(i) = 7;
    end
  end
end

function [x] = rad2deg( degree )
    x = (degree * 180) / pi;
    x = ceil(x);
end