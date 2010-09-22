function result=test_function2(data)


n=0;

for c=2:2:size(data,2)
    n=n+1;
    Imax=max(data(:,c));
    Imin=min(data(:,c));
    Imaxp=max(data(:,c-1));
    Iminp=min(data(:,c-1));
    
    for r=1:size(data,1)
        
        top = (Imax-data(r,c))/(Imax-Imin);
        bottom = (Imaxp-data(r,c-1))/(Imaxp-Iminp);
        
        result(r,n)=top/bottom;
        
    end
    
end

