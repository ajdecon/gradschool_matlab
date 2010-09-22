% Version dpt2 calculates intensities on a ring.

function [pairs,average_ratio,positions,intensities,res]=dpt2(imagestack,radrange,maxmove,b,minr,maxr)

numframes=size(imagestack,3);

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

% Now we find the intensities for each section, integrated along rings.
intensities=ring_section(imagestack, positions, b, minr, maxr);

%intensities=zeros(size(positions,1),3);
%for k=1:size(positions,1)
%    intensities(k,1)=positions(k,4);
%    intensities(k,2)=positions(k,3);
%    x=positions(k,1); y=positions(k,2);
%    n=positions(k,3);
%    intensities(k,3)=mean(mean( imagestack( floor(y-(boxsize/2)):ceil(y+(boxsize/2)), floor(x-(boxsize/2)):ceil(x+(boxsize/2)),n) ));
%end

pairs=[]; average_ratio=[];
% % Get user-generated pairing information.
% beep;beep;
% pairs=dna_pairing(imagestack,positions,intensities);
% 
% % Finally, generate an average-ratio across time.
% for f=1:numframes
%     sum=0;
%     num=0;
%     for k=1:size(pairs,3)
%         nowindex=find(pairs(:,1,k)==f);
%         if nowindex
%             sum = sum + pairs(nowindex,6,k);
%             num = num + 1;
%         end
%     end
%     
%     average_ratio(f,1)=f;
%     if (num>0)
%         average_ratio(f,2)=double(sum)/double(num);
%     end
%     average_ratio(f,3)=num;
% end
%     
    