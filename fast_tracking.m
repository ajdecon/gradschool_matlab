function ints=fast_tracking(img,positions,box)

ints=[];
b=floor(box/2);
k=0;

for f=1:size(img,3)
    
    for n=1:size(positions,1)
        
        x0=positions(n,1);
        y0=positions(n,2);
        
        intensity = mean( mean( img( y0-b:y0+b, x0-b:x0+b, f)));
        %intensity = sum( sum( double(img( y0-b:y0+b, x0-b:x0+b, f)) ));
        
        k=k+1;
        ints(k,1)=x0;
        ints(k,2)=y0;
        ints(k,3)=intensity;
        ints(k,4)=f;
        ints(k,5)=n;
    end
end