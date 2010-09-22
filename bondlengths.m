function final_result = bondlengths(db)

num_circles = size(db,1);

used=zeros(num_circles,2);

k=0;
for i=1:num_circles
    flag=0;
    
    x0=db(i,1); y0=db(i,2); x1=db(i,4); y1=db(i,5);
    
    % Prevent double counting.
    for j=1:numcircles
        xc=used(j,1); yc=used(j,2);
        if x0==xc && y0==yc
            flag=1;
        end
    end
    
    if flag==1
        continue;
    end
    
    if x1==0 || y1==0
        continue;
    end
    
    k=k+1;
    bonds(k)=sqrt( (x1-x0)^2 + (y1-y0)^2);
    used(i,1)=x0; used(i,2)=y0;
    
    