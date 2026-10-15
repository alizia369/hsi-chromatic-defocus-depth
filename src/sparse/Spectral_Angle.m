function SA  = Spectral_Angle(X,Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Spectral gradient angle is invariant to illumination  

%simple implementation

z=norm(X)*norm(Y);
w=sum(X.*Y);
SA=acos(w/z);


%%%%detailsed implementation

% HYPERSAM Computes the spectral angle error (in radians) between two
% vectors, or between a vector and every column or row of a matrix
%
% Usage
%   [errRadians] = hyperSam(a, b)
%   [errRadians] = hyperSam(A, b)
%   [errRadians] = hyperSam(a, B)
% Inputs
%   a - vector, (px1)
%   b - vector, (px1)
%   A - matrix, (pxN)
%   B - matrix, (pxN)
% Outputs
%   errRadians - angle between vectors a and b in radians, (1xN)

% Check dimensions
% if ~any(size(X)==size(Y)),
%     error('Incorrect dimensions provided.');
% elseif ~any([isvector(X),isvector(Y)]),
%     error('Incorrect inputs. At least one input must be a vector.');
% end
% 
% % Turn row vectors to column vectors if necessary
% if isrow(X), X=X'; end
% if isrow(Y), Y=Y'; end
% 
% % Get dimensions
% p1 = size(X,1);
% p2 = size(Y,1);
% 
% % Transpose matrix if necessary
% if ~isvector(X) % X is a matrix, Y is a vector
%     if p1~=p2, X=X'; end
%     SA = getSam(X,Y);
%     return
%     
% elseif ~isvector(Y) % Y is a matrix, a is a vector
%     if p2~=p1, Y=Y'; end
%     SA = getSam(Y,X);
%     return
%     
% elseif all([isvector(X),isvector(Y)]) % X and Y are both vectors
%     SA = getSam(X,Y);
%     return
%     
% else
%     error('Unknown error. See help hyperSam.')
% end





end

% function errRadians = getSam(a, b)
% % GETSAM computes the spectral angle error between the vector b and
% % every column of matrix a (or just the first column, if a is a vector)
% 
% [~,N] = size(a);
% errRadians = zeros(1,N);
% 
% for k=1:N
%     tmp = a(:,k);
%     errRadians(k) = acos(dot(tmp, b)/ (norm(b) * norm(tmp)));
% end
% 
% end
