function [xx,y]=temp

x=(-10:0.01:10);

for xx=x
    
    y(xx)=xx*exp(-xx);
end

