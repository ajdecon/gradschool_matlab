function final_result = sortvtime(t)

numrows=size(t,1);
maxtime=max(t(:,4));
mintime=min(t(:,4));

k=0;
for i=mintime:maxtime
    for j=1:numrows
        if t(j,4)==i
            k=k+1;
            t1(k,:)=t(j,:);
        end
    end
end

final_result = t1;
    
    