function DataCube=q(I)
%Input Ximea 1088*2048 image
%Output 272*512*14 datacube
block=5;
I=double(I);
I=I(4:3+1080,1:2045);
% black=double(imread('black.bmp'));
% I=I(:,:,1)-black(:,:,1);
[x,y]=size(I);
DataCube = im2colstep(I',[block block],[block,block]);
DataCube=DataCube';
CorrectionMatrix=load('cormat_5_6_11_5.mat');
CorrectionMatrix=CorrectionMatrix.cormat;
DataCube=CorrectionMatrix*DataCube';
DataCube=max(DataCube,eps);
%sz=[size(I,1)/block size(I,2)/block];
sz=[y/block x/block];
DataCube=reshape(DataCube',[sz(1:2),size(CorrectionMatrix,1)]);
DataCube=permute(DataCube,[2,1,3]);
end