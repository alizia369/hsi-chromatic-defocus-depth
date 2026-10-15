function [ varresult ] = Gradientfun( patches,neisize,bandName,normat )
%GRADIENTFUN Summary of this function goes here
%   Detailed explanation goes here

totalp=max(patches(:));
bnames=bandName;
csz=size(normat);
%res=patches;

blurcube2=imfilter(normat, fspecial('disk',3), 'symmetric', 'conv');

varresult=zeros(csz(1),csz(2));
%graresult=zeros(csz(1),csz(2));

for i=1:totalp
   
    pind=find(patches==i); 
     
    
   %spdata=normat(pind,:);
   
   gpat=zeros([neisize*2+1 neisize*2+1 csz(3)]);
   
   edvect=zeros(size(bnames));
   
   for j=1:csz(3)
    
       % slc=normat(:,:,j); 
       slc=blurcube2(:,:,j);
        vslc=slc(pind);
        tempslc=reshape(vslc,[neisize*2+1 neisize*2+1]);
        minvar=min(tempslc(:));
        maxvar=max(tempslc(:));
        
        norslc=(tempslc-minvar)./(maxvar-minvar);
        
        gpat(:,:,j)=norslc;
        
%         edslc=edgecube(:,:,j);
%         ved=edslc(pind);
%         edpts=numel(find(ved>0));
%         edvect(j)=edpts;
   end

    %blurpat=imfilter(gpat, fspecial('disk',3), 'symmetric', 'conv');
    
    [grx gry grz]=gradient(gpat);
   % [bgx bgy bgz]=gradient(blurpat); %does not make much difference
    
    gm=sqrt((grx).^2+(gry).^2);
   % bgm=sqrt((bgx).^2+(bgy).^2);
    %gm
    %bgm
%    smag=gm.*bgm;
   % smag
   % zmag=grz.*bgz;
    
%     sumgra=sum(smag,3);%./sum(edvect);
   %  zmagdiff=abs(sum(diff(zmag,1,3),3));
     
%     sumgra(isinf(sumgra))=0;
%     sumgra(isnan(sumgra))=0;
    %figure,plot(bnames,);
%    varresult(pind)=sumgra ;

    czgra=squeeze(grz(neisize+1,neisize+1,:));
    
    [mval,mind]=max(czgra(:));
    is=5;
    ie=5;
    
    if ((mind-is)<1)
        is=mind;
    end
    if((mind+ie>numel(czgra)))
        ie=numel(czgra)-mind;
    end
    
    ptsup=czgra(mind-is+1:mind);
    ptsdown=czgra(mind:mind+ie);
    
    minup=min(ptsup(:));
    maxup=max(ptsup(:));
        
    norup=(ptsup-minup)./(maxup-minup);
        
    mindown=min(ptsdown(:));
    maxdown=max(ptsdown(:));
    nordown=(ptsdown-mindown)./(maxdown-mindown);
    
%     numel(norup)
%     is
%     numel(nordown)
%     tie=ie+1
    
    upval=0;
    if(numel(norup)>0)
    upval=((sum((diff(norup))))./numel(norup) );
    end
    downval=0;
    if(numel(nordown)>0)
     downval=((sum((diff(nordown))))./numel(nordown) );
    end
    
    zval=abs(upval)+abs(downval);
    %zval=abs(downval);
   %zval=abs((sum((diff(czgra(mind-is+1:mind))))./is ))+ abs((sum((diff(czgra(mind:ie))))./(ie-mind)));
   % zval= abs((sum((diff(czgra(mind-is+1:mind)))) ))+ abs((sum((diff(czgra(mind:ie))))));
 
    
   % czgra
    sumgra=sum(gm,3);
    
    xcov=cov(sumgra);
    ycov=cov(sumgra');
    
    tdiag=diag(xcov)+diag(ycov);
%     mindig=min(tdiag(:));
%     maxdig=max(tdiag(:));
%     nortdiag=(tdiag-mindig)./(maxdig-mindig);
    
    varval=sum(tdiag)./numel(tdiag);
    if(isnan(varval))
        varval=0;
    end
     if(isnan(zval))
         zval=0;
     end

    varresult(pind)=varval+zval;%varval+zval;
    %graresult(pind)=sumgra;

 %   i
end

%figure,imagesc(varresult);
%figure,imagesc(graresult);


end

