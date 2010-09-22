function [orientplot,bondplot,dataplot,lt,numparticles] = orient_batch(imgstack,thsize,ersize,thresh,boxsize,search,scut,distance,binsize,bond1,bond2)

numimgs=size(imgstack,3);
numparticles=0;

dataplot = zeros(1,2);
bondtable = zeros(1,2);

for i=1:numimgs

 i
 'begin image processing!'
 th=imtophat(imgstack(:,:,i),strel('disk',thsize));
 thbw=im2bw(th,graythresh(th));
 er=imerode(thbw,strel('disk',ersize));
 dt=bwdist(~er);
 dt=(1/max(max(dt)))*dt;
 ' '
 'start finding backbones!'
 lt(:,:,i)=local_percent_threshold(dt,thresh,boxsize);
 [bsum,data]=group_backbone(lt(:,:,i),search,scut);
 numparticles=numparticles+size(bsum,1);
 ' '
 'now get orientations'
 [tplot,tdata,bonds]=orient_corr(bsum,distance,bond1,bond2);
 
 sz1=size(dataplot,1);
 sz2=size(tplot,1);
 sz3=size(bondtable,1);
 sz4=size(bonds,1);
 for j=1:sz2
   dataplot(j+sz1,:) = tplot(j,:);
 end
 for j=1:sz4
   bondtable(j+sz3,:)=bonds(j,:);
 end

end

[orientplot,bondplot]=meanplot(dataplot,bondtable,binsize);
