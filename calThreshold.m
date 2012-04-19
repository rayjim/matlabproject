function [ output] = calThreshold( img,size )
    [counts, bin]=imhist(img);
    sum =0;
    for ii = 1:length(bin)
        if(sum>=size)
            break;
        end
        sum=counts(ii)+sum;
        
    end
   output=bin(ii);
end