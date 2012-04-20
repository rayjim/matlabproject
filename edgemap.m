function [H,V] = edgemap(I,param)
soberfilter = fspecial('sobel');
H = imfilter(I,soberfilter);
V = imfilter(I,soberfilter');
levelh = calThresh(H,param);
levelv = calThresh(V,param);
H = im2bw(H,levelh);
V = im2bw(V,levelv);


end

