npat=10;
patchind=nneidis;%%%% nneidis from main Script
valpatchs=meanvalpat;

result=zeros(size(strongedges));
[irow,icol]=find(result>-1);%get all image indices
imgind=[icol , irow];
pixtopatdis = pdist2(imgind,patchind');
[sortval,sortind]=sort(pixtopatdis,2,'ascend');
nsortval=sortval(:,1:npat);
nsortind=sortind(:,1:npat);
     
nvals=valpatchs(nsortind);
     
imgvals=(sum(nvals,2))./(sum(nsortval,2));

result=reshape(imgvals,size(strongedges));
norresult=normaliseMap(result);
figure,imshow(norresult);  