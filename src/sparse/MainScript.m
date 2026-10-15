                    %%%%%%%%%%%%%%%%%%%%%%%%%%%         Data               %%%%%%%%%%%%%%%%%%
                     
                    %%%%%%%%%%%%%%%%%%Lab Data3%%%%%%%%%%
 datafolder='.\data\Depth Estimation\LabData3\objs3\';
 filename=[datafolder 'objs3.dat'];
 dpath='.\data\Depth Estimation\labData\darkcube.dat';
 resultfolder='.\results\labData3-objs3\';                      

                    
                    
%                      %%%%%%%%%%%%%%%%%%rooftop hyper%%%%%%%%%%
%  datafolder='.\data\Depth Estimation\rooftop hyper\penswall_exp500\';
%  filename=[datafolder 'penswall_exp500.dat'];
%  dpath='.\data\Depth Estimation\labData\darkcube.dat';
%  resultfolder='.\results\rooftop-penswall_exp500\';                      
                     
                     
                    
%                                        %%%%%%%%%%%%%%%%%%outdoor%%%%%%%%%%
%  datafolder='.\data\Depth Estimation\outdoor\scene3\';
%  filename=[datafolder 'scene3.dat'];
%  dpath='.\data\Depth Estimation\labData\darkcube.dat';
%  resultfolder='.\results\outdoor-scene3\';                    
                    
                    
%                                        %%%%%%%%%%%%%%%%%%rooftop2%%%%%%%%%%
%  datafolder='.\data\Depth Estimation\rooftop2\objs4\';
%  filename=[datafolder 'objs4.dat'];
%  dpath='.\data\Depth Estimation\labData\darkcube.dat';
%  resultfolder='.\results\rooftop2-objs4\';
                      
                    
                                      %%%%%%%%%%%%%%%%%%white puzzle -lab 10%%%%%%%%%%
%  datafolder='.\data\Depth Estimation\Lab 10\woverlap\';
%  filename=[datafolder 'woverlap.dat'];
%  dpath='.\data\Depth Estimation\labData\darkcube.dat';
%  resultfolder='.\results\whitePuzzleOverlap\';
                                      %%%%%%%%%%%%%%%%%%white puzzle -lab 10%%%%%%%%%%
%  datafolder='.\data\Depth Estimation\Lab 10\whitepuzzle\';
%  filename=[datafolder 'whitepuzzle.dat'];
%  dpath='.\data\Depth Estimation\labData\darkcube.dat';
%  resultfolder='.\results\whitepuzzle\';
                    
%                   %%%%%%%%%%%%%%%%%%Board%%%%%%%%%%
%  datafolder='.\data\Depth Estimation\Final\board2_f-8\';
%  filename=[datafolder 'board2_f-8.dat'];
%  dpath='.\data\Depth Estimation\labData\darkcube.dat';
%  resultfolder='.\results\board2_f-8\';

                    
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%% Old Monkey with mix objects %%%%%%%%%%%%%%%%%%

%  datafolder='.\data\Depth Estimation\labData\objectslab_f-5.6-2_focus600\';
%  filename='.\data\Depth Estimation\labData\objectslab_f-5.6-2_focus600\objectslab_f-5.6-2_focus600.dat';
%  dpath='.\data\Depth Estimation\labData\darkcube.dat';
%  resultfolder='.\results\oldmonkeywithmixobjects-objectslab_f-5.6-2_focus600\';

                     %%%%%%%%%%%%%%%%%%%%%%%%%% New Monkey with mix objects %%%%%%%%%%%%%%%%%%
% datafolder='.\data\Depth Estimation\Lab9\objs1\';
% filename='.\data\Depth Estimation\Lab9\objs1\objs1.dat';
% dpath='.\data\Depth Estimation\Lab 10\darkcube.dat';

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               Code    %%%%%%%%%%%%%%%%%%%%%         

tic

[pathstr,name,ext] = fileparts(filename);

matfile=[pathstr '\' name '.mat'];

if(exist(matfile, 'file') == 2)

    load(matfile);
else


imageflag=true;%save original images
[ normat, bandName ]=saveCube(filename,dpath,imageflag); %save and normalise cube

 end
sind=20;%original 20
eind=53;%original 53
normat=normat(:,:,sind:eind);
bandName=bandName(sind:eind);

%%

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
%resultfolder='.\results\oldmonkeywithmixobjects-objectslab_f-5.6-2_focus600\';%move to top
if(~isdir(resultfolder))
mkdir(resultfolder);
end
imwrite( ind2rgb(im2uint8(OneDresult), parula(256)), [resultfolder 'resultimagesc.png']);
imwrite( OneDresult,[resultfolder 'result.png']);
% save([resultfolder 'normat.mat'],'normat');
% save([resultfolder 'edgeinfo.mat'],'edgesum','edgecube','strongedges');
% save([resultfolder 'methods.mat'],'undercurveres','Garresult','entresultmean','pDiff','pVOH');
% save([resultfolder 'manifoldD1D2.mat'],'OneDresult');
save([resultfolder 'workspace.mat']);


