function [r,c]=harris_2(input)
% only luminance value
    input=imread(input);
    grayImage = rgb2gray(input);
    im = double(grayImage(:,:,1));
    sigma = 1.5;

    % derivative masks
    s_D = 0.7*sigma;
    x  = -round(3*s_D):round(3*s_D);
    dx = x .* exp(-x.*x/(2*s_D*s_D)) ./ (s_D*s_D*s_D*sqrt(2*pi));
    dy = dx';

    % image derivatives
    % Get the gradient of the image [Ix,Iy], using the convulation function
    Ix = conv2(im, dx, 'same');
    Iy = conv2(im, dy, 'same');

    % sum of the Auto-correlation matrix
    s_I = sigma;
    g = fspecial('gaussian',max(1,fix(6*s_I+1)), s_I);
    Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g, 'same');

    % interest point response
    %cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);				% Alison Noble measure.
    k = 0.06;
    cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;	% Original Harris measure.

    % find local maxima on 3x3 neighborgood
    mask  = fspecial('gaussian',3*s_I)>0;
    nb    = sum(mask(:));
    highest          = ordfilt2(cim, nb, mask);
    second_highest   = ordfilt2(cim, nb-1, mask);
    index            = highest==cim & highest~=second_highest;
    max_local        = zeros(size(cim));
    max_local(index) = cim(index);
    [row,col]        = find(index==1);

    % set threshold 1% of the maximum value
    t = 0.01*max(max_local(:));

    % find local maxima greater than threshold
    [r,c] = find(max_local>=t);

    image(input); hold on;
    plot(c,r,'*')
    end