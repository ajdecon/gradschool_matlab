function result = histstack(imgstack,tab_through)

zmax=size(imgstack,3);

for z=1:zmax
    subplot(2,1,1), imshow(imgstack(:,:,z));
    title(num2str(z));
    subplot(2,1,2), imhist(imgstack(:,:,z));
    
    if tab_through>0
        pause;
    else
        pause(0.05);
    end
end

return;