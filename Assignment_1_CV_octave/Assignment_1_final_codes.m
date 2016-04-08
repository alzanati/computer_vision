pkg load image
%%% A %%%
%% 1 %%
% Unifrom Noise %
clear
IMG = imread('peppers.png');
for i = 1:length (IMG(:)')
    C(i) = IMG(i) / 30 + 20 * log2( IMG(i) ) ;
end
c = transpose (C);
row = rows( IMG );
col = columns( IMG);
uniform_noise_image = reshape ( c, [ row, col, 3]); % map sizes of noise to image
imshow(uniform_noise_image);
title('Uniform noise');

% Gaussian Noise  with guassian mean = 0, variance = 0.2%
IMG = imread('peppers.png');
gaussing_noise_image = imnoise ( IMG, 'gaussian', 0, 0.1 );
subplot(2,2,2)
imshow(gaussing_noise_image);
title('Gaussin noise');

% salt & pepper noise with density 0.2 %
IMG = imread('peppers.png');
salt_pepper_noise_image = imnoise ( IMG, 'salt & pepper', 0.2 ); 
subplot(2,2,3)
imshow(salt_pepper_noise_image);
title('salt & pepper noise');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 %%
% Average filter to uniform_noise_image %
figure
F = fspecial ( 'average', 2 ); % create average kernel
gaussing_noise_image_filterd = imfilter ( gaussing_noise_image , F, 'conv'); % filter by convolution
subplot(2,2,1)
imshow(gaussing_noise_image);
title('salt & pepper noise');
subplot(2,2,2)
imshow(gaussing_noise_image_filterd);
title('salt & pepper avrage filter');

% gaussian filter to Gaussian Noise %
F = fspecial( 'gaussian', 3, 3 ); % This kernel is an approximation of a Gaussian function
gaussing_filtered = imfilter( gaussing_noise_image, F, 'conv' );
subplot(2,2,3)
imshow(gaussing_noise_image);
title('gaussing noise image');
subplot(2,2,4)
imshow(gaussing_filtered);
title('gaussian filtered');

figure
% median Filter %
I = imread('cameraman1.png'); 
J = imnoise(I,'salt & pepper',0.02); % add noise
FF = [1 1 1; 1 1 1; 1 1 1];
K = medfilt2( J, FF ); % filter noise with 3 * 3 ones
subplot(1,2,1);
imshow( J );
subplot(1,2,2);
imshow( K );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 %%
% Edge Detectors %
figure
I = imread('cameraman1.png');
imshow( I )

% Beware of the image noise! Smooth the image with a low-pass
% filter prior to computing the gradient.

F = fspecial( 'gaussian', 3, 3 );
gaussing_filtered = imfilter( I, F, 'conv' );

% Edge points are defined as points where the length of the gradien
% with threshold 4 * mean of image gradients
sobel_edge_detection = edge(I,'sobel'); 

% Roberts approximation to the derivatives
roberts_edge_detection = edge(I,'Roberts'); % threshold = 6 * mean_gradient_of_image

% kernel first-order derivative
% 3×3 neighborhood using convolution
prewitt_edge_detection = edge(I,'Prewitt');

canny_edge_detection = edge(I,'Canny');

figure
subplot(2,2,1)
imshow(sobel_edge_detection);
title('Sobel');

subplot(2,2,2)
imshow(roberts_edge_detection);
title('Roberts');

subplot(2,2,3)
imshow(prewitt_edge_detection);
title('Roberts');

subplot(2,2,4)
imshow(canny_edge_detection);
title('Canny');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure

%% 4 %% 
% histogram %
img = imread('Linda.jpg');
subplot(2,2,1);
imshow( img );
title('original');

[count,bin] = hist(img(:), 0:1:255 );
subplot(2,2,2);
plot(bin,count);
title('Distribution Curve');

subplot(2,2,3);
hist (img, 'facecolor', 'r', 'edgecolor', 'b');
title('histogram');
subplot(2,2,4);
stem(bin,count, 'Marker','none');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5 %%
% Equalize Image %
figure
img = imread('peppers.png');
subplot(2,2,1)
xx = rgb2gray(img);
imshow(xx);
subplot(2,2,2)

% compute histogram and numbers of elements ( count ) with centers ( bin )
[count,bin]=hist( xx (:), 0:1:255 );
stem(bin,count, 'Marker','none');
title('Before Equalization'); 

subplot(2,2,3)
xx = rgb2gray(img);
heq = histeq(xx);
imshow(heq);
subplot(2,2,4)
[count,bin]=hist(255 * heq(:),0:1:255);
hAx = gca;
set(hAx, 'XLim',[0 255], 'XTickLabel',[], 'Box','on')
stem(bin,count, 'Marker','none');
title('After Equalization');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6 %%
% Normalize Image %
figure
img = imread('peppers.png');

  if( isgray( img ) == true )
    subplot(1,2,1)
    imshow(img);
    title('Before Normalization');
    normalizedImage = uint8( 120 * mat2gray(img) );
    subplot(1,2,2)
    imshow(normalizedImage);
    title('After Normalization');
  else
    subplot(1,2,1)
    imshow(img);
    title('Before Normalization');
    old_min = min( min(img) );
    old_max = max( max(img) );
    y = uint16(22000 .* ((double(img)-double(old_min))) ./ double(old_max-old_min));
    subplot(1,2,2)
    imshow(y);
    title('After Normalization');
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7 %%
% global thresholding % 
figure
img1 = imread('Linda.jpg');
level = graythresh( img1 );
global_threshold = im2bw( img1, level );
imshow( global_threshold );

% local thresholding %
img = imread('Linda.jpg');
[r c]= size( img );
part1 = img( 1 : (r/2), 1 : (c/2) );
part2 = img( 1 : (r/2), 1 + (c/2) :c );
part3 = img( 1 + (r/2) : r, 1 : (c/2) );
part4 = img( 1 + (r/2) : r, 1 : 1+ (c/2));

level = graythresh( part1 ); % optimal threshold value LEVEL
local_threshold = im2bw( part1, level );
imshow( local_threshold );

level = graythresh( part2 );
local_threshold = im2bw( part2, level );
imshow( local_threshold );

level = graythresh( part3 );
local_threshold = im2bw( part3, level );
imshow( local_threshold );

level = graythresh( part4 );
local_threshold = im2bw( part4, level );
imshow( local_threshold );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8 %%
% Transformation %
figure
img = imread('images.jpg');
gray_image = rgb2gray(img);
subplot(2,2,1);
imshow(gray_image)

red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);

