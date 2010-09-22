function pairs=dna_pairing(img,positions,intensities)

% pairs data structure:
%   Each pair has its own matrix. 
%   Column 1 is time.
%   Columns 2 and 4 are the particle labels..
%   Columns 3 and 5 are the intensities.
%   Column 6 is the ratio of the intensities, side1/side2.

numspots=max(positions(:,4));
strcat('Number of measureable spots found=',num2str(numspots))

pairs=[0,0,0,0,0,0];
p=0;

for n=1:numspots
    if (find(pairs(:,2,:)==n)) 
        continue;
    end
    if (find(pairs(:,4,:)==n))
        continue;
    end
    trace=find( positions(:,4)==n );
    t=positions(trace(1),3);
    current=positions( find( positions(:,3)==t), :);
    imagesc(img(:,:,t));
    colormap('gray');axis image;hold on;
    for i=1:size(current,1)
          plot(current(i,1),current(i,2),'r+');
          h=text(current(i,1),current(i,2),num2str(current(i,4)));
          set(h,'Color','c');
          set(h,'FontWeight','bold');
          if (current(i,4)==n)
            set(h,'Color','g');
            
          end
    end
    hold off;
    
    ' '
    strcat('Position ', num2str(n))
    side=input('Type 1 for side 1, 2 for side 2, or 0 for an invalid point.');
    if (side==0)
        %positions( find( positions(:,4)==n ), :) =[];
        %intensities( find( intensities(:,4)==n ), :) =[];
        continue;
    else
        partner=input('Type the number of the partner of this point, or 0 for no partner.');
        if (partner==0)
            continue;
        else
            p=p+1;
        end
    end
    
    if (side==1)
        side1=intensities( find(intensities(:,1)==n), :);
        side2=intensities( find(intensities(:,1)==partner), :);
    else
        side1=intensities( find(intensities(:,1)==partner), :);
        side2=intensities( find(intensities(:,1)==n), :);
    end
    
    if (side1(1,2) <= side2(1,2)) 
        t0=side2(1,2);
    else
        t0=side1(1,2);
    end
    tf=max(side1(:,2));
    
    k=0;
    for t=t0:tf
        k=k+1;
        pairs(k,1,p)=t;
        pairs(k,2,p)=side1(1,1);
        pairs(k,4,p)=side2(1,1);
        pairs(k,3,p)=side1(find(side1(:,2)==t),3);
        pairs(k,5,p)=side2(find(side2(:,2)==t),3);
        pairs(k,6,p)=pairs(k,3,p)/pairs(k,5,p);
    end
    
end