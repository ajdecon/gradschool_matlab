function final_result = local_percent_threshold(image0, threshold, boxsize)

% Adam DeConinck, 2 April 2009.
%
% Function takes a distance-transformed image produced by bwdist and 
% returns a binary image in which all pixels above the specified percentile
% are valued 1, and the rest are zero.  
%
% With remove_zeros=1, it does not include
% zero-valued pixels in the percentile calculation as it assumes they are
% part of the background, not part of the objects being analyzed.

% Get information about the image.
[Ny,Nx]=size(image0);

% For each pixel in the image, determine if it is >= the threshold
% percentile of its local nonzero neighborhood.  If it cannot be boxed, set
% it equal to zero.
lastx=0;
for x=1:Nx
    for y=1:Ny

        % Check to make sure pixel x,y can be boxed.
        if ( (y>boxsize) && (y<(Ny-boxsize)) && (x>boxsize) && (x<(Nx-boxsize)) )
            
            % Only bother to calculate Qk for nonzero (ie non-background)
            % pixels, otherwise set to zero.
            if image0(y,x)==0
                image1(y,x)=0;
            else
                % Build the unsorted pixel list punsrt for the box.
                k=1;
                for i=(x-boxsize):(x+boxsize)
                    for j=(y-boxsize):(y+boxsize)                   
                        %% box( j-(y-boxsize), i-(x-boxsize) )=image0(j,i);
                        % If not a zero-valued pixel, add to unsorted list.
                        if image0(j,i)>0
                            punsrt(k) = image0(j,i);
                            k=k+1;
                        end
                    end
                end
                % Find Qk for the specified threshold percentile.
                total=size(punsrt,2);
                psort=sort(punsrt);
                % Find the percentile level in the pixel set.
                level=threshold*total; 
                [N,D] = rat(level);
                if isequal(D,1)
                    level=level+0.5;
                    flag=1;
                else
                    level=round(level);
                    flag=0;
                end
                % Calculate Qk.
                if flag==1
                    Qk=mean(psort(level-0.5:level+0.5));
                else
                    Qk=psort(level);
                end
                
                % Set image1 pixel to 1 if >= Qk else 0.
                if image0(y,x)>=Qk
                    image1(y,x)=1;
                else
                    image1(y,x)=0;
                end

            end

        % If not boxable, set equal to zero.
        else
            image1(y,x)=0;
        end
    end
    if (rem(x,50)==0) && (x>lastx)
         lastx=x
    end

end

final_result = image1;