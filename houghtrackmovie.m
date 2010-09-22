function last=houghtrackmovie(img,t,timerange)

for j=timerange
    imagesc(img(:,:,j));
    colormap('gray');axis image;hold on;
    title(num2str(j));
    for i=1:size(t,1)
        if (t(i,3)==j)
          plot(t(i,1),t(i,2),'r+');
          h=text(t(i,1),t(i,2),num2str(t(i,4)));
          set(h,'Color','g');
          set(h,'FontWeight','bold');
        end
    end
    
    
    now=[];z=0;
    for i=1:size(t,1)
        if (t(i,3)==j)
            z=z+1;
            now(z,1)=t(i,1); now(z,2)=t(i,2);
        end
    end
%     lines=0;
%     for i=1:size(now,1)
%         x0=now(i,1);y0=now(i,2);
%         for k=i:size(now,1)
%             x1=now(k,1);y1=now(k,2);
%             d=sqrt((x1-x0)^2+(y1-y0)^2);
%             %z=z+1;
%             %dists(z)=d;
%             
%             if ( (d<67) && (d>62) )
%                 p0=[x0,x1]; p1=[y0,y1];
%                 plot(p0,p1,'r-');
%                 lines=lines+1;
%             end
%         end
%     end
     title(strcat('Frame=',num2str(j)));
        hold off;
        pause(0.05);
    
end

%last=dists;

        