function [ nVOHMap ] = VarianceOfHistogramMap( normat,edgesum,strongedge,neighbourhoodsize,histogrambins )
%VARIANCEOFHISTOGRAM Summary of this function goes here
%   Detailed explanation goes here
tic

if nargin < 3
    strongedge=5;%10;%10
    neighbourhoodsize=8;%8
    histogrambins=15;%15

    
end


sz=size(normat);

ns=neighbourhoodsize;%neighbourhood size
histbins=histogrambins;% Number of Histogram bins

[r,c]=find(edgesum>=strongedge); % 5 is fine as well

histcube=zeros(sz(1),sz(2),sz(3));
allbins=-1*ones(histbins,sz(3));
    
    for i=1:length(r)
        
        rmin=r(i)-ns;
        if(rmin<=0)
        rmin=1;
        end
        
        rmax=r(i)+ns;
        if(rmax>sz(1))
        rmax=sz(1);
        end
        
        cmin=c(i)-ns;
        if(cmin<=0)
        cmin=1;
        end        
        
        cmax=c(i)+ns;
        if(cmax>=sz(2))
           cmax=sz(2); 
        end
        
        
        npix=normat(rmin:rmax,cmin:cmax,:);%neighbourhood pixels
        szn=size(npix);
        npix2=reshape(npix,szn(1)*szn(2),szn(3));
        %allbins=[];
        
        for j=1:sz(3)
        [counts,centers] = hist(npix2(:,j),histbins);
        
        allbins(:,j)=counts';
        
        end
        varhist=var(allbins);
        histcube(r(i),c(i),:)=varhist;

        
%          sqrld2=varhist.^2;
%         sumld2=sum(sqrld2);
%         spimg(r(i),c(i))=sqrt(sumld2);
    end


toc

%figure,imagesc(spimg);%,colormap(hot);





%%%%%%%%%%%Normalization

% [ norlocalDmap2 ] = normaliseandSmoothLDmap( spimg);
% 
% figure,imagesc(norlocalDmap2);%,colormap(hot);

    spcubemap=histcube;
    VarhistCube=spcubemap;
    sqrld=VarhistCube.^2;
    sumld=sum(sqrld,3);
    VOHMap=sqrt(sumld);

    [ nVOHMap ] = normaliseMap( VOHMap );
end

