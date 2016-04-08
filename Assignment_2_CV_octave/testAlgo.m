% test snake algorithm
[init, final] = main( 'greedy', 'user', 'off', 'CTPhantom.jpg', 1.2, 5, 1.2, 5, 3, 50);

% obtain chain code
chain_code = chainCode( final, 20 );

% calculate area of points
X = final( 1, : );
%X = X / max( X );

Y = final( 2, : );
%Y = Y / max(Y);

area = polyarea( X, Y);