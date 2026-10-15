function [ patchresult ] = converttopatches( patches, dmap)
%CONVERTTOPATCHES Summary of this function goes here
%   Detailed explanation goes here


totalp=max(patches(:));

csz=size(dmap);
%res=patches;


patchresult=zeros(csz(1),csz(2));
%entresultmean=zeros(csz(1),csz(2));
%graresult=zeros(csz(1),csz(2));

for i=1:totalp
   
    pind=find(patches==i); 
    
   patchpts= dmap(pind);
        
        
        patchresult(pind)=sum(patchpts);
    
end


end

