function [positions,tracklist]=HoughTracking2(img,radrange,timerange,plot)

interval=5;
for t=timerange
    img0=img(:,:,t);
    [poslist,cirrad]=HoughList(img0,radrange,plot);
    pause(0.05);
    for k=1:size(poslist,1)
        for m=1:size(poslist,2)
            positions(k,m,t)=poslist(k,m);
        end
    end
    if (mod(t,interval)==0)
        t
    end
end

k=0;
for i=1:size(positions,3)
    for j=1:size(positions,1)
        if (positions(j,1,i)~=0)
            k=k+1;
            tracklist(k,1)=positions(j,1,i);
            tracklist(k,2)=positions(j,2,i);
            tracklist(k,3)=i;
        end
    end
end