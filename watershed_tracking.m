function ints=watershed_tracking(I,thresh_factor,maxmove,minArea,box)

p=0;
interval=10;

for f=1:size(I,3)
    
    T=imtophat(I(:,:,f), strel('disk',50));
    BW=im2bw(T, thresh_factor*graythresh(T) );
    D=-bwdist(~BW);
    M=imhmin(D,1);
    L=watershed(M);
    
    for n=1:max(max(L))
        
        temp=BW;
        temp(L~=n)=0;
        segments(:,:,n)=temp;
        
        if sum(sum(segments(:,:,n))) < minArea
            continue;
        end
        
        [y,x]=ind2sub( size(segments(:,:,n)), find(segments(:,:,n)) );
        x0=floor(mean(x)); y0=floor(mean(y));
        
        % Save the segments array.
        %segmented{f}=segments;
        b2=floor(box/2);
        intensity = mean( mean(I( y0-b2:y0+b2, x0-b2:x0+b2, f) ));
        
        %intensity=double(sum( I( segments(:,:,n) > 0 ) )) / sum( BW( segments(:,:,n) > 0) );
        %area=double(sum(BW(segments(:,:,n) > 0)));
        area=0;
        
        p=p+1;
        positions(p,1)=x0;
        positions(p,2)=y0;
        positions(p,5)=f;
%        positions(p,4)=n;
        positions(p,3)=intensity;
        positions(p,4)=area;
        
    end
    
    if mod(f,interval)==0
        f
    end
end

% Now pass this to the track.m program to find particle tracks.
param.mem=5; param.dim=2; param.good=5; param.quiet=0;
res=track(positions,maxmove,param);

% Now heal the tracks. When a particle drops away entirely, we assume it
% remains stationary.

numparticles=max(res(:,6));
positions=[];
k=0;
for n=1:numparticles
    k=k+1;
    trace=res(find(res(:,6)==n),:);
    t0=trace(1,5);
    positions(k,1)=trace(1,1);
    positions(k,2)=trace(1,2);
    positions(k,3)=trace(1,3);
    positions(k,4)=trace(1,4);
    positions(k,5)=trace(1,5);
    positions(k,6)=n;
    %last=t0;
    for f=(t0+1):numframes
        k=k+1;
        trindex=find(trace(:,3)==f);
        if trindex
            positions(k,1)=trace(trindex,1);
            positions(k,2)=trace(trindex,2);
            positions(k,3)=trace(trindex,3);
            positions(k,4)=trace(trindex,4);
            positions(k,5)=f;
            positions(k,6)=n;
        else
            positions(k,1)=positions(k-1,1);
            positions(k,2)=positions(k-1,2);
            positions(k,3)=positions(k-1,3);
            positions(k,4)=positions(k-1,4);
            
            positions(k,5)=f;
            positions(k,6)=n;
        end
    end
end


ints=positions;
res=positions;
beep;pause(0.25);beep;pause;

for f=1:size(I,3)
    
    %T=imtophat(I(:,:,f), strel('disk',50));
    %BW=im2bw(T, thresh_factor*graythresh(T) );
    
    thisframe=res( res(:,5)==f, :);
    imagesc(I(:,:,f)); axis image; colormap('gray');hold on;
    for n=1:size(thisframe,1)
        h=text(thisframe(n,1),thisframe(n,2),num2str(thisframe(n,6)));
        set(h,'Color','g');
        set(h,'FontWeight','bold');
    end
    hold off;
    pause(0.075);
end