%%%%%%%%%%% should be done only once%%%%%%%% done in savecube already
% [numRows,numCols,numSpectra] = size(normat);
% scfact = mean(reshape(sqrt(sum(normat.^2,3)),numRows*numCols,1));
% normat = normat./scfact;
%%
I=normat;
eps=0.0000001;
r=1;
[h w c] = size(I);
% N = boxfilter(ones(h, w), r);
% meanI=zeros([h w c]);
% tic
% for i=1:c
% meanI(:,:,i) = boxfilter(I(:, :, i), r) ./ N;
% end
% count=1;
% varI=zeros([h w c*c]);
% for i=1:c
%     for j=1:c
%         varI(:,:,count)= boxfilter(I(:, :, i).*I(:, :, j), r) ./ N - meanI(:,:,i) .*  meanI(:,:,j);
%         count=count+1;
%     end
%     
% end
% 
% toc
%%

% I=normat;
% eps=0.0000001;
% r=1;
%  [h w c] = size(I);


wr = (2*r+1) * (2*r+1);
cc = zeros(h,w);
tlen=sum(sum(1-cc(r+1:end-r,r+1:end-r)))*(wr^2);
M_idx = reshape([1:h*w], h, w); 
vals=zeros(tlen,1);
vals2=zeros(tlen,1);
len = 0;

%vecpro=zeros([wr*wr c]);%81x34

vecpro=zeros([wr*wr 1]);

%%%%Spatial Distance
valpatchs=meanvalpat;
patchind=nneidis;%%%% nneidis from main Script
npat=10;
pindin=patchind';
%%%%%
xysize=[h w];

%%%%%%%%GPU%%%%
% smX=gpuArray(zeros([wr 1]));
% smY=gpuArray(zeros([wr 1]));
% SID=gpuArray(zeros([wr 1]));

%%%%%%%%%%Speedup
wrsq=wr*wr;

xLogTerm=zeros([wr*wr c]);%pw./pw(i,:);
xFTerm= zeros([wr*wr c]);%pw
            
yLogTerm=zeros([wr*wr c]);%pw(i,:)./pw;
yFTerm=zeros([wr*wr c]);%pw(i,:);

FullLog=zeros([2*wr*wr c]);
FullLogRes=zeros([2*wr*wr c]);


tic
for y=1+r:h-r
    for x=1+r:w-r

        win_idx = M_idx(y-r:y+r,x-r:x+r);
        win_idx=win_idx(:);
        
        winI=I(y-r:y+r,x-r:x+r,:);
        

        winI=reshape(winI,wr,c);
        
%%%Spatial Distance
%         [irow,icol]=ind2sub(xysize,win_idx);
%         winInd=[icol , irow];
%         pcol=pindin(:,1);
%         prow=pindin(:,2);
%         
%         xPix2Pat=pdist2(icol,pcol);
%         [x_sortval,x_sortind]=sort(xPix2Pat,2,'ascend');
%         x_nsortval=x_sortval(:,1:npat);
%         xPlenty=(sum(x_nsortval,2));
%         
%         yPix2Pat=pdist2(irow,prow);
%         [y_sortval,y_sortind]=sort(yPix2Pat,2,'ascend');
%         y_nsortval=y_sortval(:,1:npat);
%         yPlenty=(sum(y_nsortval,2));


