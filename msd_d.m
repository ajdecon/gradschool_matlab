function [final_result,x,y,p]=msd_d(t,range)

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

x=allx; y=ally; p=allp;

numrows=size(allx,1);

% Now what we're going to do is calculate the diffusion constant at each
% time based on the points above and below, using +/- the range
% supplied.

% First, calculate dX, dY, dP.

dX=zeros(numrows,num_particles+1);
dP=zeros(numrows,num_particles+1);
dY=zeros(numrows,num_particles+1);

for i=2:numrows
    dX(i,1)=allx(i,1);
    dY(i,1)=allx(i,1);
    dP(i,1)=allx(i,1);
    for j=1:num_particles
        if allx(i,j+1)~=0
            dX(i,j+1)=abs(allx(i,j+1)-allx(1,j+1));
            dY(i,j+1)=abs(ally(i,j+1)-ally(1,j+1));
        end
        
        if allp(i,j+1)~=0
            dP(i,j+1)=abs(allp(i,j+1)-allp(1,j+1));
            
            % Account for the fact we can't detect dp>90 degrees

            if dP(i,j+1)>(pi/2)
                dP(i,j+1) = abs( (allp(i,j+1) - pi) - allp(1,j+1) );
            end
            
        end
    end
end

    
% x=dX; y=dY; p=dP;

% Now we find x^2, y^2, p^2, etc. as normal, but add on a column for D_r.
lastdata=zeros(numrows,9);

for i=1:numrows
    sumx=0;sumx2=0;sumy=0;sumy2=0;sump=0;sump2=0;
    n=0; np=0;
    for j=1:num_particles
        if allx(i,j+1)~=0
            sumx=sumx+dX(i,j+1);
            sumx2=sumx2+(dX(i,j+1))^2;
            n=n+1;
        end
        if ally(i,j+1)~=0
            sumy=sumy+dY(i,j+1);
            sumy2=sumy2+(dY(i,j+1))^2;
%            ny=ny+1;
        end
        if allp(i,j+1)~=0
            sump=sump+dP(i,j+1);
            sump2=sump2+(dP(i,j+1))^2;
            np=np+1;
        end
    end
    lastdata(i,1)=allx(i,1);
    if n~=0
        lastdata(i,2)=sumx/n;
        lastdata(i,5)=sumx2/n;
        lastdata(i,3)=sumy/n;
        lastdata(i,6)=sumy2/n;
    end
    if np~=0
        lastdata(i,4)=sump/n;
        lastdata(i,7)=sump2/n;
    end
    lastdata(i,8)=n;
end

% Let's calculate the D_r's and add them into column 9.  These should be
% from the mean p^2.
for i=(range+1):(numrows-range)
    times=lastdata( (i-range):(i+range), 1 );
    p2s=lastdata( (i-range):(i+range), 7 );
    fits=polyfit(times,p2s,1);
    lastdata(i,9)=fits(1);
end

final_result=lastdata;