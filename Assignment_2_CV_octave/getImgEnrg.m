% This function to get image energy by apply gaussin filter to image 
% then calculate gradient by sobel filter

function [enrgImg] = getImgEnrg(img, sigma)
  % Get guassin Coeffeints  
  fSize = [ceil(3*sigma) ceil(3*sigma)]; 
  gf = fspecial('gaussian', fSize, sigma);
  
  % Apply Gauss filter to image 
  gaussImg = double(imfilter(img, gf, 'replicate'));
  
  % Get Gradint in image by sobel filter
  fy = fspecial('sobel'); 
  fx = fy; 
  Iy = imfilter(gaussImg, fy, 'replicate'); 
  Ix = imfilter(gaussImg, fx, 'replicate');
  enrgImg = sqrt(Ix.^2 + Iy.^2);
end