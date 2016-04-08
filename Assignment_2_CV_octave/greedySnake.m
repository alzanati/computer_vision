function [x, y, it] = greedySnake( Im, x, y, Alpha, Beta, Gamma, Threshold, 
                                   windowSize, totalIterations, Sigma )
if( nargin < 3 )
  error('number of argument less than 3');
end

% get number of points
[n, m] = size(x);

% detect edges
ii = rgb2gray(Im);
Imf = edge(ii, Sigma);

% convert angle to rad in the threshold 
Threshold(1) = (2 * sin( deg2rad( Threshold(1) ) / 2 ))^2;

%initialize coeffecint vectors
Alphas = ones(n, 1) * Alpha;
Betas = ones(n, 1) * Beta;
Gammas = ones(n, 1) * Gamma;

% currnet iteration number
iteration = 0;

% Compute average distance between points
d = davg(x, y);
        
% infinity because we will subtract from it
movedPts = inf;

% start algorithm untill moved points less than totalIterations of points
while ( movedPts > totalIterations )
    iteration = iteration + 1;
    
    % update location to each point
    for( i = 1:n )
      % get old and new points with circular shift to know new postion 
      % relative to old position in a vector
      oldX = circshift(x, 1); oldY = circshift(y, 1);
      newX = circshift(x, -1); newY = circshift(y, -1); 
      
      % Compute energy terms for neighborhood points
      % by applying snakes equations
      eCont = econtinuity(x(i), y(i), oldX(i), oldY(i), windowSize, d);
      eCurv = ecurvature(x(i), y(i), oldX(i), oldY(i), newX(i), newY(i), windowSize);
      eImg  = eimage(x(i), y(i), windowSize, Imf);
      
      % compute total energy
      eTotal = Alphas(i) * eCont + Betas(i) * eCurv + Gammas(i) * eImg;
      
      % Find point in neighborhood of minal energy.
      [r, c] = find( eTotal == min( min(eTotal)) );
      xPoint = x(i) + (c(1) - (windowSize+1)/2);
      yPoint = y(i) + (r(1) - (windowSize+1)/2);
      
      % Check if the point has moved.
      if (xPoint ~= x(i) || yPoint ~= y(i))
        moved = moved + 1;
      end
          
      % Update the values in the point vectors.
      x(i) = xPoint;
      y(i) = yPoint;
    end
  end
end

function [davg] = davg(x, y)
    % Compute pairwise distance in x and y.
	dx = x - circshift(x, 1);
	dy = y - circshift(y, 1);
        
    % Average the pairwise total distance.
	davg = mean(sqrt(dx.^2 + dy.^2));
end

function [C] = econtinuity(x, y, xp, yp, w, d)
    % Compute half window size.	
    h = (w - 1) / 2;
        
    % Compute X and Y neighborhood matrices.
	  Mx = ones(1, w)' * [-h:1:h] + x;
    My = [-h:1:h]' * ones(1, w) + y;
        
    % Compute position change in x and y.
    Dx = Mx - xp;
    Dy = My - yp;
        
    % Compute squared error from average distance.
	  C = (d - sqrt(Dx.^2 + Dy.^2)).^2;

    % Normalize the result.
    M = max(max(C));
    if M ~= 0
        C = C / M;
    end
end

function [C] = ecurvature(x, y, xp, yp, xn, yn, w)
    % Compute half window size.
	  h = (w - 1) / 2;
        
    % Compute X and Y neighborhood matrices.
    Nx = ones(1, w)' * [-h:1:h] + x;
    Ny = [-h:1:h]' * ones(1, w) + y;

    % Compute curvature change in x and y.
    Cx = xp - 2 * Nx + xn;
    Cy = yp - 2 * Ny + yn;
        
    % Compute curvature norm.
    C = Cx.^2 + Cy.^2;
    
    % Normalize the result.
    M = max(max(C));
    if M ~= 0
        C = C / M;
    end
end

function [E] = eimage(x, y, w, F)
    % Compute half window size.
    h = (w - 1) / 2;
        
    % Select neighborhood of point in filtered image.
    Fpad = padarray(F, [h, h], 0);                        
    E = Fpad(y:y+2*h, x:x+2*h);

    % Normalize the result.
    m = min(min(E));
    M = max(max(E));    
    if M - m ~= 0
        E = (E - m) / (M - m);
    end
    
    % Return negative energies.
    E = -E;
end

function [Imf] = getEdges(Im, sigma)
    % get gaussin coeffeints to create guassin kernel.
    [f, df] = gaussDist(sigma);
    
    % Filter the image in x and y.
	  Imfx = conv2(df, f, Im, 'same');
    Imfy = conv2(f, df, Im, 'same');
    
    % Return the modulus becuase we detect edges in x, then y.
    Imf = sqrt(Imfx.^2 + Imfy.^2);        
end

function [g, dg] = gaussDist(sigma)
    % Create a window of size equal to three standard deviations.
    wsize = ceil(sigma * 3) * 2 + 1;

    % Define functions range.
    r = -(wsize-1)/2:1:(wsize-1)/2;
        
    % Compute gaussian formula.
    c = 1 / (sqrt(2 * pi) * sigma);
    e = exp(-(r.^2) / (2 * sigma^2));
    g  = c .* e;
    dg = c .* (-r / sigma^2) .* e;
end

function [x] = deg2rad( degree )
    x = (degree * pi) / 180;
end