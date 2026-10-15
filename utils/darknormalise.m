function [ dnorcube ] = darknormalise( datacube,dpath )
%DARKNORMALISE Summary of this function goes here
%   Detailed explanation goes here



%dpath='.\data\Depth Estimation\outdoor\normalisedata\dark1.dat';
%dpath='.\data\Depth Estimation\LabData2\hyper\darkcube.dat';

[darkcube,dbandName] = Load_Spec(dpath);


%dnorcube=datacube-darkcube;


 darkFrame=darkcube;
 slice = mean(darkFrame, 3);
 
 for mm = 1:size(darkFrame,3);
     darkFrame(:,:,mm) = slice;
 end


%darkFrame = double(darkFrame);% do not require

dnorcube = datacube - darkFrame;




end

