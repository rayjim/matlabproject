function [EH,EV] = binaryimg(I,level)
soberfilter = fspecial('sobel');
H = imfilter(I,soberfilter);
V = imfilter(I,soberfilter');
levelh = graythresh(H);
levelv = graythresh(V);
EH = ~im2bw(I,levelh);
EV = ~im2bw(I,levelv);
%levelh = calThresh(H,param);
%levelv = calThresh(V,param);
%H = im2bw(H,levelh);
%V = im2bw(V,levelv);


end