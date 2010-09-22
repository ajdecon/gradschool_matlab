function result=norm_ratio(I1,Imax1,Imin1,I2,Imax2,Imin2)

length=size(I1,2);

for i=1:length
    top=(Imax1-I1(i))/(Imax1-Imin1);
    bottom=(Imax2-I2(i))/(Imax2-Imin2);
    norm(i) = (1- (Imax1-I1(i))/(Imax1-Imin1) ) / (1-(Imax2-I2(i))/(Imax2-Imin2) );
    
    tw=0.99;
    if (top>tw)
        norm(i)=1;
    end
    if (bottom>tw)
        norm(i)=1;
    end
end

result = norm;