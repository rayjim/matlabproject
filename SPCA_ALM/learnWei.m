clc;
clear all;
close all;
load weiData;
actioncate = 9;
n = 2000;
I = zeros(n,6);
globalnon =[];
trainnum = 6;
I = zeros(n,trainnum);

for ii = 1:actioncate
sprintf ('This is beginning class %d\n',ii)
I = tr_dat(:,[((ii*trainnum-trainnum+1):(trainnum*ii))]);
I1 = prepro(I,trainnum);
A = I1*I1';
lambda = max(1e-5, (min(diag(A)) + max(diag(A)))/2);
tstartALM =tic;
[x, ALMIter]=SPCA_ALM(A,lambda);
nonidex = find(x>0.01);
globalnon = union(globalnon,nonidex);
ALMTimes(ii) = tstopALM;
sprintf ('This is over class %d\n',ii)
end
ALMTimes = mean(ALMTimes);
save('ssparsedic','globalnon');