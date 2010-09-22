function fimg=extract_circles_1img(img1,circen,cirrad)

for i=1:size(circen,1)
    x=floor(circen(i,1));
    y=floor(circen(i,2));
    r=19;
    fimg(:,:,i)=img1( (y-r):(y+r), (x-r):(x+r) );
end;

for i=1:size(fimg,3)
    
    x=floor(size(fimg,2)/2)+1;
    y=floor(size(fimg,1)/2)+1;
    
    imagesc(fimg(:,:,i));
    colormap('gray');axis image;hold on;
    plot(x,y,'r+');
    DrawCircle(x,y,cirrad(i),32,'b-');
    pause;
    hold off;
    
end