                    %%%%%%%%%%%%%%%%%%%%%%%%%%%         Data               %%%%%%%%%%%%%%%%%%
                     
                    %%%%%%%%%%%%%%%%%%Tree Data%%%%%%%%%%
 datafolder='.\data\Depth Estimation\Trees\aliTrees\5x5treePark3_17\';
 filename=[datafolder '5x5treePark3_17.tif'];
 dpath='';% dark cube path need to be done later
 resultfolder='.\results\treeSmCam-5x5treePark3_17\';                      

                    

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               Code    %%%%%%%%%%%%%%%%%%%%%         

tic

[pathstr,name,ext] = fileparts(filename);
matfile=[pathstr '\' name '.mat'];

if(exist(matfile, 'file') == 2)

    load(matfile);
else


imageflag=true;%save original images
nOfBands=25;% Number od bands different small camera have different bands 5x5=25,4x4=16
[ normat, bandName ]=saveCube_smallCam(filename,nOfBands,dpath,imageflag); %save and normalise cube

 end
% sind=20;%original 20
% eind=53;%original 53
% normat=normat(:,:,sind:eind);
% bandName=bandName(sind:eind);


dsz=size(normat);

%normat=removenoise(normat);
%%
%[edgesum,edgecube]=getedgecube(normat);
edgecube=zeros(dsz);
for i = 1:dsz(3)
    
    slice = normat(:,:,i);
    %slice = imadjust(slice);   
    
    edgeMap=edge(slice,'canny');%current 0.30 previous 0.25

    edgecube(:,:,i)=edgeMap;
     
%     disp('edge');
%     i
end

edgesum=sum(edgecube,3);

%% 

%%%%%%%%%%%%%% edge neighbour %%%%%%%%%%%
spectrastepedge=5;% monkey,board=10
strongedges=edgesum;
strongedges(edgesum>=spectrastepedge)=1;
strongedges(edgesum<spectrastepedge)=0;
figure,imshow(strongedges);

%% 

neisize=3;%original=5
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


%% 
%Testing other projections 
%fourDdata=Y.coords{4};
% transdata=fourDdata-min(fourDdata(:));
% 
% %magData=sqrt(transdata(1,:).^2 + transdata(2,:).^2 + transdata(3,:).^2 + transdata(4,:).^2);
%  idx = kmeans(transdata',5);
%  %newidx=abs(idx-7);
%   
% result=patches;
% result2=patches;
% 
% for i=1: totalp
% pind=find(patches==i); 
% 
% %result(pind)=magData(i);
% result(pind)=idx(i);
% %result2(pind)=newidx(i);
% 
% end
% 
% 
% figure,imagesc(result);
%% 
%%%%%%%%%%%%%%%%%%%saving results%%%%%%%%%%%%%%%%

if(~isdir(resultfolder))
mkdir(resultfolder);
end
imwrite( ind2rgb(im2uint8(OneDresult), parula(256)), [resultfolder 'resultimagesc.png']);
imwrite( OneDresult,[resultfolder 'result.png']);

save([resultfolder 'workspace.mat']);


