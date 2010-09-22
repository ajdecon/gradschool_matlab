function poslist=HoughList(img,radrange)

numim=size(img,3);

for m=1:numim
    [accum,circen,cirrad]=CircularHough_Grd(img(:,:,m),radrange);
    imagesc(img(:,:,m));
    colormap('gray');axis image;hold on;plot(circen(:,1),circen(:,2),'r+');
    for k=1:size(circen,1),DrawCircle(circen(k,1),circen(k,2),cirrad(k),32,'b-');end;hold off;
    
    for x=1:size(circen,1)
        for y=1:size(circen,2)
            cirarray(x,y,m)=circen(x,y);
        end
    end
    
    pause(0.05);
end

poslist=cirarray;