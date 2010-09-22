function result = compare_stacks(stack1,stack2)

zmax1=size(stack1,3);
zmax2=size(stack2,3);
if zmax1 >= zmax2
    zm=zmax1;
else
    zm=zmax2;
end

for z=1:zm
    
    subplot(1,2,1);
    if z<=zmax1
        imshow(stack1(:,:,z));
        title(num2str(z));
    else
        imshow(stack1(:,:,zmax1));
        title(num2str(zmax1));
    end
    
    subplot(1,2,2);
    if z<=zmax2
        imshow(stack2(:,:,z));
        title(num2str(z));
    else
        imshow(stack2(:,:,zmax2));
        title(num2str(zmax2));
    end
    f(z)=getframe(gcf);
    pause(0.5);
end

result=f;