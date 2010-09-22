function img=loadrgbtiffstack(fname,numframes)

   for i=1:numframes
       img(:,:,i)=rgb2gray(imread(fname,i));
   end
   