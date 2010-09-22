function result = compare_stacks_labels(stack,labels)

zmax1=size(stack,3);
zmax2=size(labels,3);
if zmax1 >= zmax2
    zm=zmax1;
else
    zm=zmax2;
end

for z=1:zm
    
    subplot(1,2,1);
    if z<=zmax1
        imshow(stack(:,:,z));
        title(num2str(z));
    else
        imshow(stack(:,:,zmax1));
        title(num2str(zmax1));
    end
    
    subplot(1,2,2);
    if z<=zmax2
        imshow(label2rgb(labels(:,:,z),'jet','w'));
        title(num2str(z));
    else
        imshow(label2rgb(labels(:,:,zmax2),'jet','w'));
        title(num2str(zmax2));
    end
    f(z)=getframe(gcf);
    pause(0.1);
end

result=f;