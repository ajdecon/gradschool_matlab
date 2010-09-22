% Generate 8-bit image with a set of randomly rotated 2D particles imposed.

function I = random_particles(count, tile, height, width, noise)

I=uint8( zeros(512,512) );

for n=1:count
    
    angle = -180 + 360*rand();
    rot = imrotate(tile,angle);
    [rwidth,rheight]=size(rot);
    
    x=floor( width * rand() );
    y=floor( height * rand() );
    
    
    if ( x+rwidth > width)
        x = x - rwidth - 1;
    end
    if (y+rheight > height)
        y = y - rheight - 1;
    end
    
    for m=1:rheight
        for n=1:rwidth
            if (I(m+y,n+x)==0)
                I(m+y,n+x)=rot(m,n);
            end
        end
    end
    
    %I( y:(y+rheight-1), x:(x+rwidth-1) ) = rot;
    
    
end

if (noise>0)
    I=imnoise(I,'gaussian');
end