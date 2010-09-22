function final_result = dt_percent_threshold(image0, threshold)

% Adam DeConinck, 2 April 2009.
%
% Function takes a 2D distance-transformed image produced by bwdist and 
% returns a binary image in which all pixels above the specified percentile
% are valued 1, and the rest are zero.  
%
% With remove_zeros=1, it does not include
% zero-valued pixels in the percentile calculation as it assumes they are
% part of the background, not part of the objects being analyzed.
remove_zeros=1;
% Get information about the image.
[Ny,Nx]=size(image0);

% Read image into a linear single linear array (destroy x,y values).
k=1;
for x=1:Nx
    for y=1:Ny
        pval=image0(y,x);

%        if remove_zeros==1
            if pval>0
                pixels(k)=pval;
                k=k+1;
            end
%        else
%            pixels(k)=pval;
%            k=k+1;
%        end
        if rem(k,10000)==0
                k
                x
                y
        end
    end
end

'created array'

% Calculate the level for the desired percentile
total=size(pixels,2);

psort=sort(pixels);
level=threshold*total;

[N,D] = rat(level);
if isequal(D,1)
    level=level+0.5;
    flag=1;
else
    level=round(level);
    flag=0;
end

if flag==1
    Qk=mean(psort(level-0.5:level+0.5));
else
    Qk=psort(level);
end

'level calculated'

% Build a new image where value > Qk is 1, value < Qk is 0.

for x=1:Nx
    for y=1:Ny
        if image0(y,x)>Qk
            image1(y,x)=1;
        else
            image1(y,x)=0;
        end
        
    end
end

Qk
final_result = image1;