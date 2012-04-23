% Run this method to reproduce results in the paper: N. Naikal, A.Yang, 
% S.S. Sastry, "Informative Feature Selection for Object Recognition via 
% Sparse PCA", ICCV 2011.
close all;
clear all;
clc;
T = 5; % Number of trials to average run times over
dimensions = [10 50 100 150 200 250 300 350 400 450 500];
ALMTimes = zeros(length(dimensions), T);
DSPCATimes = zeros(length(dimensions), T);
ALMPrec = zeros(length(dimensions), T);
DSPCAPrec = zeros(length(dimensions), T);

for i = 1:length(dimensions)
    
    % Initialize parameters ****************
    n=dimensions(i); p = 1;               % Dimension
    ratio=1;         % "Signal to noise" ratio
    % rand('state',25);   % Fix random seed

    for j = 1:T
        % Form test matrix as: rank one sparse + noise
        testvec=rand(n,p);
        testvec = testvec - ones(n,1)*mean(testvec);
        numZero = n - floor(0.1*n);
        randInd = randperm(n); randInd1 = randInd(1:numZero); randInd2 = randInd(numZero+1:end);
        testvec(randInd1,:) = 0;
        testvec=ratio*testvec; % + rand(n,p);
        testvec = testvec/norm(testvec);
        A = testvec*testvec'/p;
        lambda = max(1e-5,min(diag(A))*0.5);%(min(diag(A)) + max(diag(A)))/2;
        
        tstartDSPCA = tic;
        [x1, DSPCAIter] = DSPCA(A, lambda);
        tstopDSPCA = toc(tstartDSPCA);
        DSPCAPrec(i,j) = norm(abs(x1) - abs(testvec));

        tstartALM = tic;
        [x, ALMIter] = SPCA_ALM(A, lambda);
        tstopALM = toc(tstartALM);
        ALMPrec(i,j) = norm(abs(x) - abs(testvec));
        
        ALMTimes(i,j) = tstopALM;
        DSPCATimes(i,j) = tstopDSPCA;
        fprintf('\n [dim,trial] = [%i, %i]: [DSPCA time, SPCA-ALM time] = [%0.4f %0.4f]\t[DSPCA Iter, SPCA-ALM Iter] = [%i, %i]',n, j, tstopDSPCA, tstopALM, DSPCAIter, ALMIter);
    end
    fprintf('\n');
end
fprintf('\n');
ALMTimes = mean(ALMTimes,2);
DSPCATimes = mean(DSPCATimes,2);
ALMPrec = mean(ALMPrec,2);
DSPCAPrec = mean(DSPCAPrec,2);

figure
hold on
plot(dimensions, DSPCATimes, '-bx', 'linewidth', 2)
plot(dimensions, ALMTimes, '-ro', 'linewidth', 2)
legend('DSPCA', 'SPCAALM');
xlabel('Dimension (n)');
ylabel('Compute time (sec)');
title('Time comparison of DSPCA and SPCAALM')

figure
hold on
plot(dimensions, DSPCAPrec, '-gx', 'linewidth', 2)
plot(dimensions, ALMPrec, '-mo', 'linewidth', 2)
legend('DSPCA', 'SPCAALM');
xlabel('Dimension (n)');
ylabel('Error');
title('Precision comparison of DSPCA and SPCAALM')