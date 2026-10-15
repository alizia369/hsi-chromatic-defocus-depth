function [ normat, bandName ] = saveCube( filenamepath,dpath,imageflag,savepath )
%SAVECUBE Summary of this function goes here
%   Detailed explanation goes here

if(filenamepath(:,end)=='\')
   
        kind = strfind(filenamepath, '\');
        fname=filenamepath((kind(end-1)+1):end-5);
        opath=filenamepath(1:(kind(end-1)-1));

    else
        kind = strfind(filenamepath, '\');
        fname=filenamepath((kind(end)+1):end-4);
        opath=filenamepath(1:(kind(end)-1));
end

if (nargin > 3)
    
    savefilename=[savepath '\' fname '.mat'];
    if(imageflag)
    imgdir=[savepath '\' fname '_hyperimages\'];
    end
elseif (nargin > 2)
    

    savefilename=[opath '\' fname '.mat'];
    if(imageflag)
    imgdir=[opath '\' fname '_hyperimages\'];
    end

else
    
    
    savefilename=[opath '\' fname '.mat'];
    imageflag=false;
    
    
end

if(imageflag)
    if (exist(imgdir,'dir')==7)
        
    else
        mkdir(imgdir);
    end
end
    


%fname
%savefilename

[datacube,bandName] = Load_Spec(filenamepath);
if(~isempty(dpath))
datacube=darknormalise(datacube,dpath);
end
mat = normalise(datacube, 'percent', 0.999);

%[ mat ] = normalisecube( datacube );

%mat=datacube;


num = length(bandName);

normat=zeros(size(mat));

 for b = 1:num
    slice = mat(:,:,b);
    %slice = imadjust(slice);   
    normat(:,:,b)=slice;
   
    if(imageflag)
   wl = bandName(b);
   imgname=[fname '_'  num2str(wl) '.png'];
   imgname
    imwrite(slice,[imgdir  '\' imgname]);    
    disp(b);
   end
 end

 %%%%%%%%%%%%%%%%%%%%%%%% added later %%%%%%%%%%%%% can be removed to test
[numRows,numCols,numSpectra] = size(normat);
scfact = mean(reshape(sqrt(sum(normat.^2,3)),numRows*numCols,1));
normat = normat./scfact;


save(savefilename,'normat','bandName');

end

