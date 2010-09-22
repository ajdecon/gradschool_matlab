function result = compare_labels(stack1,stack2)

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
        imshow(label2rgb(stack1(:,:,z),'jet','w'));
        title(num2str(z));
    else
        imshow(label2rgb(stack1(:,:,z),'jet','w'));
        title(num2str(zmax1));
    end
    
    subplot(1,2,2);
    if z<=zmax2
        imshow(label2rgb(stack2(:,:,z),'jet','w'));
        title(num2str(z));
    else
        imshow(label2rgb(stack2(:,:,z),'jet','w'));
        title(num2str(zmax2));
    end
    
    pause(0.05);
end

