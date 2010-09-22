function [poslist,cirrad]=HoughList(img,radrange,plot)


    [accum,circen,cirrad]=CircularHough_Grd(img(:,:),radrange);
    
    % First, remove duplicates.
    k=0;
    rem_ind = [];
    for i=1:size(circen,1)
        x0=circen(i,1);
        y0=circen(i,2);
        for j=i:size(circen,1)
            x1=circen(j,1);
            y1=circen(j,2);
            dist=sqrt((x1-x0)^2 + (y1-y0)^2);
            if ((dist<min(radrange)) && (i~=j))
                k=k+1;
                rem_ind(k)=j;
            end
        end
    end
    circen(rem_ind,:)=[];
    cirrad(rem_ind)=[];
    
    if (plot>0)
    imagesc(img);
    colormap('gray');axis image;hold on;
    for k=1:size(circen,1),DrawCircle(circen(k,1),circen(k,2),cirrad(k),32,'b-');end;
    for i=1:size(circen,1)
        h=text(circen(i,1),circen(i,2),num2str(i));
        set(h,'Color','g');
        set(h,'FontWeight','bold');
    end
    hold off;
    end

poslist=circen;