% stack_intensity
%   Adam DeConinck, 26 Nov 2009
%
% Performs calculations on a single region in a stack of multiple images.
%
% To read in a TIFF image stack:
%  for i=1:num_images, imgstack(:,:,i)=imread('filename.tif',i);end;
%
% To run this function:
%  result = stack_intensity( imgstack(ymin:ymax, xmin:xmax, : ) );
%
% where the region you want to examine is bounded by the corner points
% (xmin,ymin) and (xmax,ymax).
% 
% The result variable is laid out in the following columns:
%  result(:,1) = image number
%  result(:,2) = mean intensity
%  result(:,3) = median intensity
%  result(:,4) = max intensity
%  result(:,5) = min intensity
%
% To plot (for example) mean intensity vs image number:
%  plot( result(:,1), result(:,2) );

function result = stack_intensity(imgstack)

for i=1:size(imgstack,3)
  img = imgstack(:,:,i);
  result(i,1)=i;
  result(i,2)=mean(mean(img));
  result(i,3)=median(median(img));
  result(i,4)=max(max(img));
  result(i,5)=min(min(img));
end;
