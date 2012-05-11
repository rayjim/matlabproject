close all;
clear all;
clc;
baseFile ='featurevector_';
actionCate = char('jogging','running','walking','boxing','handclapping','handwaving');
vectorNum = ['_0-2400_'];
patchMed ='0';
settings = char('d1','d2','d3','d4');
addpath([cd '/kth']);
trainNum=13; % 25samples in all
cateNum = 6;
sampleNum = 13;
setNum =4;
trls =[];
tr_dat=[];
ttls = [];
tt_dat=[];
for cate=1:6,
  
   for sample = 1:sampleNum,
       for setSeq = 1:setNum,
           filename=strcat('featurevector_',int2str(sample),'_',actionCate(cate,:),'_d',int2str(setSeq),vectorNum,patchMed,'.txt')
           trls=[trls cate];
           x =load(filename);
           tr_dat=[tr_dat x(:,2)];
       end
   end
end
for cate=1:cateNum,
  
   for sample = 14:25,
       for setSeq = 1:setNum,
           filename=strcat('featurevector_',int2str(sample),'_',actionCate(cate,:),'_d',int2str(setSeq),vectorNum,patchMed,'.txt')
           ttls=[ttls cate];
           x =load(filename);
           tt_dat=[tt_dat x(:,2)];
       end
   end
end
save('kthData','trls','tr_dat','ttls','tt_dat');