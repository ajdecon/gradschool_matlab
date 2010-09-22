function result = avg_frames(img,n)

sizeX=size(img,2);
sizeY=size(img,1);
length=size(img,3);

last_frame=1;
framenum=1;

while (last_frame < length)
    last_frame=last_frame+n;
    for x=1:sizeX
        for y=1:sizeY
            
            newimg(y,x,framenum)=mean(img(y,x,(last_frame-n):last_frame));
            
        end
    end
end

result = newimg;