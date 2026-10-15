function [edgesum,edgecube]=getedgecube(normat,thresh,startInd,endInd)

%GETEDGECUBE Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    thresh=0.30;%previous 0.25
    startInd=1;
    sz=size(normat);
    endInd=sz(3);
end

sz=size(normat);

edgecube=zeros(sz);
normat=removenoise(normat);

for i = startInd:endInd
    
    slice = normat(:,:,i);
    %slice = imadjust(slice);   
    
    edgeMap=edge(slice,'canny',thresh);%current 0.30 previous 0.25

    edgecube(:,:,i)=edgeMap;
     
%     disp('edge');
%     i
end

edgesum=sum(edgecube,3);

%edgesum(edgesum>1)=1;

%figure,imshow(sumedg);




end

