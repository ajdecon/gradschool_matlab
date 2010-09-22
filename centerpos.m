function [x0,y0]=centerpos(mask)

sizex=size(mask,2);
sizey=size(mask,1);

sumx=0;
sumy=0;
numwhite=0;

for i=1:sizex
    for j=1:sizey
        test=mask(j,i);
        if (test>0)
            sumx=sumx+i;
            sumy=sumy+j;
            numwhite=numwhite+1;
        end
    end
end

x0=sumx/numwhite;
y0=sumy/numwhite;