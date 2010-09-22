function result = stackmovie_labels(imgstack,tab_through)

zmax=size(imgstack,3);

for z=1:zmax
    imshow(label2rgb(imgstack(:,:,z),'jet','w'));
    title(num2str(z));
    f(z)=getframe(gcf);
    if tab_through>0
        pause;
    else
        pause(0.05);
    end
end
result=f;
