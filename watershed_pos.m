function pos = watershed_pos(img,cutoff)

k=0;

for f=1:size(img,3)
    
    BW=im2bw(img(:,:,f),graythresh(img(:,:,f)));
    E=imopen(BW,strel('disk',2));
    D=imhmin(-bwdist(~E),1);
    W=watershed(D);
    W(E==0)=0;
    
    for n=1:max(max(W))
        
        k=k+1;
        temp=W;
        temp(temp~=n)=0;
        temp(temp~=0)=1;
        
        if sum(sum(temp))<cutoff
            continue
        end
        
        [y,x]=ind2sub(size(temp),find(temp));
        y0=mean(y); x0=mean(x);
        
        xd=sum(x-x0); xd2=sum((x-x0).^2);
        yd=sum(y-y0); yd2=sum((y-y0).^2);
        crossp=sum((x-x0).*(y-y0));
        lx=sqrt(xd2); ly=sqrt(yd2);
        
        if crossp>0
            phi=atan(ly/lx);
        else
            phi=(-1)*atan(ly/lx);
        end
        
        pos(k,1)=x0;
        pos(k,2)=y0;
        pos(k,3)=phi;
        pos(k,4)=f;
        pos(k,5)=sum(sum(temp));
        
    end
    
    if mod(f,10)==0
        disp(f)
    end
    
end
