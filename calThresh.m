function [threshold] = calThresh(I,param)
    %param sets the level for the image
    [w,h] = size(I);
    threshpx = w*h*param;
    [counts,bin]=imhist(I);
    sumi=0;
    index = 256;
    while(sumi<threshpx)
        sumi = sumi+counts(index);
        index= index-1;
    end
    threshold = (255-index)/256;
    

end