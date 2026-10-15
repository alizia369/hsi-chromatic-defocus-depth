function SID=Spectral_Information(X,Y)
pX=X./sum(X);
pY=Y./sum(Y);
smX=sum(pX.*log(pX./pY));
smY=sum(pY.*log(pY./pX));

SID=smX+smY;
% SID=1/(SID+eps);
end