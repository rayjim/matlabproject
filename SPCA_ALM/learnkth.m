clc;
clear all;
close all;
matlabpool open 8;
load kthData;
actioncate = 6;
n = 2400;
trainnum = 52;
I = zeros(n,trainnum);
globalnon =[];
parfor (ii = 1:actioncate, 8);
%for ii = 1:actioncate
sprintf ('This is beginning class %d\n',ii)
I = tr_dat(:,[((ii*trainnum-trainnum+1):(trainnum*ii))]);
I = I -mean(I,2)*ones(1,trainnum);
I1 = I/norm(I);
A = I1*I1';
lambda = max(0.001, min(diag(A))*0.5);
tstartALM =tic;
[x, ALMIter]=SPCA_ALM(A,lambda);
xMat = [xMat;x];
nonidex = find(x>0.01|x<-0.01);
globalnon = union(globalnon,nonidex);
ALMTimes(ii) = tstopALM;

end
%ALMTimes = mean(ALMTimes)
save sparsekth globalnon
save original xMat
