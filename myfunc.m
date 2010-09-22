function [x,y]=myfunc

x=(-10:0.01:10);

yi=1;

for xx=x
    
    y(yi)=-0.05*xx-xx*exp(0.1*xx);
    yi=yi+1;
end

