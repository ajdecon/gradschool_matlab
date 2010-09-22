function [dataplot,table,bonds] = orient_corr(bsum,distance,bond1,bond2)

pcount = size(bsum,1);

table = zeros(pcount,pcount);

rows=0;
brows=0;

if bond2<bond1
  t=bond2;
  bond2=bond1;
  bond1=t;
end

for i=1:pcount

  x0 = bsum(i,1); y0 = bsum(i,2); t1 = bsum(i,3);

  for j=1:pcount
    
    x1 = bsum(j,1); y1 = bsum(j,2); t2 = bsum(j,3);

    d = sqrt((x1-x0)^2 + (y1-y0)^2);

    if ((d<=distance) && (d~=0))
      
      dp = cos(t1)*cos(t2) + sin(t1)*sin(t2);
      table(i,j) = abs(dp);
      rows = rows+1;
      dataplot(rows,1) = d; dataplot(rows,2) = abs(dp);

    end

    if ((d<=bond1) && (d~=0))
      brows=brows+1;
      bonds(brows,1) = d;
      bonds(brows,2) = 1;
    elseif ((d<=bond2) && (d~=0))
      brows=brows+1;
      bonds(brows,1) = d;
      bonds(brows,2) = 2;
    end

  end

end
