function [side1,side2]=particle_split(poslist,indices1)   %,indices2)

side1=poslist(indices1,:);
%side2=poslist(indices2,:);
poslist(indices1,:)=[];
side2=poslist;
