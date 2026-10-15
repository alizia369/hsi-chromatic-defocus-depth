function [ EigVal, EigVec] = HSI2Eigen( datacube )
%HSI2EIGEN Summary of this function goes here
%   Detailed explanation goes here
[h,w,n] = size(datacube);
    d = h*w;
    % vectorize images
    x = reshape(datacube,[d n]);    
    %subtract mean
     x=bsxfun(@minus, x, mean(x,2));
     x=double(x);
    % calculate covariance
    s = x'*x;
    % obtain eigenvalue & eigenvector of size n*n n is number of bands
    [V,D] = eig(s);          
    % if corresponding eigenvalue is greater than 1, then the eigenvector will be chosen for creating eigenface
%     Vlarg = [];
%     idx=[];
%     for i = 1 : size(V,2) 
%         if( D(i,i) > 1 )
%             Vlarg = [Vlarg V(:,i)];
%             idx=[idx i]
%         end
%     end
    Vlarg = x*V;
    
   % eigenvalues 
    eigval = diag(D);
    [~,xci]=sort(eigval,'descend');% largest eigenval
    %figure
     %colormap gray
     EigVal= zeros([n 1]);
     EigVec= zeros([h w n]);
     
    for i = 1:size(Vlarg,2) 
       % subplot(5,8,i)
        %EigVal(i,1)=eigval(xci(i),1);
        EigVal(i)=eigval(xci(i),1);
        EigVec(:,:,i)=normaliseMap(reshape(Vlarg(:,xci(i)),[h w])); % added normalization
       %imagesc(EigVec(:,:,i));
    end

    
    
    
end

