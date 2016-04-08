%%The Process of Canny edge detection algorithm can be broken down to 5 different steps:
%Apply Gaussian filter to smooth the image in order to remove the noise
%Find the intensity gradients of the image
%Apply non-maximum suppression to get rid of spurious response to edge detection
%Apply double threshold to determine potential edges
%Track edge by hysteresis: Finalize the detection of edges by suppressing all the other edges that are weak and not connected to strong edges.

function [ Gmag, angles ] = Canny_edge_detector ( IMG, thresh_h, thresh_l )
   Img = imread( IMG );
   
   %apply gaussian filter
   IMGgray=rgb2gray(Img);
   F = fspecial( 'gaussian', [10 10] );
   IMGblur = imfilter( IMGgray,F,'conv' );
   
   %get gradient magnitude and angles
   [Gmag, Gdir] = imgradient(IMGblur,'sobel');
   
   %make angles from 0----->360
   phase_repair=ones(600,868)*180;
   angles= Gdir + phase_repair;
   
   %non maximal suppression
   [m ,n] = size(angles);
   
%rounding angles to be 0,45,90,135,180,225.270,315,360
  for i = 1 : m
      for j= 1 :n
          if ( angles(i,j)<=22.5 && angles(i,j)>=0 )
              angles(i,j)=0;
          elseif(angles(i,j)>22.5 && angles(i,j)<=45 )
              angles(i,j)=45;
          elseif(angles(i,j)>45 && angles(i,j)<=67.5)
              angles(i,j)=45;
          elseif(angles(i,j)>67.5 && angles(i,j)<=90)
              angles(i,j)=90;
          elseif(angles(i,j)>90 && angles(i,j)<=112.5)
              angles(i,j)=90;
          elseif(angles(i,j)>112.5 && angles(i,j)<=135)
              angles(i,j)=135;
          elseif(angles(i,j)>135 && angles(i,j)<=157.5)
              angles(i,j)=135;
          elseif(angles(i,j)>157.5 && angles(i,j)<=180)
              angles(i,j)=180;
          elseif(angles(i,j)>180 && angles(i,j)<=202.5)
              angles(i,j)=180;
          elseif(angles(i,j)>202.5 && angles(i,j)<=225)
              angles(i,j)=225;
          elseif(angles(i,j)>225 && angles(i,j)<=247.5)
              angles(i,j)=225;
          elseif(angles(i,j)>247.5 && angles(i,j)<=270)
              angles(i,j)=270;
          elseif(angles(i,j)>270 && angles(i,j)<=292.5)
              angles(i,j)=270;
          elseif(angles(i,j)>292.5 && angles(i,j)<=315)
              angles(i,j)=315;
          elseif(angles(i,j)>315 && angles(i,j)<=337.5)
              angles(i,j)=315;
          elseif(angles(i,j)>337.5 && angles(i,j)<=360)
              angles(i,j)=360;
          end
      end
  end

%finding local maxima
  for u= 2 : m-1
      for v= 2 : n-1
          if(angles(u,v)==0 || angles(u,v)==180 || angles(u,v)==360)
              if(Gmag(u,v)< Gmag(u,v-1) || Gmag(u,v)<Gmag(u,v+1) )
                  Gmag(u,v)=0;
              end
          elseif(angles(u,v)==90 || angles(u,v)==270)
              if(Gmag(u,v)< Gmag(u-1,v) || Gmag(u,v)<Gmag(u+1,v) )
                  Gmag(u,v)=0;
              end
          elseif(angles(u,v)==45 || angles(u,v)==225 )
              if(Gmag(u,v)<Gmag(u-1,v+1) || Gmag(u,v)<Gmag(u+1,v-1) )
                  Gmag(u,v)=0;
              end
          elseif(angles(u,v)==135 || angles(u,v)==315 )
              if(Gmag(u,v)<Gmag(u-1,v-1) || Gmag(u,v)<Gmag(u+1,v+1) )
                  Gmag(u,v)=0;
              end
          end
      end
  end
  
%double thresholding   
  for w= 1: m
      for e= 1: n
          if(Gmag(w,e)>thresh_h)
              Gmag(w,e)=708.0452;
          elseif(Gmag(w,e)<thresh_l)
              Gmag(w,e)=0;
          end
      end
  end


% figure; imshowpair(Gmag, Gdir, 'montage');
% title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')
% axis off;



end
