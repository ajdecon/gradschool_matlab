function result = intensity_at_points(img, xylist, radius)

numpts=size(xylist,1);
imgnum=size(img,3);

for i=1:imgnum
    
    for j=1:numpts
        
        x0=xylist(j,1);
        y0=xylist(j,2);
        
        sum=0.0;
        npts=0;
        for x=(x0-radius):(x0+radius)
            for y=(y0-radius):(y0+radius)
                
                r=sqrt( (x-x0)^2 + (y-y0)^2 );
                if (r<=radius)
                    npts=npts+1;
                    sum=sum+double(img(floor(y),floor(x),i));
                end
            end
        end
        
        result(j,i)=sum/double(npts);
        %result(j,i)=img(y0,x0,i);
        
        %result(i,j,2)=sum;
        %result(i,j,3)=npts;
        
    end
    
end

