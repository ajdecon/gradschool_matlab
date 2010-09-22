function result = y_section(imgstack,movie)

xmax=size(imgstack,2);
ymax=size(imgstack,1);
zmax=size(imgstack,3);

for x=1:xmax
    for y=1:ymax
        for z=1:zmax
            newstack(x,z,y) = imgstack(y,x,z);
        end;
    end;
end;

result = newstack;

if movie>0

for y=1:ymax
    imshow(newstack(:,:,y));
    title(num2str(y));
    
    pause(0.05);
end

end
