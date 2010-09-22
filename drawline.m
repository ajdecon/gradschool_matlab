function drawline(bsum, length)
% bsum.m
% Draws centers and bonds based on backbone summary data.

% Important parts of backbone summary datastructure:
% bsum(PID,1)=xcenter
% bsum(PID,2)=ycenter
% bsum(PID,3)=phi

hold on;

pcount = size(bsum,1);

for i=1:pcount
    
    x0=bsum(i,1); y0=bsum(i,2); phi=bsum(i,3);
    x1 = x0 + length*cos(phi); y1 = y0 + length*sin(phi);
    x2 = x0 - length*cos(phi); y2 = y0 - length*sin(phi);
    xset=[x2 x0 x1]; yset = [y2 y0 y1];
    plot(x0,y0,'r+');
    plot(xset,yset,'b-','LineWidth',2);
    
end

hold off;