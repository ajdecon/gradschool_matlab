function final_result = dumbbell_pos(circen,cirrad,rawimg,threshold)
% dumbbell_pos.m: Determine the pair bonds of dumbbell particles from
% recognized circle positions, using maximization of area of overlap to
% decide between multiple possible pairings.
%
% Arguments: circen (centers) and cirrad (radii) from CircularHough_Grd.m
%            rawimg: original image.
%            threshold: cutoff for average intensity of region around
%            center, below which the circle is ignored.  
%
% Procedure: Determine threshold (fairly fast).  Run this once with a threshold of 0,
% then run check_dist.m to get distributions of averages and stddevs.
% Histogram the averages to find the separation between real and fictional
% particles, then run this again with the new threshold.

num_circles=size(circen,1);

[Ny,Nx] = size(rawimg);
% otsu = graythresh(rawimg);

if size(cirrad,1) ~= num_circles
    'Help!'
    exit;
end

% Initialize pairs datastructure.
% Column 1: x for circle i
%        2: y for circle i
%        3: R for circle i
%        4: x for linked circle
%        5: y for linked circle
%        6: R for linked circle
%        7: overlap area
pairs=zeros(num_circles,7);
flagged=zeros(num_circles);

boxsize = 12;
killed=0;

% Preprocess to kill bad circles.
for i=1:num_circles
        
    x0 = circen(i,1); y0=circen(i,2); R0=cirrad(i);
    pairs(i,1) = x0; pairs(i,2) = y0; pairs(i,3) = R0;
    
    % Check if this is a real circle!
    xu = round(x0-boxsize); xo = round(x0+boxsize);
    yu = round(y0-boxsize); yo = round(y0+boxsize);
    numpx = (xo-xu)*(yo-yu);
    
    % Kill circles too near the edge.
    if (xu < 0) || (yu < 0) || (xo>Nx) || (yo>Ny)
        cirrad(i)=0; circen(i,1)=0; circen(i,2)=0;
        continue;
    end

    % Kill circles whos nearby average is below the set threshold. 
    % TODO: find a way to auto-calculate threshold.
    clear localpx;
    k1=0;
    for x=round(x0-boxsize/2):round(x0+boxsize/2);
        for y=round(y0-boxsize/2):round(y0+boxsize/2);
            k1=k1+1;
            localpx(k1)=rawimg(y,x);
        end
    end
    if mean(double(localpx))<threshold
        cirrad(i)=0; circen(i,1)=0; circen(i,2)=0;
        killed=killed+1;
        continue;
    end
end

% Loop through all circles, calculate which nearby circle has the greatest
% area of overlap.
for i=1:num_circles

    clear overlap;
    
    overlap = [0 0 0 0];
    
    x0 = circen(i,1); y0=circen(i,2); R0=cirrad(i);
    pairs(i,1) = x0; pairs(i,2) = y0; pairs(i,3) = R0;

    if R0==0 || x0==0 || y0==0
        continue;
    end
    
    % Check each *other* circle for overlap, calculate area, save maximum
    % answer.
    for j=1:num_circles
        if i==j || flagged(j)==1
            continue;
        end;
        
        x1 = circen(j,1); y1=circen(j,2); R1=cirrad(j);
        
        dR = sqrt( (x1-x0)^2 + (y1 - y0)^2 );

        % Ignore this circle if too far away to be linked, or too close to
        % be a real particle.
        if (dR>(R1+R0)) || (dR<R0*1.2) || (dR<R1*1.2) || x1==0 || y1==0
            continue;
        else
            
            a = (R1^2 * acos( (dR^2 + R1^2 - R0^2)/(2*dR*R1) )) + (R0^2 * acos( (dR^2 + R0^2 - R1^2)/(2*dR*R0) ));
            a = a - 0.5*sqrt( (R1+R0-dR)*(dR+R1-R0)*(dR+R0-R1)*(dR+R1+R0) );
            if a>overlap(1)
                overlap = [a x1 y1 R1];
            end
        end
        
    end
    
    if overlap(1)==0
        continue;
    else
        pairs(i,4) = overlap(2); pairs(i,5) = overlap(3); pairs(i,6) = overlap(4); pairs(i,7) = overlap(1);
    end
    
end

% Do a check for multiple connectedness.  Eliminate circle with lower area
% of overlap.
for i=1:num_circles
    if pairs(i,6)==0
        continue;
    end

    xp=pairs(i,1);yp=pairs(i,2);
    xc = pairs(i,4); yc = pairs(i,5); ac = pairs(i,7);
    
    for j=1:num_circles
        if i==j
            continue;
        end

        % Eliminate 1-2 and 3-2 doubles.
        xn=pairs(j,4); yn=pairs(j,5); an = pairs(j,7);
        if (xc==xn) && (yc==yn)
            if (ac>an)
                pairs(j,4)=0; pairs(j,5)=0; pairs(j,6)=0; pairs(j,7)=0;
            else
                pairs(i,4)=0; pairs(i,5)=0; pairs(i,6)=0; pairs(i,7)=0;
            end
        end
        
        % Eliminate 1-2 and 2-3 doubles.
        xpp=pairs(j,1); ypp=pairs(j,2); 
        if (xpp==xc) && (ypp==yc)
            if (xn~=xp)
                if (ac>an)
                    pairs(j,4)=0; pairs(j,5)=0; pairs(j,6)=0; pairs(j,7)=0;
                else
                    pairs(i,4)=0; pairs(i,5)=0; pairs(i,6)=0; pairs(i,7)=0;
                end
            end
        end
    end
end

killed
final_result = pairs;