function DataCube=X2Cube(I)
%Input Ximea 1088*2048 image
%Output 256*512*14 datacube
block=4;
I=double(I);
%bandNumber=16; %Total number of Bands
% black=double(imread('black.bmp'));
% I=I(:,:,1)-black(:,:,1);
[x,y]=size(I);

%DataCube = im2colstep(I,[block block],[block,block]);
DataCube = im2colstep(I',[block block],[block,block]);
%size(DataCube)

%sz=[y/block, x/block  bandNumber];

%sz=[x/block, y/block  size(DataCube,1)];
sz=[y/block, x/block  size(DataCube,1)];%size(DataCube,1=16 whihch is band number

DataCube=reshape(DataCube',sz);
%size(DataCube)
DataCube=permute(DataCube,[2,1,3]);
%size(DataCube)
end
