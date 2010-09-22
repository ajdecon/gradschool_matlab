function img=loadtiffstack(fname,numframes)

   for i=1:numframes
       img(:,:,i)=imread(fname,i);
   end
   