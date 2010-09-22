function result=test_function(data)


n=0;

for c=2:2:size(data,2)
    n=n+1;
    Imax=max(data(:,c));
    Imin=min(data(:,c));
    Imaxp=max(data(:,c-1));
    Iminp=min(data(:,c-1));
    
    for r=1:size(data,1)
        
        top = 1 - (Imax - data(r,c))/(Imax-Imin);
        bottom = 1 - (Imaxp - data(r,c-1))/(Imaxp-Iminp);
        
        result(r,n)=top/bottom;
        
    end
    
end

