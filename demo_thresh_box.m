function intensities=demo_thresh_box(img)

intensities = zeros( size(img, 3), 2 ); % mean, std

for n=1:size(img,3)
    img0=img(:,:,n);
    
    
    [accum,circen,cirrad]=CircularHough_Grd(img(:,:,10),[11 22]);
    clear boxint;
    
    for c=1:size(circen,1)
     
        r0=floor(cirrad(c));
        x=floor(circen(c,1));
        y=floor(circen(c,2));
        
        clear box;
        
        box=img0(y-r0:y+r0, x-r0:x+r0);
        nbox=niblack(box,2,-0.2);
        obox=im2bw(box,graythresh(box));
        andbox=nbox & obox;
        
        box(andbox==0) = 0;
        
        boxint(c) = sum(sum(box));
        
    end
    
    intensities(n,1) = mean(double(boxint));
    intensities(n,2) = std(double(boxint));
    
    n
end