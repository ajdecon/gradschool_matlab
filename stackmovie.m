function result = stackmovie(imgstack,tab_through)

zmax=size(imgstack,3);

for z=1:zmax
    imshow(imgstack(:,:,z));
%    title(num2str(z));
%    f(z)=getframe(1,[0 0 (300+size(imgstack,1)) (300+size(imgstack,2))]);
    f(z)=getframe(gcf);
    if tab_through>0
        pause;
    else
        pause(0.05);
    end
end
result=f;
