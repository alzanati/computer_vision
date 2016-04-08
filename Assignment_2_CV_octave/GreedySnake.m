function [cellArray] = GreedySnake( points, img, alpha, beta, gamma, s, sigma, maxIt )
  % Set the curvature threshold 
  % elasticity : does not bunch up in places with high image energy. 
  cThreshold = 0.3;

  % Set the image energy threshold because we substract from this energy
  imgEnrgT = 120;

  % Define counter for the number of iterations 
  counter = 0;

  % Initialize the alpha, beta and gamma values for each snake point
  points(3,:) = alpha; 
  points(4,:) = beta; 
  points(5,:) = gamma;

  % Round indices of snake points 
  points(1:2,:) = round(points(1:2,:));

  % Get the image energy with specific sigma
  enrgImg = getImgEnrg(img, sigma);

  % Get number of points in the snake 
  n = size(points, 2);

  % Get average distance between points 
  avgDist = getAvgDist(points, n);

  % Calculate the area of the vicinity or neighborhood
  a = s^2;
  
  % Calculate the distance in each direction from the center of the vicinity 
  dist = floor(s/2);
  
  % Calculate the offsets needed when examining the vicinity 
  tmp = repmat(( (1:s)-s+dist ), s, 1); 
  offsets = [reshape(tmp, a, 1) reshape(tmp, a, 1)];
  
  % Get subscript indices corresponding to the linear indices of the vicinity 
  [I,J] = ind2sub([s,s],1:a);
  
  % Preallocations for increased code efficiency 
  Econt = zeros(1,a); 
  Ecurv = zeros(1,a); 
  Eimg = zeros(1,a); 
  c = zeros(1,n); 
  cellArray = cell(maxIt, 1);
  
  % Main loop that evolves the snake 
  flag = true;
  
  while flag
    % Counter for the number of points moved 
    pointsMoved = 0;

    % Iterate through all snake points randomly 
    p = randperm(n); 
    for i = p(1:n)
      % Use modulo arithmetic since the curve is closed 
      [modI, modIminus, modIplus] = getModulo(i, n);
      % Extract pixels in the neighborhood of the current snake point 
      neighborhood = enrgImg((points(2, modI)-dist):(points(2, modI)+dist), ... 
                             (points(1, modI)-dist):(points(1, modI)+dist));
      % Normalise the image energy as suggested in the article 
      % [Williams & Shah - 1992] 
      enrgMin = min(min(neighborhood)); 
      enrgMax = max(max(neighborhood)); 
      if (enrgMax - enrgMin) < 5 
          enrgMin = enrgMax - 5; 
      end
      normNeigh = (enrgMin - neighborhood) / (enrgMax - enrgMin);

      % Calculate energy terms for all pixels in the neighborhood
      for j = 1:a
        % Current position
        pos = points(1:2,i) + offsets(j,:)';
        % Calculate the continuity term 
        Econt(j) = abs(avgDist - norm(pos - points(1:2, modIminus)));
        % Calculate the curvature term 
        Ecurv(j) = norm(points(1:2, modIminus) - 2*pos + points(1:2, modIplus))^2;
        % Calculate the image energy term 
        Eimg(j) = normNeigh(I(j), J(j));
      end

      % Normalize the continuity and curvature terms to lie in the range [0,1] 
      Econt = Econt / max(Econt); 
      Ecurv = Ecurv / max(Ecurv);
      % Sum the energy terms 
      Esnake = points(3,i)*Econt + points(4,i)*Ecurv + points(5,i)*Eimg;
      % Find the location of minimum energy in the neighborhood 
      [dummy,indexMin] = min(Esnake);
      % If we have a new point 
      if ceil(a/2) ~= indexMin
        % Move point to new location
        points(1:2, modI) = points(1:2, modI) + offsets(indexMin,:)';
        % Increment counter 
        pointsMoved = pointsMoved + 1;
      end
      % Store the value of the image energy 
      points(6, modI) = neighborhood(I(indexMin),J(indexMin));
    end
    
    % Iterate through all snake points to find curvatures 
    for i = 1:n
      % Use modulo arithmetic since the curve is closed 
      [modI, modIminus, modIplus] = getModulo(i, n);
      % Estimate the curvature at each point 
      ui = points(1:2, modI) - points(1:2, modIminus); 
      uiPlus = points(1:2, modIplus) - points(1:2, modI); 
      c(i) = norm( ui/norm(ui) - uiPlus/norm(uiPlus) )^2;
    end
    
    % Iterate through all snake points to find where to relax beta 
    for i = 1:n
      % Use modulo arithmetic since the curve is closed 
      [modI, modIminus, modIplus] = getModulo(i, n);
      if ( c(modI) > c(modIminus) && ... 
              c(modI) > c(modIplus) && ... 
              c(modI) > cThreshold && ... 
              points(6, modI) > imgEnrgT && ... 
              points(4, modI) ~= 0 )
          
      points(4, modI) = 0; 
      disp(['Relaxed beta for point nr. ', num2str(i)]);
    end
  end
  
  counter = counter + 1; 
  cellArray(counter) = {points};
  
  if (counter == maxIt || pointsMoved < 3) 
      flag = false; 
      cellArray = cellArray(1:counter); 
  end
  
  avgDist = getAvgDist(points, n);
end
