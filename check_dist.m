function [dist,avs,stddevs] = check_dist(db,rawimg,boxsize)

[Ny,Nx] = size(rawimg);
numCircles = size(db,1);
bs=boxsize;
k=0;
for i=1:numCircles
    
    if bs==0
        boxsize = db(i,3);
    end
    x0=db(i,1); y0=db(i,2);
    
    if ((x0-boxsize)<0) || ((y0-boxsize)<0) || ((x0+boxsize)>Nx) || ((y0+boxsize)>Ny)
        continue;
    end
    clear localpx; k1=0;
    for x=round(x0-boxsize):round(x0+boxsize)
        for y=round(y0-boxsize):round(y0+boxsize)
            dR = sqrt( (x-x0)^2 + (y-y0)^2 );
            if dR < boxsize
                k=k+1;
                k1=k1+1;
                pxlist(k)=rawimg(y,x);
                localpx(k1)=rawimg(y,x);
            end
        end
    end
    
    sd(i)=std(double(localpx)); m(i)=mean(double(localpx));
    
    i
    
end

dist = pxlist; stddevs=sd; avs=m;