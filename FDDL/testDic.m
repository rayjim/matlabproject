close all;
clear all;
clc;

addpath([cd '/utilies']);
load(['kth']);

%%%%%%%%%%%%%%%%%%%%%%%%
%FDDL parameter
%%%%%%%%%%%%%%%%%%%%%%%%
opts.nClass        =   6;
opts.wayInit       =   'random';
opts.lambda1       =   0.005;
opts.lambda2       =   0.05;
opts.nIter         =   20;
opts.show          =   true;
[Dict,Drls,CoefM,CMlabel] = FDDL(tr_dat,trls,opts);
