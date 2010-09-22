function mov=showmovie(rawimg,t,time)

length=15;

for i=1:time
    figure(1),imshow(rawimg(:,:,i));
    
    hold on;
    for j=1:size(t,1)
        
        if t(j,4)==i
            x0=t(j,1); y0=t(j,2); phi=t(j,3);
            x1 = x0 + length*cos(phi); y1 = y0 + length*sin(phi);
            x2 = x0 - length*cos(phi); y2 = y0 - length*sin(phi);
            
            plot(x0,y0,'r+');
            xset=[x2 x0 x1]; yset = [y2 y0 y1];
            plot(xset,yset,'b-','LineWidth',2);
            
            text(10,10,num2str(t(j,4)),'Color','white');
        end
    end
    
    hold off;
    f(i)=getframe(1,[0 0 size(rawimg,1) size(rawimg,2)]);
    pause(0.01);
end

mov=f;

movie(f)