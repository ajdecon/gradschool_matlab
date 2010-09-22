function result=maketables(t)

% Assume that t is sorted by particle ID.
% Assumes time is integral.

numrows=size(t,1);
num_particles=max(t(:,5));
maxtime = max(t(:,4));

allx=zeros(round(maxtime),num_particles+1);
ally=zeros(round(maxtime),num_particles+1);
allp=zeros(round(maxtime),num_particles+1);

for i=1:numrows
    allx(round(t(i,4)),1) = t(i,4);
    allx(round(t(i,4)),round(t(i,5))+1) = t(i,1);
    ally(round(t(i,4)),round(t(i,5))+1) = t(i,2);
    allp(round(t(i,4)),round(t(i,5))+1) = t(i,3);
end

% Strip NaN values, replace with zeros.
for i=1:size(allx,1)
    for j=1:num_particles+1
        if isnan(allp(i,j))
            allp(i,j)=0;
        end
    end
end

% OK, now let's shift each particle's track back to the top of the matrix
for i=1:num_particles
    
    % Find start time.
    start_time=0;
    for j=1:size(allx,1)
        if allx(j,i+1)~=0
            start_time=allx(j,1);
            break;
        end
    end
    
    % Find end time.
    end_time=0;
    for j=1:size(allx,1)
        if allx(j,i+1)~=0
            end_time=allx(j,1);
        end
    end
    
    pathx=allx(start_time:end_time,i+1);
    total_time=size(pathx,1);
    allx(1:total_time,i+1) = pathx(1:total_time,1);
    pathy=ally(start_time:end_time,i+1);
    ally(1:total_time,i+1) = pathy(1:total_time,1);
    pathp=allp(start_time:end_time,i+1);
    allp(1:total_time,i+1) = pathp(1:total_time,1);

    if size(allx,1)-end_time>0
        allp(end_time:(size(allx,1)-1),i+1) = zeros( (size(allx,1)-end_time), 1 );
        allx(end_time:(size(allx,1)-1),i+1) = zeros( (size(allx,1)-end_time), 1 );
        ally(end_time:(size(allx,1)-1),i+1) = zeros( (size(allx,1)-end_time), 1 );
    end
end



startx=allx(1,:);
starty=ally(1,:);
startp=allp(1,:);
% Determine starting positions for each particle.
%startx=zeros(1,num_particles+1);
%starty=zeros(1,num_particles+1);
%startp=zeros(1,num_particles+1);
% for i=1:num_particles
%     for j=1:numrows
%         if allx(j,i)~=0
%             startx(1,i)=allx(j,i+1);
%             starty(1,i)=ally(j,i+1);
%             startp(1,i)=allp(j,i+1);
%             break;
%         end
%     end
% end

% Let's make all our angles positive, to try to head off angle weirdness.
for i=1:size(allp,1)
   for j=1:num_particles
       if allp(i,j+1)<0
           allp(i,j+1)=allp(i,j+1)+pi;
       end
   end
end

result.xtable = allx;
result.ytable = ally;
result.ptable = allp;
