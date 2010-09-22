function [orientplot,bondplot] = meanplot(dataplot,bonds,binsize)

maxdist = max(dataplot(:,1));

sz = size(dataplot,1);
szb = size(bonds,1);

cmin = 0.0;
cmax = binsize;
rows=0;

while (cmax < maxdist)

  num=0;
  total=0;
  avg = 0;

  bondcount = 0;

  for i=1:sz

    if (dataplot(i,1) >= cmin) && (dataplot(i,1) <= cmax)
      total = total + dataplot(i,2);
      num = num + 1;
    end

    if num>0
      avg = total / num;
    end
  end

  for i=1:szb
    if (bonds(i,1) >= cmin) && (bonds(i,1) <= cmax)
      bondcount = bondcount + 1;
    end
  end

  rows=rows+1;
  orientplot(rows,1)=(cmax-cmin)/2 + cmin;
  orientplot(rows,2)=avg;
  bondplot(rows,1)=(cmax-cmin)/2 + cmin;
  bondplot(rows,2)=bondcount/2;

  cmin=cmax;
  cmax=cmax+binsize;

end
