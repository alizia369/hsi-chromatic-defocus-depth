function SID = Spectral_Grad_Angle( X,Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% for i=1:length(X)-1
%     SGx(i)=X(i+1)-X(i);
% end    
% for i=1:length(Y)-1
%     SGy(i)=Y(i+1)-Y(i);
% end  
SGx=gradient(X);
SGy=gradient(Y);
SID=Spectral_Angle(SGx,SGy);
end

