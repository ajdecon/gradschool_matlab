function connect_circles(dbs)
% connect_circles.m
% Draws bonds between halves of dumbbell particles.
% You should issue the command imshow(image) first.

hold on;

numc= size(dbs,1);

for i=1:numc
   
    if dbs(i,7)==0 || dbs(i,3)==0;
        continue;
    end
    xset = [dbs(i,1) dbs(i,4)];
    yset = [dbs(i,2) dbs(i,5)];
    plot(xset,yset,'r-');
end
plot(dbs(:,1), dbs(:,2), 'b+');
hold off;