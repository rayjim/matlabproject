function [H,V] = edgemap(I,level)
soberfilter = fspecial('sobel');
H = imfilter(I(:,:,1),soberfilter);
V = imfilter(I(:,:,1),soberfilter');
H = im2bw(H,level);
V = im2bw(V,level);


end