subplot(2,2,2);
hist(red, 0:1:255, 'edgecolor', 'r');
[count,bin]=hist(red(:),0:1:255);
hAx = gca;
set(hAx, 'XLim',[0 255], 'XTickLabel',[], 'Box','on')
stem(bin,count, 'Marker','none','color', 'red');
title('red');

subplot(2,2,3);
[count,bin]=hist(green(:), 0:1:255);
hAx = gca;
set(hAx, 'XLim',[0 255], 'XTickLabel',[], 'Box','on')
stem(bin,count, 'Marker','none','color', 'green');
title('green');

subplot(2,2,4);
[count,bin]=hist(blue(:), 0:1:255, 'edgecolor', 'b');
hAx = gca;
set(hAx, 'XLim',[0 255], 'XTickLabel',[], 'Box','on')
stem(bin,count, 'Marker','none', 'color', 'blue');
title('blue');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 9 %%%
%% Frequency domain Filters %%
figure

% Gausian Low Pass Filter %
IMG = imread('cameraman1.png');
F = fspecial( 'gaussian', 256,30);
F1=mat2gray(F);
fft_IMG = fftshift( fft2(IMG) );
F_IMG = (fft_IMG.*F1);
subplot(2,2,1);
fftShow(F_IMG);
title('LPF FFT');

Filtered_IMG=ifft2(F_IMG);
subplot(2,2,2);
fftShow(Filtered_IMG);
title(' Filtered Image ');

% High PAss Filter %
[x,y]=meshgrid(-128:127, -128:127);
z = sqrt( x.^2+y.^2 );
f = z>15;
IMG = imread('cameraman1.png');
fft_IMG = fftshift(fft2(IMG));
Filtered_IMG_fD = fft_IMG.*f;
subplot(2,2,3);
fftShow(Filtered_IMG_fD );
title('HPF FFT');

Filtered_IMG=ifft2(Filtered_IMG_fD);
subplot(2,2,4);
fftShow(Filtered_IMG);
title(' Filtered Image ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 10 %%%
%% hybird %%
figure 
img2 = imread('images.jpg');
img1 = imread('peppers.png');

% LPF %
LPF = fspecial( 'gaussian', [10 10], 0.2 );
gaussian_filter = imfilter( img1, LPF, 'conv' );
subplot(2,2,1);
imshow(gaussian_filter);
title(' LPC ');

% HPF %
HPC = fspecial( 'laplacian', [3 3] );
laplacian_filter = imfilter( img2, HPC, 'conv' );
subplot(2,2,2);
imshow(laplacian_filter);
title(' HPC ');

% resize two perform hybird image summtion %
hybrid_guassain = imresize ( gaussian_filter, [256 256]);
hybrid_laplacin = imresize ( laplacian_filter,[256 256]);

% show hybird img %
hybird_img = hybrid_guassain + hybrid_laplacin ;
figure
imshow( hybird_img );
title(' Hybird Image ');

clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot fft %
function [ sImg ] = fftShow(img)
%   This function displays the given fft image

    sImg = log(abs(img)+1);
    sImg = sImg/max(max(sImg));
    imshow(sImg)
end