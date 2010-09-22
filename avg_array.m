function result=avg_array(data,n)

length=size(data,2);
last=1;
num=1;

while (last<length)
    last=last+n;
    if (last<length)
        newdata(num)=mean(data(1,(last-n):last));
        num=num+1;
    end
end

result=newdata;