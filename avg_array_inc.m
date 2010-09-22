function result=avg_array_inc(data,num)

length=size(data);
n=num/2;

for i=(1+n):(length-n)
    newdata(i)=mean(data( (i-n):(i+n) ));
end

result=newdata;