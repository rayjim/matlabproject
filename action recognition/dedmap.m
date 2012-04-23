
function [DH,DV] = dedmap( EH,EV,level)
Hnew = 0;Vnew =0;
si= size(EH);
nFrames = si(3);

thresholdpx=250*250*(level+0.03);

disp('generate DED map');
for ii=1:nFrames
    sumH =sum(sum(Hnew));
    sumV=sum(sum(Vnew));
    cnt =0;
    while(sum(sum(Hnew))<thresholdpx)
        cnt=cnt+1;
        try
        Hnew = EH(:,:,ii+cnt)|EH(:,:,ii);
        catch
           break;
        end
        
    end
    cnt =0;
    while(sum(sum(Vnew))<thresholdpx)
        cnt=cnt+1;
        try
        Vnew = EV(:,:,ii+cnt)|EV(:,:,ii);
        catch
           break;
        end
    end
    DH(:,:,ii)=xor(EH(:,:,ii),Hnew);
    DV(:,:,ii)=xor(EV(:,:,ii),Vnew);
   
    subplot(2,2,1), subimage(Hnew);
    subplot(2,2,2), subimage(Vnew)
    subplot(2,2,3), subimage(EH(:,:,ii));
    subplot(2,2,4), subimage(EV(:,:,ii));
    drawnow;
    disp(ii);
end

disp('finish DED map');
end

