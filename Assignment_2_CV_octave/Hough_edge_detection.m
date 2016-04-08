I = imread('cameraman1.png');
% if size(I, 3) > 1
% I = rgb2gray(I);
% end
rotI = imrotate(I,33,'crop');
%imshow(rotI)
% Find the edges in the image 
BW = edge(rotI,'canny');
imshow(BW);

%Compute the Hough transform of the binary image returned by Canny.
%[H,theta,rho] = hough(BW);

[imgHeight,imgWidth]=size(BW);
distMax=round(sqrt(imgHeight^2 + imgWidth^2)); %maximum possible rho value
theta = -90:1:90 ;
rho = -distMax:1:distMax;

H = zeros(length(rho),length(theta)); %accumalator array

%start scannig
for ix=1:imgWidth
    for iy=1:imgHeight
        if BW(iy,ix)~= 0
            
            for iTheta =1:length(theta)
                t= theta (iTheta)*pi/180;
                dist =ix*cos(t)+ iy*sin(t);
                [d,iRho] = min(abs(rho-dist));
                
                if d<=1
                    H(iRho,iTheta)= H(iRho,iTheta)+1;
                end
                
            end
          
        end
        
    end
end



%Display the transform, H, returned by the hough function.
figure
imshow(imadjust(mat2gray(H)),[],...
       'XData',theta,...
      'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal
hold on
colormap(hot)

%Find the peaks in the Hough transform matrix, H, using the houghpeaks
P = houghpeaks(H,5,'threshold',30);

%Superimpose a plot on the image of the transform that identifies the peaks.

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');
lines = houghlines(BW,theta,rho,P,'FillGap',10,'MinLength',5);

figure, imshow(rotI), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');