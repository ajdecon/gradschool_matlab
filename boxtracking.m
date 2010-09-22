function [rboxes,rthresholds,rmasks,rmasked]=boxtracking(img)

r=19;
r1=18;
r2=15;
radrange=[11 22];

for f=1:size(img,3)
    clear boxes masks obw masked;
    
    I=img(:,:,f);
    
    [accum,circen,cirrad]=CircularHough_Grd(I,radrange);    
    
    for n=1:size(circen,1)
        x=floor(circen(n,1));
        y=floor(circen(n,2));
        boxes(:,:,n)=I(y-r:y+r, x-r:x+r);
    end
    if (exist('boxes')) 
        ;
    else 
        continue;
    end
        
    for n=1:size(boxes,3)
        obw(:,:,n)=im2bw(boxes(:,:,n), graythresh(boxes(:,:,n)));
    end
    
    x0=(size(obw,1)-1)/2; y0=(size(obw,2)-1)/2;
    
    mask=obw;
    for n=1:size(obw,3)
        for x=1:size(obw,1)
            for y=1:size(obw,2)
                d=sqrt( (x-x0)^2 + (y-y0)^2 );
                if ( (d>r1) || (d<r2) )
                    mask(y,x,n)=0;
                end
            end
        end
    end
    
    masked=boxes;
    masked(mask==0)=0;
    
    for n=1:size(masked,3)
        ints(n)=sum(sum(masked(:,:,n)));
    end
    
    % save data
    rmasks{f}=mask;
    rboxes{f}=boxes;
    rthresholds{f}=obw;
    rmasked{f}=masked;
end