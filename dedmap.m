
function [DH,DV] = dedmap( videos)
%MOTIONFIELD Summary of this function goes here
%   Detailed explanation goes here
level =0.3;
nFrames = videos.NumberOfFrame;
vidHeight = videos.Height;
vidWidth = videos.Width;
Hnew =0;Vnew =0;
thresholdpx = vidWidth*vidHeight*0.32;
disp('generate edge maps');
for ii=1:nFrames
    cnt=ii;
I = videos.read(ii);

I1 = imresize(I(:,:,1),[256 256]);


I = imfilter(I1,fspecial('gaussian',[10,10]));

 




[EH(:,:,ii),EV(:,:,ii)] = edgemap(I,level);
subplot(1,3,1), subimage(I1);
subplot(1,3,2), subimage(EH(:,:,ii));
subplot(1,3,3), subimage(EV(:,:,ii))

drawnow;

end
disp('finish edge maps');
disp('generate DED map');
for ii=1:nFrames
    cnt =0;
    while(sum(sum(Hnew <thresholdpx)))
        cnt=cnt+1;
        try
        Hnew = EH(:,:,ii+cnt)|EH(:,:,ii);
        catch
            break;
        end
    end
    cnt =0;
    while(sum(sum(Vnew < thresholdpx)))
        cnt=cnt+1;
        try
        Vnew = EV(:,:,ii+cnt)|EV(:,:,ii);
        catch
            break;
        end
    end
    DH(:,:,ii)=xor(EH(:,:,ii),Hnew);
    DV(:,:,ii)=xor(EV(:,:,ii),Vnew);
    figure;
    subplot(1,2,1), subimage(DH(:,:,ii));
subplot(1,2,2), subimage(DV(:,:,ii))
end

disp('finish DED map');
end

