SKIZdepth=input('number of images in sequence: '); %61
SKIZheight=input('height of images: '); %312
SKIZwidth=input('width of images: '); %346
THRESH=.2; %Threshold amount
FudgeFactor=2;
scrsz = get(0,'ScreenSize');
stack=zeros([SKIZheight SKIZwidth SKIZdepth]);
BWstack=zeros([SKIZheight SKIZwidth SKIZdepth]);



for count=1:SKIZdepth
    stack(:,:,count) = imread('BEADZ_INV.tif',count);%Probably not necessary
    BWstack(:,:,count) = im2bw(stack(:,:,count),THRESH);
end

InvDst=bwdist(~BWstack);
InvDst2=bwdist(BWstack);

Dst=-InvDst;
Dst(~BWstack) = -Inf;
Wtr = watershed(Dst,26);
WtrTrnsfrm = Wtr;

%Find a way to automatically detect background pixellation!!!!!
for w=1:SKIZwidth
    for h=1:SKIZheight
        for d=1:SKIZdepth
            if Wtr(h,w,d)==FudgeFactor
               WtrTrnsfrm(h,w,d)=0;
            end
        end
        d=1;
    end
h=1;
end


%%
%Makes Binary 3D matrix of Wtr, for Distance Transform
%Then takes a distance transform of total 3D backgroun
BWwtr=WtrTrnsfrm;

figure('Position', [scrsz(4)/2 scrsz(3) scrsz(3)/2 scrsz(4)/2]),
for d=1:SKIZdepth
    imshow(label2rgb(uint8(WtrTrnsfrm(:,:,d)),'jet'));
    pause(.1);
end
title ('Segmented Granules');

figure,
for d=1:SKIZdepth
    BWwtr(:,:,d) = im2bw(WtrTrnsfrm(:,:,d));
end

BWwtrDst=bwdist(BWwtr); %used for background subtraction at end
figure('Position', [scrsz(4)/2 scrsz(3) scrsz(3)/2 scrsz(4)/2]),
imshow(label2rgb(uint8(BWwtr(:,:,d))))
title ('Global Distance Transform')



%%
WtrSegment=WtrTrnsfrm;
TotalGranules=max(max((max(Wtr))));

GRANS=zeros([SKIZheight SKIZwidth SKIZdepth TotalGranules]);
for Granule=1:TotalGranules
%%
%This will take only a single granule from the Watertransform, then make it
%binary and take its distance transform, stored in GRANS
for w=1:SKIZwidth
    for h=1:SKIZheight
        for d=1:SKIZdepth
            if WtrTrnsfrm(h,w,d)==Granule
               WtrSegment(h,w,d)=1;
            end
            if WtrTrnsfrm(h,w,d)~=Granule
               WtrSegment(h,w,d)=0;
            end
        end
        d=1;
    end
h=1;
end
%%
GRANS(:,:,:,Granule)=bwdist(WtrSegment);
end   
%% Subtracts individual distance transform from total distance transform
Voronoi=GRANS;
Voronoi2=GRANS;
for i=1:TotalGranules
    Voronoi(:,:,:,i) = GRANS(:,:,:,i) - BWwtrDst;
    Voronoi2(:,:,:,i) = GRANS(:,:,:,i) - InvDst2;
    Voronoi(:,:,:,i)=255-Voronoi(:,:,:,i) - InvDst*333;%makes lowest hill into highest hill, making granule center brightest
    Voronoi2(:,:,:,i)=255-Voronoi2(:,:,:,i);
    %Voronoi(:,:,:,i)=imextendedmax(Voronoi(:,:,:,i),26)*i;
end

figure('Position', [scrsz(4)/2 scrsz(1) scrsz(3)/2 scrsz(4)/2]),
for k=1:SKIZdepth
imshow(label2rgb((uint8(Voronoi(:,:,k,10))),'jet'))
pause(.1);
end
title ('Local Void Region');
PureVoronoi=zeros([SKIZheight SKIZwidth SKIZdepth]);

maxVal = 0;
for j=1:SKIZwidth %interrogates and eliminates non 250 pixels
    for i=1:SKIZheight
       
        for k=1:SKIZdepth
             maxVal=0;
            for count=1:TotalGranules
                if Voronoi(i,j,k,count)> maxVal;
                    maxVal=Voronoi(i,j,k,count);
                    PureVoronoi(i,j,k)= count;            
                end
            end
            
        end
    end
end


figure('Position', [scrsz(2)/2 scrsz(1) scrsz(3)/2 scrsz(4)/2]),
for k=1:SKIZdepth
imshow(label2rgb((uint8(PureVoronoi(:,:,k))),'jet'))
pause(.1);
end
title ('Voronoi Void Region');

%So far I have made the background transform, called BWwtrDst and labelled
%each individual granules background and stored this transform in GRANS
%which is a 4D array, where the last column is the granule ID from the
%watershed transform at the beginning. Voronoi subtracts the Individual
%granules background from the total background, determining the voronoi
%map. To get the standard Vornoi volume, I need to find the pixels that are
%closest (255) to the granule and eliminate everything else, then squeeze
%into a 3D array from the 4D array and make an isosurface.
%% Imaging in 3D the voronoi volumes
image_num = 3;
image(PureVoronoi(:,:,image_num));
x=xlim;
y=ylim;
contourslice(PureVoronoi,[],[],image_num)
axis ij
xlim(x)
ylim(y)
daspect([1,1,1])
colormap(jet)
pause(1);
%layered contour images
phandles = contourslice(PureVoronoi,[],[],[1,2,3,4,5],8);
view(3); axis tight
set(phandles,'LineWidth',2)
pause(1);
%Isosurface
Ls = smooth3(PureVoronoi);
hiso = patch(isosurface(Ls,500),...
	'FaceColor',[1,.75,.65],...
	'EdgeColor','red');
hcap = patch(isocaps(Ls,100),...
	'FaceColor','interp',...
	'EdgeColor','none');
colormap(jet)
view(45,30) 
axis tight

daspect([1,1,.4])
%better rendering
lightangle(305,30); 
set(gcf,'Renderer','zbuffer'); lighting phong
isonormals(Ls,hiso)
set(hcap,'AmbientStrength',.6)
set(hiso,'SpecularColorReflectance',0,'SpecularExponent',50)
view(215,30);
