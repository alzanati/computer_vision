function  showSnake(C, img, betaStart, contor)
  
  % number of iterations according number of points
  it = size(C, 1);
  
  % if number points less than 200 make step is one
  if it < 200 
      step = 1; 
  else
      step = floor(it/100); 
  end

  for i = 0:step:it
    
    cla; % clear graphic seen
    if( contor == 'show' )
      imshow(img);
    end  
    
    hold on; % add points to the same image
    
    if it == 1
        title('\fontsize{13}\fontname{Monospaced} Initial snake');
        points = C{1}; 
    else
        if i == 0 
            points = C{i+1}; 
            title(['\fontsize{13}\fontname{Monospaced} Iteration number: ', num2str(i+1)]);
        else
            points = C{i}; title(['\fontsize{13}\fontname{Monospaced} Iteration number: ', num2str(i)]);
        end
    end
    
    % Plot lines between points 
    plot(points(1,:), points(2,:), ... 
        '-g', ... 
        'LineWidth', 3);

    plot([points(1,end) points(1,1)], [points(2,end) points(2,1)], ... 
        '-g', ... 
        'LineWidth', 3);
        
    % Plot points, change colour of points where % the beta value is relaxed 
    for j = 1:size(points, 2);
        
      if size(points, 1) == 2 
          plot(points(1,j), points(2,j), ...
              'o', ... 
          'MarkerSize', 7, ...
          'MarkerFaceColor', 'b', ... 
          'MarkerEdgeColor', 'b');

      elseif points(4,j) ~= betaStart
          plot(points(1,j), points(2,j), ...
              'o', ... 
              'MarkerSize', 7, ...
              'MarkerFaceColor', 'r', ...
              'MarkerEdgeColor', 'r'); 
      else
          plot(points(1,j), points(2,j), ...
              'o', ...
              'MarkerSize', 7, ...
              'MarkerFaceColor', 'b', ...
              'MarkerEdgeColor', 'b');
      end

    end
  
  % Delay between each iteration 
  pause(0.005);

end