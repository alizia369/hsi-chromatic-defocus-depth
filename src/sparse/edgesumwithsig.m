function [ edgesum ] = edgesumwithsig( normat,sig )
%EDGESUMWITHSIG Summary of this function goes here
%   Detailed explanation goes here
sz=size(normat);

edgecube=zeros(sz);
normat=removenoise(normat);

for i = 1:sz(3)
    
    slice = normat(:,:,i);
    %slice = imadjust(slice);   
    
    edgeMap=edge(slice,'canny',sig);%previous 0.25
    %edgeMap=edge(slice,'canny');
    
    edgecube(:,:,i)=edgeMap;
     
%     disp('edge');
%     i
end

edgesum=sum(edgecube,3);

end

