function result=average_intensity(img,mask,r)

[x0,y0]=centerpos(mask);

sizex=size(img,2);
sizey=size(img,1);

pxcount=0.0;
intensity=0.0;

for i=1:sizex
    for j=1:sizey
        
        distance=sqrt( (i-x0)^2 + (j-y0)^2 );
        if (distance <= r)
            pxcount = pxcount + 1;
        end
    end
end

for i=1:sizex
    for j=1:sizey
        
        distance=sqrt( (i-x0)^2 + (j-y0)^2 );
        if (distance <= r)
            intensity = intensity + img(j,i)/pxcount;
        end
    end
end


result = intensity;
