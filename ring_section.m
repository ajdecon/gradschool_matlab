function intensities=ring_section(I, positions, b, minr, maxr)

% Positions data structure:
%   Column 1: x
%   Column 2: y
%   Column 3: f, frame
%   Column 4: n, particle id
%
% intensities data stucture:
%   row numbers will be the same as positions rows
%   Column 1: n
%   Column 2: f
%   Column 3: i

r = floor(b/2);

%intensities=zeros( size(positions,1), 3);
intensities(:,1)=positions(:,4);
intensities(:,2)=positions(:,3);

% Build an initial set of data boxes and black masks for each unique particle.
for n=1:max(positions(:,4))
    masks(:,:,n)=zeros(2*r+1, 2*r+1);
end

for f=1:size(I,3)    
    
    % Re-initialize the boxes.
    for n=1:max(positions(:,4))
        boxes(:,:,n)=zeros(2*r+1,2*r+1);
    end
    
    % Build boxes at particle locations.
    thisframe=positions( positions(:,3)==f, :);
    for n=1:size(thisframe,1)
        y=thisframe(n,2);
        x=thisframe(n,1);
        id=thisframe(n,4);
        boxes(:,:,id) = I( y-r:y+r, x-r:x+r, f);
    end
    %stackmovie(boxes,0);beep;pause;
    
    % Calculate masks for each box.
    for n=1:size(boxes,3)
        
        % Check to see if we have a new box for this iteration. If not, we
        % will use the last calculated mask.
        %if sum(sum( boxes(:,:,n) ) ) > 0
            
            % Thresholded masking.
            bw = im2bw( boxes(:,:,n), graythresh(boxes(:,:,n)) );
            masks(:,:,n)=bw;
            
            % Radius masking.
            x0=r+1; y0=r+1;
            for x=1:(2*r+1)
                for y=1:(2*r+1)
                    
                    d=sqrt( (x-x0)^2 + (y-y0)^2 );
                    if ( (d<minr) || (d>maxr) )
                        masks(y,x,n)=0;
                    end
                    
                end
            end
        
        %end
        
    end
    
    % Apply masks to boxes.
    boxes(masks==0) = 0;
    
    % Calculate intensities and save them.
    for n=1:size(boxes,3)
        ring_int = sum(sum( double(boxes(:,:,n)) ));
        intensities( intensities(:,1)==n & intensities(:,2)==f, 3 ) = ring_int;
    end
    pause;
    
end
        
        
        
        