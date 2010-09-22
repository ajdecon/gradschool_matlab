function [summary, fulldata] = group_backbone(bbimage,searchbox,scut)

% Takes an image produced by dt_percent_threshold and builds an array
% grouping neighboring pixels into particle backbones.  The data structures are as
% follows:
% pixels(y,x)=particle ID #
% pixelset(index, 1)=x
% pixelset(index, 2)=y
% pixelset(index, 3)=PID

[Ny,Nx]=size(bbimage);
pixels=zeros(Ny,Nx);

pindex=0;
for x=(2+searchbox):(Nx-searchbox-1)
    for y=(2+searchbox):(Ny-searchbox-1)
        
         if bbimage(y,x)>0
             
             for i=(x-searchbox):(x+searchbox)
                 for j=(y-searchbox):(y+searchbox)
                     if pixels(j,i)>0
                         pixels(y,x)=pixels(j,i);
                     end
                 end
             end
             
             if pixels(y,x)==0
                 pindex=pindex+1;
                 pixels(y,x)=pindex;
             end
                 
             
%             ul=pixels(y-1,x-1);
%             uu=pixels(y-1,x);
%             ur=pixels(y-1,x+1);
%             ll=pixels(y,x-1);
%             
%             if (ur>0)
%                 pixels(y,x)=ur;
%             elseif (ul>0)
%                 pixels(y,x)=ul;
%             elseif (uu>0)
%                 pixels(y,x)=uu;
%             elseif (ll>0)
%                 pixels(y,x)=ll;
%             else
%                 pindex=pindex+1;
%                 pixels(y,x)=pindex;
%             end
        end
    end
end

k=1;
for x=1:Nx
    for y=1:Ny
        
        if pixels(y,x)>0
            pset(k,1)=x;
            pset(k,2)=y;
            pset(k,3)=pixels(y,x);
            k=k+1;
        end
    end
end

fulldata = pset;

rows=size(pset, 1);
pcount = max(pset(:,3));

for i=1:pcount
    xsum(i)=0;
    ysum(i)=0;
    s(i)=0;
    for j=1:rows
        if pset(j,3)==i
            xsum(i)=xsum(i)+pset(j,1);
            ysum(i)=ysum(i)+pset(j,2);
            s(i)=s(i)+1;
        end
    end
    
    xcenter(i)=(1/s(i))*xsum(i);
    ycenter(i)=(1/s(i))*ysum(i);
end

xdiffsq=zeros(pcount);
xdiff=zeros(pcount);
ydiffsq=zeros(pcount);
ydiff=zeros(pcount);
lxrms=zeros(pcount);
lyrms=zeros(pcount);
phi=zeros(pcount);
crossp=zeros(pcount);

k=1;
for i=1:pcount
    xdiffsq(i)=0;
    xdiff(i)=0;
    ydiffsq(i)=0;
    ydiff(i)=0;
    for j=1:rows
        if pset(j,3)==i
            xdiffsq(i)=xdiffsq(i)+ ( pset(j,1)-xcenter(i) )^2;
            xdiff(i)=xdiff(i) + ( pset(j,1)-xcenter(i) );
            ydiffsq(i)=ydiffsq(i)+ ( pset(j,2)-ycenter(i) )^2;
            ydiff(i)=ydiff(i) + ( pset(j,2)-ycenter(i) );
            crossp(i)=crossp(i)+(xdiff(i)*ydiff(i));
        end
    end
    
    lxrms(i)= sqrt( (1/s(i))*xdiffsq(i) );
    lyrms(i)= sqrt( (1/s(i))*ydiffsq(i) );
    if (crossp(i)>0)
        phi(i) = atan(lyrms(i)/lxrms(i) );
    else
        phi(i) = (-1)*atan(lyrms(i)/lxrms(i) );
    end
    % cut out backbones which contain under a threshold number of pixels,
    % scut.
    if (s(i)>=scut)
        psum(k,:) = [xcenter(i) ycenter(i) phi(i) lxrms(i) lyrms(i) crossp(i) s(i)];
        k=k+1;
    end
end

summary = psum;
