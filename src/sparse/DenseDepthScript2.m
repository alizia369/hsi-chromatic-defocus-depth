
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
     
     pnind=patchind(:,nsortind);
     
     [spectralVal,spectralGrad]=spectralResults([mpx;mpy],pnind,normat);
     %if (spectralVal<2)      
         segval=(sum(nvals))./(sum(nsortval)*(spectralVal));%+spectralVal  
     %end   
     %segval=(sum(nvals))./(sum(nsortval));
     
     result(linind)=segval;
     
     
 end


figure,imagesc(result);
norresult=normaliseMap(result);
figure,imshow(norresult);


