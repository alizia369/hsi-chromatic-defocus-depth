%%%%%%%%%%%%%% result to edges

figure,imagesc(OneDresult);
maniedgresult=OneDresult.*strongedges;

figure,imagesc(maniedgresult);

se = strel('disk',1);
dilatested = imdilate(maniedgresult,se);

figure,imagesc(dilatested);

%% whole Image pixel by pixel
valpatchs=meanvalpat;
patchind=nneidis;%%%% nneidis from main Script
npat=10;

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
     



%%
%%%%%%%%%%%%%%%% Matting %%%%%%%%






%%
%%%%%%%%%%%super pixel and crf %%%%%%%%%%%%%

% normatsig=im2single(normat);
%  %img=normatsig(:,:,30);
%  
%  spsize=30;
%  
%  segments = vl_slic(normatsig, spsize, 0.01, 'verbose') ;
%  
%  
%  %% 
%  
%  totalseg=max(segments(:));
%  
%  result=zeros(size(segments));
%  
%  valpatchs=meanvalpat;
%  patchind=nneidis;%%%% nneidis from main Script
%  
%  segind=zeros(2,totalp);
%  npat=10;
%  
%  for i=1:totalseg
%     
%      linind=find(segments==i);
%     % segvals=dilatested(ind);
%      
%     % result(ind)=m(segvals);     
%      [pir,pic]=find(segments==i);
%      px=pic;
%      py=pir;
%      
%      mpx=round(mean(px));
%      mpy=round(mean(py));
%      
%      segind(:,i)=[mpx;mpy];
%      curseg=segind(:,i)';
%      
%      segtopatdis = pdist2(curseg,patchind');
%      [sortval,sortind]=sort(segtopatdis,'ascend');
%      nsortval=sortval(1:npat);
%      nsortind=sortind(1:npat);
%      
%      nvals=valpatchs(nsortind);
%      
%      segval=(sum(nvals))./(sum(nsortval));
%      
%      result(linind)=segval;
%      
%      
%  end
% 
% 
% figure,imagesc(result);
% norresult=normaliseMap(result);
% figure,imshow(norresult);
