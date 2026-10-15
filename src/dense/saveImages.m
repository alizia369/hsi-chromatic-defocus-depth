      resultFolder= '.\resultsProposed3\';
      endout=regexp(resultfolder,filesep,'split');
      currD=endout{end-1};

      imwrite( ind2rgb(im2uint8(normaliseMap(sparseDMap)), parula(256)),  [resultFolder currD '-sparse-imagesc.png']);
      imwrite( normaliseMap(sparseDMap), [resultFolder currD '-sparse.png']);
      
      imwrite( ind2rgb(im2uint8(normaliseMap(fullDMap)), parula(256)),  [resultFolder currD '-dense-imagesc.png']);
      imwrite( normaliseMap(fullDMap), [resultFolder currD '-dense.png']);