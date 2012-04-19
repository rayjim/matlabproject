clc
clear all;
load filename;
count =0;
for ii = 1:600
    try
    video = mmreader(files{ii})
    catch
       disp('no file find');
       files(ii)
       count=count+1;
       continue;
    end
    motionfield(video);
    

end
