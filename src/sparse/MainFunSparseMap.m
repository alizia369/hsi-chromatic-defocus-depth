function [ nneidis,meanvalpat,patches,finalSparseMap,allSParseMapsPatches ] = MainFunSparseMap( normat,bandName )
%MAINFUNSPARSEMAP Summary of this function goes here
%   Detailed explanation goes here

dsz=size(normat);

%normat=removenoise(normat);
[edgesum,edgecube]=getedgecube(normat);


%% 

%%%%%%%%%%%%%% edge neighbour %%%%%%%%%%%
spectrastepedge=10;% monkey,board=10
strongedges=edgesum;
strongedges(edgesum>=spectrastepedge)=1;
strongedges(edgesum<spectrastepedge)=0;
figure,imshow(strongedges);

%% 

neisize=10;%original=5
[ patches ] = getpatches( neisize,strongedges );
%% 

%%%%%%%%%%%%%%%%%%check value of i

 %[ undercurveres ] = normaliseMap(SDisUnderCurve( patches,bandName,normat ));
 [ undercurveres ] = SDisUnderCurve( patches,bandName,normat );
 
 %[ Garresult ] = normaliseMap(Gradientfun( patches,neisize,bandName,normat ));
 [ Garresult ] = Gradientfun( patches,neisize,bandName,normat );
 
                    [ entresult, entresultmean] = entropyfun( patches,normat ); 
 %[entresultmean]= normaliseMap(entresultmean);
 
                   [ nDiffMap ] = SumofDifferenceMap( normat,edgesum );
%[ pDiff ] = normaliseMap(converttopatches( patches, nDiffMap));
[ pDiff ] = converttopatches( patches, nDiffMap);

                   [ nVOHMap ] = VarianceOfHistogramMap( normat,edgesum );
%[ pVOH ] =normaliseMap(converttopatches( patches, nVOHMap)); 
[ pVOH ] =converttopatches( patches, nVOHMap); 


figure,imagesc(undercurveres);
figure,imagesc(Garresult);
figure,imagesc(entresultmean);
figure,imagesc(pDiff);
figure,imagesc(pVOH);

allSParseMapsPatches(:,:,1)=undercurveres;
allSParseMapsPatches(:,:,2)=Garresult;
allSParseMapsPatches(:,:,3)=entresultmean;
allSParseMapsPatches(:,:,4)=pDiff;
allSParseMapsPatches(:,:,5)=pVOH;

toc
%% 

%%%%%%%%%Mainfold

totalp=max(patches(:));
 
 nneidis=zeros(2,totalp);
 depdis=zeros(5,totalp);
% alldata=[];
 for i=1:totalp
     [pir,pic]=find(patches==i);
     px=pic;
     py=pir;
     
     mpx=round(mean(px));
     mpy=round(mean(py));
     
     nneidis(:,i)=[mpx;mpy];
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%D2%%%%%%%%%%%%%%%%%%
       pind=find(patches==i);
       
       curval=mean(undercurveres(pind));
       graval=mean(Garresult(pind));
       entval=mean(entresultmean(pind));
       diffval=mean(pDiff(pind));
       vohval=mean(pVOH(pind));
       
       depdis(:,i)=[curval;graval;entval;diffval;vohval];
       
     
%      pind=find(patches==i); 
%      
%     
%    spdata=rnormat(pind,:);
%    spvec=spdata(:);
%    alldata=[alldata,spvec];
%     
   i
 end
 
 %%%%%%%%%%%%getting n  close(high value) depth points

% dnp= 10;
% mdepdis=mean(depdis); 
% [ b, ind ] = sort( mdepdis(:), 'descend' );
% 
% nnearpts=nneidis(:,ind(1:n));
% 
 addpath('./IsomapR1');
%  Dn = L2_distance(nnearpts, nneidis, 0); 
%  Dnn=L2_distance(Dn, Dn, 1); 
%%%%%%%%%
%addpath('./IsomapR1');

D1 = L2_distance(nneidis, nneidis, 1);
%D1 = L2_distance(Dn, Dn, 1);
D2 =L2_distance(depdis, depdis, 1); 
disp('Distance Matrices Generated');

D=D1.*D2;
%D=(D2);

options.dims = 1:4;

[Y, R, E] = Isomap(D, 'k', 6, options); 

%% 
oneDData=Y.coords{1};
figure,imagesc(oneDData);


if(length(Y.index)~=totalp)
    disp('Too many outliers');
    disp(['Total Patches=  ' num2str(totalp)]);
    disp(['Total Processed Patches=  ' num2str(length(Y.index))]);
    disp(['Total Processed Patches=  ' num2str(totalp-length(Y.index))]);
    

end    

minone=min(oneDData(:));
maxone=max(oneDData(:));
norone=(oneDData-minone)./(maxone - minone);


OneDresult=zeros(size(patches));

meanvalpat=zeros(1,totalp);
for i=1: totalp
pind=find(patches==i); 

OneDresult(pind)=ones(size(pind)).*norone(:,i);
meanvalpat(:,i)=mean(OneDresult(pind));
end

figure,imagesc(OneDresult);

finalSparseMap=OneDresult;




end

