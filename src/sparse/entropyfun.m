function [ entresult, entresultmean] = entropyfun( patches,normat )
%ENTROPYFUN Summary of this function goes here
%   Detailed explanation goes here
 dsz=size(normat);
 blurcube=imfilter(normat, fspecial('disk',10), 'symmetric', 'conv');

diffcube=normat-blurcube;

nordiffcube=zeros(dsz);
entcube=zeros(dsz);
for i=1:dsz(3)
    band=diffcube(:,:,i);
    minval=min(band(:));
    maxval=max(band(:));
    
    nordiffband=(band-minval)./(maxval-minval);
    nordiffcube(:,:,i)=nordiffband;
    
    entcube(:,:,i)=entropyfilt(nordiffband);
    
end
 sument=sum(entcube,3);
 
 

 %% 


totalp=max(patches(:));

csz=size(normat);
%res=patches;


entresult=zeros(csz(1),csz(2));
entresultmean=zeros(csz(1),csz(2));
%graresult=zeros(csz(1),csz(2));

for i=1:totalp
   
    pind=find(patches==i); 
    
        patchpts= sument(pind);
        
        entresult(pind)=patchpts;
        entresultmean(pind)=mean(patchpts);
    
end

% figure,imagesc(entresult);
% figure,imagesc(entresultmean);
end

