
function [ H,V ] = motionfield( videos)
%MOTIONFIELD Summary of this function goes here
%   Detailed explanation goes here
level =0.3;

nFrames = videos.NumberOfFrame;
vidHeight = videos.Height;
vidWidth = videos.Width;
Hnew =0;Vnew =0;
thresholdpx = vidWidth*vidHeight*0.33;
disp('generate edge maps');
for ii=1:nFrames
    cnt=ii;
I = videos.read(ii);
[EH(:,:,ii),EV(:,:,ii)] = edgemap(I,level);
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

end
disp('finish DED map');
end

