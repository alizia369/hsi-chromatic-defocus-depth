mainFolder='.\data\DepthEstimation snapscan\outside\';
resultFolder=[ mainFolder , 'Results\'];
D = dir([mainFolder , '*.mat']); % A is a struct ... first elements are '.' and '..' used for navigation.
 
for i = 1:length(D) % print folders and k values
 
 disp([num2str(i) '. ' D(i).name]);
end

k=2;
name=D(k).name;
load([mainFolder , name]);




normat=finalMat;


% for i=1:size(mat,3)
%    mat(:,:,i)=imadjust(mat(:,:,i)); 
% end

figure,imshow(normat(:,:,12));

%%
[ nneidis,meanvalpat,patches,finalSparseMap,allSParseMapsPatches ] = MainFunSparseMap( normat,bandName );


%% Save Data
[filepath,fname,ext]=fileparts(name);

imwrite( ind2rgb(im2uint8(finalSparseMap), parula(256)), [resultFolder fname '_SparseDepthResultimagesc.png']);

save([resultFolder fname '_SparseDepthResults.mat'],'nneidis','meanvalpat','patches','finalSparseMap','allSParseMapsPatches');

save([resultFolder fname '_SparseDepthWorkspace.mat']);