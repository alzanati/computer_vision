I = imread('CTPhantom.jpg');
if size(I, 3) > 1
 I = rgb2gray(I);
end
rotI = imrotate(I,33,'crop');
%imshow(rotI)
% Find the edges in the image 
BW = edge(I,'canny');
imshow(BW);

%Compute the Hough transform of the binary image returned by Canny.
%[H,theta,rho] = hough(BW);

[imgHeight,imgWidth] = size(BW);
distMax = round(sqrt(imgHeight^2 + imgWidth^2)); %maximum possible rho value
theta = -180 : 1 : 180 ;
xo = 1:1:imgWidth;
yo = 1:1:imgHeight;
r = -imgWidth:1:imgWidth;

H = zeros( length(xo), length(yo), length(r) ); %accumalator array

%start scannig

for ix=1:imgWidth
    for iy=1:imgHeight
        if ( BW(iy,ix) ~= 0 )
            
            for iXo = 1:length(xo);
                for iYo = 1:length(yo);
                    iR = sqrt((ix-iXo)^2 + (iy-iYo)^2);
                    H( iXo, iYo, iR ) = H(iXo,iYo,iR) + 1;
                    %[d,iR] = min(abs(r-dist));
                end
                  
            end
          
        end
        
    end
end

Rmin = 30;
Rmax = 65;
%%viscircles(centersBright, radiiBright,'EdgeColor','b');

