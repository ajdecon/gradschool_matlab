function [pairs,average_ratio,positions,intensities,res,windowlist,masklist]=dna_boxtracking(imagestack,radrange,maxmove,boxradius,minr,maxr)

numframes=size(imagestack,3);

%%% DEBUG masklist windowlist
m=0; w=0; masklist=[]; windowlist=[];


% Get positionlist and tracklist from HoughTracking.
[positionlist,tracklist]=HoughTracking(imagestack,radrange,1:numframes,0);

% Now send tracklist to the particle tracking routine.
param.mem=5; param.dim=2; param.good=5; param.quiet=0;
res=track(tracklist,maxmove,param);

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
    positions(k,4)=n;
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

% Now that we have healed tracks we can find intensities on rings for each
% point.
r=boxradius;
r1=maxr; r2=minr;
intensities=zeros(size(positions,1),3);

interval=10;
done=size(positions,1);
'Now calculating ring intensities.'

for k=1:size(positions,1)
    
    if mod( k, interval )==0
        strcat(num2str(k), ' done of ', num2str(done))
    end
    
    x=floor(positions(k,1)); y=floor(positions(k,2)); 
    if (x< (r+1) ) 
        x=r+1;
    end
    if (y< (r+1) ) 
        y=r+1;
    end
    
    f=positions(k,3); n=positions(k,4);
    window = imagestack( y-r:y+r, x-r:x+r, f );
    
    w=w+1;
    %windowlist(:,:,w)=window;
    
    %bw=im2bw(window, graythresh(window));
    bw=im2bw(window, graythresh(imagestack(:,:,f)));
    
    x0=(size(bw,1)-1)/2; y0=(size(bw,2)-1)/2;
    mask=bw;
    for x=1:size(bw,1)
            for y=1:size(bw,2)
                d=sqrt( (x-x0)^2 + (y-y0)^2 );
                if ( (d>r1) || (d<r2) )
                    mask(y,x)=0;
                end
            end
        
    end
    
    m=m+1;
       
    masked=window;
    masked(mask==0)=0;
    
    %masklist(:,:,m)=masked;
    
    int_here=mean( mean( masked ) );
    
    intensities(k,1)=positions(k,4);
    intensities(k,2)=positions(k,3);
    intensities(k,3)=int_here;
end
    
    % FINISH HERE

%intensities=zeros(size(positions,1),3);
%for k=1:size(positions,1)
%    intensities(k,1)=positions(k,4);
%    intensities(k,2)=positions(k,3);
%    x=positions(k,1); y=positions(k,2);
%    n=positions(k,3);
%    intensities(k,3)=mean(mean( imagestack( floor(y-(boxsize/2)):ceil(y+(boxsize/2)), floor(x-(boxsize/2)):ceil(x+(boxsize/2)),n) ));
%end

% Get user-generated pairing information.
beep;beep;
pairs=dna_pairing(imagestack,positions,intensities);

% Finally, generate an average-ratio across time.
for f=1:numframes
    sumup=0;
    num=0;
    for k=1:size(pairs,3)
        nowindex=find(pairs(:,1,k)==f);
        if nowindex
            sumup = sumup + pairs(nowindex,6,k);
            num = num + 1;
        end
    end
    
    average_ratio(f,1)=f;
    if (num>0)
        average_ratio(f,2)=double(sumup)/double(num);
    end
    average_ratio(f,3)=num;
end
    
    