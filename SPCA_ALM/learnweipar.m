clc;
clear all;
close all;
matlabpool open;
load weiData;
actioncate = 9;
n = 2000;
trainnum = 6;
I = zeros(n,trainnum);
globalnon =[];
parfor ii = 1:actioncate
sprintf ('This is beginning class %d\n',ii)
I = tr_dat(:,[((ii*trainnum-trainnum+1):(trainnum*ii))]);
I = I -mean(I,2)*ones(1,trainnum);
I1 = I/norm(I);
A = I1*I1';
lambda = max(0.002, min(diag(A))*0.5);
tstartALM =tic;
[x, ALMIter]=SPCA_ALM(A,lambda);
nonidex = find(x>0.1);
globalnon = union(globalnon,nonidex);
tstopALM = toc(tstartALM);
disp(tstopALM);
end
save('sparsedicwei','globalnon');
