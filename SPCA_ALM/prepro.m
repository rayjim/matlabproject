function [ outputmatrix ] = prepro( I,trainnum )
%For the preprocessing of the input matrix
%   In order for the SVD, preprocessing of inputmatrix
I = I -mean(I,2)*ones(1,trainnum);
normmatrix =zeros(size(I,1),1);

for ii=1:size(I,1)
   q = norm(I(ii,:));
   if(q~=0)
   normmatrix(ii) = q; 
   else
       normmatrix(ii) = inf;
   end
end
outputmatrix = I./(normmatrix*ones(1,trainnum));



end

