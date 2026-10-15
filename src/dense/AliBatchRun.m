% Ali code-My dense estimation 

%% Shaojie Zhou - Defocus Map Estimation from a Single Defocused Image
clear;
codeDir=cd;
mainDataFolder='.\data\Depth Estimation\my Depth code7\results\newResults20-7-2019';

resultFolder= '.\resultsProposed1\';

D = dir(mainDataFolder); % A is a struct ... first elements are '.' and '..' used for navigation.
%cd(mainDataFolder);
for k = 3:length(D) % avoid using the first ones % start with 3
    
    cd(mainDataFolder);
    currD = D(k).name; % Get the current subdirectory name
     
      
      
      
      %fList = dir(currD); % Get the file list in the subdirectory
      cd(currD) % change the directory (then cd('..') to get back)
      worksp=[cd '\workspace.mat'];
      S=load(worksp);
      
      cd(codeDir);
      currD
      [ sparseDMap,fullDMap ] = AliDenseProposed1( S.normat ,S.nneidis,S.meanvalpat);
%      [ sparseDMap,fullDMap ] = AliDenseProposed2( S.normat ,S.nneidis,S.meanvalpat);
 %     [ sparseDMap,fullDMap ] = AliDenseProposed3( S.normat ,S.OneDresult );

      
      imwrite( ind2rgb(im2uint8(normaliseMap(sparseDMap)), parula(256)),  [resultFolder currD '-sparse-imagesc.png']);
      imwrite( normaliseMap(sparseDMap), [resultFolder currD '-sparse.png']);
      
      imwrite( ind2rgb(im2uint8(normaliseMap(fullDMap)), parula(256)),  [resultFolder currD '-dense-imagesc.png']);
      imwrite( normaliseMap(fullDMap), [resultFolder currD '-dense.png']);
 
      clear S;
   
end