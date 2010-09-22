function [pos,images] = pretrack2(rawimg, gt, bnoise, bsize, thresh, boxsize, searchsize, cutoff)

total_time = size(rawimg,3);


k=0;
for i=1:total_time
    
    clear bw bp gt2 bw2 dist lt summary data;
    %gt = graythresh(rawimg(:,:,i)); % Calculate Otsu's threshold for the image.
    bw = im2bw(rawimg(:,:,i),gt);   % Threshold to kill non-particle background.
    bp = bpass(bw,bnoise,bsize);    % Bandpass to remove noise, use bpass parameters supplied.
    gt2 = graythresh(bp);           % Calculate Otsu's threshold for the bpass'd image.
    bw2 = im2bw(bp,gt2);            % Threshold again pre-distance transform.
    
    dist=bwdist(~bw2);    % Normalized distance transform of inverse image.
    dist=( 1/max(max(dist)) )*dist;
    images.alldist(:,:,i)=dist;
    
    % Calculate local percentile threshold to find backbones.
    lt = local_percent_threshold(dist, thresh, boxsize);
    images.allb(:,:,i)=lt;
    
    % Find backbones, calculate angles.
    [summary,data]=group_backbone(lt,searchsize,cutoff);
    num_particles = size(summary,1);
    
    % Add each particle to the data structure we'll pass on to track.
    for j=1:num_particles
        k=k+1;
        positions(k,1) = summary(j,1); % x0
        positions(k,2) = summary(j,2); % y0
        positions(k,3) = summary(j,3); % phi
        positions(k,4) = i;            % time
        
    end
    
    if rem(i,10)==0
        TimeTracked=i
%        beep;
    end
    
end

pos = positions;