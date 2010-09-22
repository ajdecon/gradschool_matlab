function [ints, positions]=track_intensities(img,threshold,feature_diameter,min_area,maxmove,boxrad)

% Do everything in uint16.
%img=uint16(img);
fd=feature_diameter;
numframes=size(img,3);

% position data structure
% col 1,2: x0,y0
% col 3: frameno
positions=[];
k=0;

for f=1:size(img,3)

    %%%% Find segments and get centroids. %%%%
    
    % watershed segmentation
    I=img(:,:,f);
    T=imtophat(I,strel('disk',fd));
    gt=threshold*graythresh(T);
    BW=im2bw(T,gt);
    D=-bwdist(~BW);
    
    D=imhmin(D,1);
    
    L=watershed(D);
    
    % for each segment, get centroid (if area >= min_area)
    for n=1:max(max(L))
        
        temp=BW;
        temp(L~=n)=0;
        segments(:,:,n)=temp;
        
        if sum(sum(segments(:,:,n))) > min_area
            k=k+1;
            [y,x]=ind2sub( size(segments(:,:,n)), find(segments(:,:,n)) );
            x0=floor(mean(x)); y0=floor(mean(y));
            positions(k,1)=x0;
            positions(k,2)=y0;
            positions(k,3)=f;
        end
        
    end

end

% Now pass this to the track.m program to find particle tracks.
param.mem=5; param.dim=2; param.good=5; param.quiet=0;
res=track(positions,maxmove,param);

% Now heal the tracks. When a particle drops away entirely, we assume it
% remains stationary.

numparticles=max(res(:,4));
positions=[];
k=0;
for n=1:numparticles
    k=k+1;
    trace=res(find(res(:,4)==n),:);
    t0=trace(1,3);
    positions(k,1)=trace(1,1);
    positions(k,2)=trace(1,2);
    positions(k,3)=trace(1,3);
    positions(k,4)=trace(1,4);
    %last=t0;
    for f=(t0+1):numframes
        k=k+1;
        trindex=find(trace(:,3)==f);
        if trindex
            positions(k,1)=trace(trindex,1);
            positions(k,2)=trace(trindex,2);
            positions(k,3)=f;
            positions(k,4)=n;
        else
            positions(k,1)=positions(k-1,1);
            positions(k,2)=positions(k-1,2);
            
            positions(k,3)=f;
            positions(k,4)=n;
        end
    end
end
        
%%% Now we go back through the image and get intensities for each of our
%%% healed positions.
ints=zeros( size(img,3), max(positions(:,4)) );
for k=1:size(positions,1)
    
    n=positions(k,4);
    f=positions(k,3);
    x=positions(k,1);
    y=positions(k,2);
    
    ints(f,n) = mean( mean( double( img( y-boxrad:y+boxrad, x-boxrad:x+boxrad, f) ) ) );
    
end

beep;pause(0.5);beep;
'Hit a key!'
pause;

% Diganostic: show movie and plot positions.
figure;
for f=1:size(img,3)
    
    imagesc(img(:,:,f)); colormap('gray'); axis image;
    hold on;
    now=positions( positions(:,3)==f, :);
    for n=1:size(now,1)
        plot( now(:,1), now(:,2), 'bo' );
    end
    hold off;
    pause(0.05);
end