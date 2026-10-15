
%%%%%%%%% Need to run main Script before this %%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%testing morphological operations%%%%%%%
% figure,imshow(strongedges);
% 
% se = strel('disk',2);
% 
% % closested = imclose(strongedges,se);
% % opensted = imopen(strongedges,se);
% % figure, imshow(closested);
% % figure, imshow(opensted);
% 
% dilatested = imdilate(strongedges,se);
% figure,imshow(dilatested);
% 
% se = strel('disk',1);
% erodested = imerode(dilatested,se);
% figure,imshow(erodested);

%%%%%%%%%%%%%% result to edges

figure,imagesc(OneDresult);
maniedgresult=OneDresult.*strongedges;

figure,imagesc(maniedgresult);

se = strel('disk',1);
dilatested = imdilate(maniedgresult,se);

figure,imagesc(dilatested);

%% 
% [ dedgesum ] = edgesumwithsig( normat,0.1 );%%%%original was 0.3
% figure,imshow(dedgesum);
% 
% dspectrastepedge=1;
% dstrongedges=dedgesum;
% dstrongedges(dedgesum>=dspectrastepedge)=1;
% dstrongedges(dedgesum<dspectrastepedge)=0;
% figure,imshow(dstrongedges);

%% 


% steddilres=dstrongedges+dilatested;
% se2 = strel('disk',1);
% dilatested2 = imdilate(steddilres,se2);
% 
% figure,imagesc(dilatested2);
% 
% nordilatested2=dilatested2./max(dilatested2(:));
% figure,imagesc(nordilatested2);



%% 
%%%%%%%%%%%super pixel and crf %%%%%%%%%%%%%

normatsig=im2single(normat);
 %img=normatsig(:,:,30);
 
 spsize=30;
 
 segments = vl_slic(normatsig, spsize, 0.01, 'verbose') ;
 
 
 %% 
 
 totalseg=max(segments(:));
 
 result=zeros(size(segments));
 
 valpatchs=meanvalpat;
 patchind=nneidis;%%%% nneidis from main Script
 
 segind=zeros(2,totalp);
 npat=10;
 
 for i=1:totalseg
    
     linind=find(segments==i);
    % segvals=dilatested(ind);
     
    % result(ind)=m(segvals);     
     [pir,pic]=find(segments==i);
     px=pic;
     py=pir;
     
     mpx=round(mean(px));
     mpy=round(mean(py));
     
     segind(:,i)=[mpx;mpy];
     curseg=segind(:,i)';
     
     segtopatdis = pdist2(curseg,patchind');
     [sortval,sortind]=sort(segtopatdis,'ascend');
     nsortval=sortval(1:npat);
     nsortind=sortind(1:npat);
     
     nvals=valpatchs(nsortind);
     
     segval=(sum(nvals))./(sum(nsortval));
     
     result(linind)=segval;
     
     
 end


figure,imagesc(result);
norresult=normaliseMap(result);
figure,imshow(norresult);

%%
%%%%%%%%%%%%%%%%%%%%%% smoothing and material properties %%%%%%
totalseg=max(segments(:));
ssz=size(segments);
padded_segments=-1*ones(ssz(1)+6,ssz(2)+6);
   
padded_segments(4:ssz(1)+3,4:ssz(2)+3)=segments;
psz=size(padded_segments);

result2=result;
newedgemap=edge(normat(:,:,22),'canny',0.15);

 for i=1:totalseg
    
     linind=find(segments==i);
     centerind=linind(ceil(end/2));
     [rr,cc]=ind2sub(ssz,centerind);
     curVec=squeeze(normat(rr,cc,:));
    % segvals=dilatested(ind);
    [ connected_neighbours ] = ConnectedNeighbours( padded_segments,psz,i );
    nval=zeros(size(connected_neighbours)); 
    nSpecDis=zeros(size(connected_neighbours)); 
    for j=1:length(connected_neighbours)
            nind=find(segments==connected_neighbours(j));
            nval(j)=norresult(nind(ceil(end/2)));
           
            %%%%%%%% spectral angel
            cenNeiInd=nind(ceil(end/2));
            [rn,cn]=ind2sub(ssz,cenNeiInd);
            neiVec=squeeze(normat(rn,cn,:));
            nSpecDis(j)=Spectral_Angle(curVec,neiVec);
            
    end
     w1=1;
     w2=var(nval);
     calratio=(w1.*(nval))+((w2.*(1-nSpecDis)));
%    calratio=nval./(nSpecDis.*var(nval));
    sumratio=mean(calratio);
    %meanval=mean(nval);
    %varval=var(meanratio);
     
%      nval
%      nSpecDis
%      calratio
     
     result2(linind)=sumratio;
     
 end
 
figure,imagesc(result2);
norresult2=normaliseMap(result2);
figure,imshow(norresult2);

