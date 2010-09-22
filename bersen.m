function final_result = bersen(img,boxsize,ct)

% Implements Bersen contrast threshold.
[Ny,Nx]=size(img);

timg=zeros(Ny,Nx);
w=round((boxsize-1)/2);

for y=(2+w):(Ny-w-1)
    for x=(2+w):(Nx-w-1)
        
        %pixel=img(y,x);
        box=img( (y-w):(y+w), (x-w):(x+w) );
        contrast=max(max(double(box))) - min(min(double(box)));
        if contrast>ct
            timg(y,x)=1;
        end;
    end;
    
    if mod(y,20)==0
        y
    end;
end;

final_result=timg;