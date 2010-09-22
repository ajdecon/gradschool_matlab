function result=devices_volfrac(pvol,volumes,numbers)

for i=1:size(volumes,2)
    for j=1:size(numbers,2)
        
        vf=numbers(1,j)*pvol/volumes(1,i);
        result(i,j) = vf;
        
    end
    
end
    