function [ newres ] = SDisUnderCurve( patches,bandName,normat )
%SDISUNDERCURVE Summary of this function goes here
%   Detailed explanation goes here
totalp=max(patches(:));
bnames=bandName;
csz=size(normat);
%res=patches;

varresult=zeros(csz(1),csz(2));

for i=1:totalp
   
    pind=find(patches==i); 
     
    
   %spdata=normat(pind,:);
   
   variance=zeros(size(bnames));
   
   for j=1:csz(3)
    
        slc=normat(:,:,j);   
        pat=slc(pind);
        variance(j)=var(pat(:));
        
   end

    minvar=min(variance(:));
    maxvar=max(variance(:));
    norvariance=(variance-minvar)./(maxvar-minvar);

    [mval,mind]=max(norvariance);
    diffvals=zeros(5,1);
    if(mind-1>=1 && mind+1<=numel(norvariance))
        diffvals(1)=abs(norvariance(mind-1)-norvariance(mind+1));
    end
    if(mind-2>=1 && mind+2<=numel(norvariance))
        diffvals(2)=abs(norvariance(mind-2)-norvariance(mind+2));
    end
    if(mind-3>=1 && mind+3<=numel(norvariance))
        diffvals(3)=abs(norvariance(mind-3)-norvariance(mind+3));
    end
    if(mind-4>=1 && mind+4<=numel(norvariance))
    
        diffvals(4)=abs(norvariance(mind-4)-norvariance(mind+4));
    end
    if(mind-5>=1 && mind+5<=numel(norvariance))
        diffvals(5)=abs(norvariance(mind-5)-norvariance(mind+5));
    end
     nonzerovals=diffvals(diffvals>0);
     if(isempty(nonzerovals))
     nonzerovals=0;
    % else
    %     nonzerovals=nonzerovals./length(nonzerovals);
     end
     squarenz=nonzerovals.^2;
    %varresult(pind)=(sum(nonzerovals(:)))./length(nonzerovals) ;
    varresult(pind)=(sqrt(sum(squarenz(:))))./length(nonzerovals) ;
    i
end

%figure,imagesc(varresult);
%figure,imagesc(varresult*-1);

resm=max(varresult(:))+0.1;
varresult2=varresult;
varresult2(find(varresult==0))=resm;
newres=abs(varresult2-resm);
%figure,imagesc(newres);

end

