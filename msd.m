function final_result=msd(t)

% First we will sort the entire structure versus time!
% PUT THAT HERE.

numrows=size(t,1);
num_particles=max(t(:,5));
mintime=min(t(:,4)); maxtime = max(t(:,4));

starters=zeros(num_particles,4);
% First: let's find out what the starting pos,angle of each particle is.
for i=1:numparticles
    for j=1:numrows
        if t(j,5)==i
            starters(i,1) = t(j,1);
            starters(i,2) = t(j,2);
            starters(i,3) = t(j,3);
            starters(i,4) = t(j,4);
            break;
        end
    end
end

% Now we can start to calculate change versus time, and average over each
% particle.

for i=mintime:maxtime
    