%         winpixtopatdis = pdist2(winInd,patchind');
%         [winsortval,winsortind]=sort(winpixtopatdis,2,'ascend');
%         winnsortval=winsortval(:,1:npat);
%         %winnsortind=winsortind(:,1:npat);
%         %nvals=valpatchs(winnsortind);%value of patches
%         plenty=(sum(winnsortval,2));
        
%%%%%%Test variance can be removed
%          winILocNor=normaliseMap(winI);
%          winvar=var(winILocNor);
%         repmatvar=kron(winvar,ones(c,1));%34x34 reapeating row
%         matvar=sqrt(repmatvar.*repmatvar');
          %matvar=sqrt(sum(winvar(:)));
          
%           varvec=varI(y,x,:);
%           matvar=reshape(varvec,[c c]);
%           matvar=sum(matvar);
          %matvar=matvar + eps * eye(c);
%           
%           meanVec=meanI(y,x,:);
%           meanRow=reshape(meanVec,[1 c]);
%           winI=winI-meanRow(ones(wr,1),:);
%           
%          tvals=(1+winI*inv(matvar)*winI')/wr;

            matCov=cov(winI);
            matCovSum=sum(matCov);
          
%%%%%SID
         
         sumWinI=sum(winI,2);
         sumWinI(sumWinI==0)=0.000001;%To avoid NAN %added later
         pw=winI./sumWinI;
         

         %%%%try without loop
         pwrep=repmat(pw,wr,1);
         pwirep=kron(pw,ones(wr,1));%repeat each row n times
         
%          pwrep=pwrep*matCov;
%          pwirep=pwirep*matCov;
         
         xFTerm=pwrep;
         xLogTerm=pwrep-pwirep;%pwrep./pwirep;
         
         yFTerm=pwirep;
         yLogTerm=pwirep-pwrep;%pwirep./pwrep;
         
         
         %%%%%%
         
         

        
%          smX=(sum((xFTerm.*(xLogTerm+(matCovSum+0.00005))),2))/wr ;
%          smY=(sum((yFTerm.*(yLogTerm+(matCovSum+0.00005))),2))/wr ;

         smX=(sum((xFTerm.*(xLogTerm +sum(matCovSum)+0.00005)),2))/wr;
         smY=(sum((yFTerm.*(yLogTerm +sum(matCovSum)+0.00005)),2))/wr;

         
         SID=smX+smY;
         
         tvals=SID;
            

        
        % win_idx(:,ones(wr,1))<=>repmat(win_idx,1,wr)
        row_idx(1+len:wr^2+len)=reshape(win_idx(:,ones(wr,1)),wr^2,1);
        
        % t(ones(wr,1),:)<=>repmat(win_idx',wr,1)
        t = win_idx';
        col_idx(1+len:wr^2+len)=reshape(t(ones(wr,1),:),wr^2,1);
        
        vals(1+len:wr^2+len)=tvals(:);
        len=len+wr^2;
        
         
    end
end

toc
%%
vals=vals(1:len);
%%%%%%%%%%%%%%%%%%%%Normalise values %%%%%%%%
%vals=normaliseMap(vals);

row_idx=row_idx(1:len);
col_idx=col_idx(1:len);
Lsid=sparse(row_idx,col_idx,vals,h*w,h*w);
sumL=sum(Lsid,2);
Lsid=spdiags(sumL(:),0,h*w,h*w)-Lsid;

if(~issymmetric(Lsid))% if not symmetric due to round off error do the following
Lsid = (Lsid+Lsid.')/2; % make sure matrix is semetric without any roundoff error
end

%% %%%%%%%%%Testing
testd=diag(Lsid);
testimg=reshape(testd,[h w]);
testimg=full(testimg);
figure,imshow(testimg,[]);
%% %%%%%%%%%%%%%%%%%Testing2
testd=diag(Lsid,-1);
testimg2=reshape([testd ;0],[h w]);
testimg2=full(testimg2);
figure,imshow(testimg2,[]);

%% Sparse to Dense Map

%edgeMap=OneDresult;%dilatested;
std=1;
lambda=0.001;
maxBlur=3;
%sparseDMap=dilatested; %%% Can be changed
bspace=5;
nbands=size(normat,3);
%firstidx=1+bspace;
mididx=round((nbands-bspace*2)/2);

midBand=normat(:,:,mididx);

dedgemap=edge(midBand,'canny');

%%%%%%%%%%%%%%%%Morphology%%%%%%%%%%%
% se90 = strel('line', 3, 90);
% se0 = strel('line', 3, 0);
% 
% dedgemap = imdilate(dedgemap, [se90 se0]);
% figure, imshow(BWsdil), title('dilated gradient mask');


%figure,imshow(dedgemap);

%% Generate the sparse defocus map%%

% maindiag=diag(Lsid);
% diagimg=full(reshape(maindiag,[h w]));

%sparseDMap=(OneDresult.*dedgemap);
%sparseDMap=OneDresult.*dedgemap;

sparseDMap=zeros(size(dedgemap));
[irow,icol]=find(dedgemap~=0);%get all image indices
imgind=[icol , irow];
pixtopatdis = pdist2(imgind,patchind');
[sortval,sortind]=sort(pixtopatdis,2,'ascend');
nsortval=sortval(:,1:npat);
nsortind=sortind(:,1:npat);
     
nvals=valpatchs(nsortind);
     
imgvals=(sum(nvals,2))./(sum(nsortval,2));
ilinearInd = sub2ind(size(dedgemap), irow, icol);
sparseDMap(ilinearInd)=imgvals;%reshape(imgvals,size(strongedges));
%norresult=normaliseMap(sparseDMap);
%figure,imshow(norresult);     
%sparseDMap=normaliseMap(sparseDMap.^2);
figure,imshow(sparseDMap,[]);



%% Filter the spase defocus map to remove noise
[h,w,c]=size(normat);
sparseDMap(sparseDMap>maxBlur)=maxBlur;
sd=5; % spatial sigma
sr=0.1*maxBlur; % range sigma
[sparseDMap ~]=sparseBilateralFilter(sparseDMap,normat,sd,sr);
figure,imshow(sparseDMap,[]);
%% Propagate the spase defocus map based on color similarities to get full defocus map
sizeI=w*h;
constsMap=sparseDMap>0.0001;
%L=getLaplacian2(HsI,1); % calculated above
Lap=Lsid;%Lap2;%L;
D=spdiags(constsMap(:),0,sizeI,sizeI);

%%
% %%%%try pcg if you get out of memory error using the \ solver
% %%x=pcg(L+lambda*D,lambda*D*sparseDMap(:),1e-6,1000); 

x=(Lap+lambda*D)\(lambda*D*sparseDMap(:));  % Solve systems of linear equations Ax = B for x or x = A\B
fullDMap=reshape(x,h,w);

figure,imshow(fullDMap,[]);

