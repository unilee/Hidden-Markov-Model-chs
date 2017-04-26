clear all;close all;clc;
%% 生成模型
N = 3;M = 5;
HMMstruct.N = N;
HMMstruct.M = M;
HMMstruct.observePDFType = 'DISCRET';
% for i=1:N
%     temp = rand(1,N);
%     HMMstruct.A(i,:) = temp/sum(temp);
% end
% for i=1:N
%     temp = rand(1,M);
%     HMMstruct.B(i,:) = temp/sum(temp);
% end
% temp = rand(1,N);
% HMMstruct.initialStateProbability = temp/sum(temp);
HMMstruct.A = [0.4 0.3 0.3;
               0.2 0.6 0.2;
               0.8 0.1 0.1];
HMMstruct.B = [0.08 0.62 0.10 0.11 0.09;
               0.63 0.05 0.10 0.09 0.13;
               0.10 0.10 0.06 0.03 0.71];
HMMstruct.initialStateProbability = [1/3 1/3 1/3];
model = HMM();
model = model.SetModel(HMMstruct);
%% 优化方法参数设置
optPara.maxIter = 2000;
optPara.tolerance = 0.20;
model = model.SetOptPara(optPara);
%% 生成状态观测序列
observeLength = 15000;
[stateSequence,observeSequence] = model.GenerateObserveSequence(observeLength);
%% 模型优化
%%模型的初始值
HMMstruct_initial.N = N;
HMMstruct_initial.M = M;
HMMstruct_initial.observePDFType = 'DISCRET';
HMMstruct_initial.A = [0.25 0.35 0.4;
                       0.25 0.5 0.25;
                       0.6 0.2 0.2];
HMMstruct_initial.B = [0.12 0.16 0.10 0.29 0.33;
                       0.35 0.08 0.19 0.28 0.10;
                       0.09 0.10 0.30 0.25 0.26];
HMMstruct_initial.initialStateProbability = [0.11 0.37 0.52];
% for i=1:N
%     temp = rand(1,N);
%     HMMstruct_initial.A(i,:) = temp/sum(temp);
% end
% for i=1:N
%     temp = rand(1,M);
%     HMMstruct_initial.B(i,:) = temp/sum(temp);
% end
% temp = rand(1,N);
% HMMstruct_initial.initialStateProbability = temp/sum(temp);
%%优化
model = model.SetModel(HMMstruct_initial);
model = model.ModelOptimization(observeSequence,stateSequence);
[stateSequenceEstimate,observeSequenceEstimate] = model.GenerateObserveSequence(observeLength);
HMMstructEstimated = model.GetModel();
%% 比较
observeCompare = zeros(M,2);
for i=1:M
    observeCompare(i,1) = sum(observeSequence==i)/observeLength;
    observeCompare(i,2) = sum(observeSequenceEstimate==i)/observeLength;
end
observeCompare
stateCompare = zeros(N,2);
for i=1:N
    stateCompare(i,1) = sum(stateSequence==i)/observeLength;
    stateCompare(i,2) = sum(stateSequenceEstimate==i)/observeLength;
end
stateCompare
HMMstruct.A
HMMstructEstimated.A
HMMstruct.B
HMMstructEstimated.B
HMMstruct.initialStateProbability
HMMstructEstimated.initialStateProbability