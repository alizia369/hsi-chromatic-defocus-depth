function [ normat, bandName ] = saveCube_smallCam( filenamepath,nOfBands,dpath,imageflag,savepath )
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

if (nargin > 4)
    
    savefilename=[savepath '\' fname '.mat'];
    if(imageflag)
    imgdir=[savepath '\' fname '_hyperimages\'];
    end
elseif (nargin > 3)
    

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
ICube=imread(filenamepath);
if( nOfBands==25)%5x5 camera 25 bands
    datacube=X2CubeFor25Band(ICube);% need to be changed just rough values.
    bandName=[691.12,716.48,730.96,743.05,757.44,769.72,782.84,794.45,806.97,825.398,836.902]; %actual band names from CMV2K-SSM5x5-600_1000-5.6.11.5.xml

else         %4x4 camera 16 bands
  datacube=X2Cube(ICube);
%datacube=X2CubeFor16BandVIS(ICube);
bandName=[467.346,471.3999999999958,483.990,494.911,509.6491,520.787,534.437,548.060,571.124,582.967,595.809,606.468,619.774,628.360,638.744,642.342];
  
end    
%[datacube,bandName] = Load_Spec(filenamepath);%for big camera. Atof filter
%one

% if(~isempty(dpath)) % look at it later for small camera dark normalise
% datacube=darknormalise(datacube,dpath);
% end
original_mat = normalise(datacube, 'percent', 0.999);

mat=original_mat;
%mat= imrotate(original_mat,90);%rotated;

%[ mat ] = normalisecube( datacube );

%mat=datacube;


%num = length(bandName);
msz=size(mat);
figure,imshow(datacube(:,:,3),[]);
msz
normat=zeros(msz);

 for b = 1:msz(3)
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

