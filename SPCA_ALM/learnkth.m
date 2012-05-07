clc;
clear all;
close all;
matlabpool open 8;
load kthData;
actioncate = 6;
n = 2400;
I = zeros(n,6);
globalnon =[];
parfor (ii = 1:actioncate, 8);
sprintf ('This is beginning class %d\n',ii)
I = tr_dat(:,[((ii*6-5):(6*ii))]);
I = I -mean(I,2)*ones(1,6);
I1 = I/norm(I);
A = I1*I1';
lambda = max(0.002, min(diag(A))*0.5);
tstartALM =tic;
[x, ALMIter]=SPCA_ALM(A,lambda);
nonidex = find(x>0.1);
globalnon = union(globalnon,nonidex);
tstopALM = toc(tstartALM)
sprintf ('This is over class %d\n',ii);
end
save('sparsedickth','globalnon');
