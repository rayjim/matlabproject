close all;
clear all;
clc;
baseFile ='featurevector_';
actionCate = char('bend','jack','jump','pjump','run','side','walk','wave1','wave2');
vectorNum = ['0-2000_'];
patchMed ='1';

addpath([cd '/Weizzman']);
trainNum=7; % 25samples in all
cateNum = 9;
sampleNum = 2;
setNum =4;
trls =[];
tr_dat=[];
ttls = [];
tt_dat=[];
for cate=1:cateNum,
  
   for sample = 1:6,
      % for setSeq = 1:setNum,
           filename=strcat('featurevector_',int2str(sample),'_',actionCate(cate,:),vectorNum,patchMed,'.txt')
           trls=[trls cate];
           x =load(filename);
           tr_dat=[tr_dat x(:,2)/256];
       end
end
for cate=1:cateNum,
  
   for sample = 7:9,
      % for setSeq = 1:setNum,
           filename=strcat('featurevector_',int2str(sample),'_',actionCate(cate,:),vectorNum,patchMed,'.txt')
           ttls=[ttls cate];
           x =load(filename);
           tt_dat=[tt_dat x(:,2)/256];
       end
   end
   
save('weiData','trls','tr_dat','ttls','tt_dat');