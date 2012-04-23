clear all;
clc;
action ={'jogging','boxing','handclapping','running','walking','handwaving'};
action = reshape(repmat(action,25*4,1),600,1)
con = {'d1','d2','d3','d4'}';
dirName ={'../videos/'};
peopleCtr =[1:25]';
files =strcat(dirName,action,'/person',repmat(num2str(peopleCtr,'%02d'),4*6,1),'_',action,'_',repmat(con,25*6,1),'_uncomp.avi')
save filename files