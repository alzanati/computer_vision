function[initial_Points, final_Points] = main( type, input, imgName,
                                               alpha, beta, gamma, s, sigma, 
                                               maxIt )

% type: greedy type
% input: input is user or not 
% ssc : scaling is on of off

% Load the image file 
originalImg = imread([imgName]);

  % Convert image to grayScale if necessary 
  fileInfo = imfinfo([imgName]); 
  if strcmp(fileInfo.ColorType, 'truecolor') 
      img = rgb2gray(originalImg); 
  else
      img = originalImg; 
  end
     
  % Counter for the total number of points 
  numPoints = 0;
  
  % If input = user, then let the user input the snake control points
  if strcmpi(input, 'user')
    % Create the input figure window 
    figure('Name', 'Snake: Insert control points', 'NumberTitle', 'off', 'Resize', 'on');
    imshow(originalImg); title('\fontsize{13}\fontname{Monospaced} Click outside of image to finish.');
    hold on;
    
    % Input loop - lets user enter points 
    while (true)
      % Wait for mouse input 
      waitforbuttonpress;
      
      % Get the indices of the new point point 
      newP = get(gca,'CurrentPoint'); 
      newP=newP(1,1:2);
      
      % Check if point is outside of the image 
      if (newP(2)>size(img, 1) || newP(1)>size(img, 2) || ... 
              newP(2)< 1 || newP(1)< 1) 
          break; 
      end
      numPoints = numPoints + 1;
      points(1, numPoints)=(newP(1));
      points(2, numPoints)=(newP(2));
      
      % Plot the new control point
      plot(points(1, numPoints),points(2, numPoints), ... 
          'o', ...
          'MarkerSize', 5, ... 
          'MarkerFaceColor', 'b', ... 
          'MarkerEdgeColor', 'b');
    end

  % if fixed points can be removed not affect the overall code
  else
    % Plot the snake as a circle around the object in the image
    % Circle radius 
    r = 70;
    % Cicle center [x y] 
    c = [150 110];
    % Number of points in the snake 
    N = 50;
    % Calculate snake points in a circle 
    points(1, :) = c(1)+floor(r*cos((1:N)*2*pi/N)+0.5); 
    points(2, :) = c(2)+floor(r*sin((1:N)*2*pi/N)+0.5);
  end
  
  % points of initial contor
  C = { points };
  initial_Points = points;
  
  % Show initial snake 
  showSnake(C, originalImg, beta, 'hide'); 
  pause(0.1); 
  figure;
  % Run the snake algorithm 

      if strcmpi(type, 'greedy') 
      % alpha = 1.2; beta = 1; gamma = 1.2; s = 5; sigma = 3; maxIt = 136;
      
      C = GreedySnake(points, img, alpha, beta, gamma, s, sigma, maxIt); 
      end
      
      % show parameters
      fprintf('\n');
      fprintf('Running %s snake with following parameters: \n', type);
      fprintf('Alpha: %d \n', alpha); 
      fprintf('Beta: %d \n', beta); 
      fprintf('Gamma: %d \n', gamma); 
      fprintf('Neighborhood size: %d \n', s); 
      fprintf('Sigma: %d \n, sigma); fprintf(Max iterations: %d \n', maxIt);
      fprintf('Scale space continuation: %s \n', ssc);
  end

  % Show snake evolution
  final_Points = C{ maxIt }; 
  showSnake(C, originalImg, beta, 'show');

end