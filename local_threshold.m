function final_result = local_threshold(image0,boxsize)

% Use Otsu's criterion (graythresh) to do pixel-by-pixel local thresholding
% using a defined box size (probably fairly small!).

[Ny,Nx]=size(image0);

image1=zeros(Ny,Nx);
startx=0;
for x=1:Nx
    for y=1:Ny
        if (rem(x,10)==0 && x>startx)
            startx=x
        end
        % if pixel cannot be boxed, set equal to zero (add black borders)
        if ( (y<=boxsize) || (y>=(Ny-boxsize)) || (x<=boxsize) || (x>=(Nx-boxsize)) )
            image1(y,x)=0;
        else            
            box = image0( (y-boxsize):(y+boxsize), (x-boxsize):(x+boxsize) );
            lt = graythresh(box);
            if image0(y,x)>=lt
                image1(y,x) = 1;
            else
                image1(y,x) = 0;
            end            
            
        end
    end
end

final_result = image1;