function [EH,EV] = edgemap(videos,level)                                                                                                                  
%   Detailed explanation goes here
disp('generate edge maps');
nFrames = videos.NumberOfFrames;
for ii=1:nFrames
I = videos.read(ii);
I1 = imresize(I(:,:,1),[256 256]);
I = imfilter(I1,fspecial('gaussian',[10,10]));
[EH(:,:,ii),EV(:,:,ii)] = binaryimg(I,level);
subplot(1,3,1), subimage(I1);
subplot(1,3,2), subimage(EH(:,:,ii));
subplot(1,3,3), subimage(EV(:,:,ii))
drawnow;
end

disp('finish edge maps');
end
              

