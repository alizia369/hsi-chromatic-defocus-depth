function[sumAngle,sumGrad]=spectralResults(superIndex,patchIndex,datacube)
numPatch=size(patchIndex,2);
sum1=0;
sum2=0;

yS=superIndex(1); %superIndex(2) withsuperPixel
xS=superIndex(2); %superIndex(1) withsuperPixel
vect1=squeeze(datacube(xS,yS,:));
for i=1:numPatch
%     [r,c]=ind2sub([size(datacube,1),size(datacube,2)],patchIndex(i));
    r=patchIndex(1,i);
    c=patchIndex(2,i);
    vect2=squeeze(datacube(c,r,:));    
    sum1=sum1+Spectral_Grad_Angle(vect1,vect2);
    sum2=sum2+Spectral_Angle(vect1,vect2);
end    
sumGrad=sum1;
sumAngle=sum2;
end