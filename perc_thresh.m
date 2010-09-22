function result=perc_thresh(ars,ncs)

size(ncs,2)

size(ars,2)

for i=1:size(ncs,2)
    for j=1:size(ars,2)
        
        vf= 2*ncs(1,i)*ars(1,j)/( (ars(1,j))^2 + (pi+3)*ars(1,j) + pi )
        result(i,j) = vf;
        
    end
    
end
    