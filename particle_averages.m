function [avg_side1,avg_side2,ratio]=particle_averages(side1,side2)

length=size(side1,2);

for k=1:length
    avg_side1(1,k)=mean(side1(:,k));
    avg_side2(1,k)=mean(side2(:,k));
    ratio(1,k)=avg_side1(1,k)/avg_side2(1,k);
end