function result = x_section(imgstack,movie)

xmax=size(imgstack,2);
ymax=size(imgstack,1);
zmax=size(imgstack,3);

for x=1:xmax
    for y=1:ymax
        for z=1:zmax
            newstack(y,z,x) = imgstack(y,x,z);
        end;
    end;
end;

result = newstack;

if movie>0

for x=1:xmax
    imshow(newstack(:,:,x));
    title(num2str(x));
    
    pause(0.05);
end

end
