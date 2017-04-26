clear all;close all;clc;
%% 生成模型
N = 2;                %状态数目
M = 3;                %高斯混合分布数目
observeDimension = 1; %观测量维度
observeSpan = -10:0.02:10;
HMMstruct.N = N;
HMMstruct.M = M;
HMMstruct.observePDFType = 'CONTINUOUS_GAUSSIAN';
% for i=1:N
%     temp = rand(1,N);
%     HMMstruct.A(i,:) = temp/sum(temp);
% end
HMMstruct.A = [0.7 0.3;0.2 0.8];
% HMMstruct.B = GenerateBContinuous(N,M,observeDimension);
HMMstruct.B.mixtureNum = M;
HMMstruct.B.weights = [1/3 1/3 1/3;0.3 0.35 0.35];
HMMstruct.B.mu = cell(N,1);
HMMstruct.B.mu{1} = [-5;1;5.5];
HMMstruct.B.mu{2} = [-8;-2.5;3];
HMMstruct.B.sigma = cell(N,1);
HMMstruct.B.sigma{1} = zeros(1,1,M);
HMMstruct.B.sigma{1}(1,1,1) = 1.2;
HMMstruct.B.sigma{1}(1,1,2) =  1.4;
HMMstruct.B.sigma{1}(1,1,3) = 1.4;
HMMstruct.B.sigma{2} = zeros(1,1,M);
HMMstruct.B.sigma{2}(1,1,1) = 1.4;
HMMstruct.B.sigma{2}(1,1,2) = 1.4;
HMMstruct.B.sigma{2}(1,1,3) = 1.2;
HMMstruct.B.PDF = cell(N,1);
HMMstruct.B.PDF{1} = gmdistribution(HMMstruct.B.mu{1},HMMstruct.B.sigma{1},HMMstruct.B.weights(1,:));
HMMstruct.B.PDF{2} = gmdistribution(HMMstruct.B.mu{2},HMMstruct.B.sigma{2},HMMstruct.B.weights(2,:));
% temp = rand(1,N);
% HMMstruct.initialStateProbability = temp/sum(temp);
HMMstruct.initialStateProbability = [0.5 0.5];
model = HMM();
model = model.SetModel(HMMstruct);
observePDF = model.GetObservePDF(observeSpan);
%% 优化方法参数设置
optPara.maxIter = 200;
optPara.tolerance = 0.05;
model = model.SetOptPara(optPara);
%% 生成状态观测序列
observeLength = 15000;
[stateSequence,observeSequence] = model.GenerateObserveSequence(observeLength);
% load Simulate
%% 模型优化
%%模型的初始值
HMMstruct_initial.N = N;
HMMstruct_initial.M = M;
HMMstruct_initial.observePDFType = 'CONTINUOUS_GAUSSIAN';
% for i=1:N
%     temp = rand(1,N);
%     HMMstruct_initial.A(i,:) = temp/sum(temp);
% end
% HMMstruct_initial.B = GenerateBContinuous(N,M,observeDimension);
% temp = rand(1,N);
% HMMstruct_initial.initialStateProbability = temp/sum(temp);
% HMMstruct_initial = HMMstruct;
HMMstruct_initial.A = [0.4 0.6;0.3 0.77];
HMMstruct_initial.B.mixtureNum = M;
HMMstruct_initial.B.weights = [0.2 0.4 0.4;0.1 0.5 0.4];
HMMstruct_initial.B.mu = cell(N,1);
HMMstruct_initial.B.mu{1} = [-6;1.6;6];
HMMstruct_initial.B.mu{2} = [-5.5;-4;2.8];
HMMstruct_initial.B.sigma = cell(N,1);
HMMstruct_initial.B.sigma{1} = zeros(1,1,M);
HMMstruct_initial.B.sigma{1}(1,1,1) = 0.8;
HMMstruct_initial.B.sigma{1}(1,1,2) = 4;
HMMstruct_initial.B.sigma{1}(1,1,3) = 1.1;
HMMstruct_initial.B.sigma{2} = zeros(1,1,M);
HMMstruct_initial.B.sigma{2}(1,1,1) = 2.2;
HMMstruct_initial.B.sigma{2}(1,1,2) = 1.6;
HMMstruct_initial.B.sigma{2}(1,1,3) = 1.7;
HMMstruct_initial.B.PDF = cell(N,1);
HMMstruct_initial.B.PDF{1} = gmdistribution(HMMstruct_initial.B.mu{1},HMMstruct_initial.B.sigma{1},HMMstruct_initial.B.weights(1,:));
HMMstruct_initial.B.PDF{2} = gmdistribution(HMMstruct_initial.B.mu{2},HMMstruct_initial.B.sigma{2},HMMstruct_initial.B.weights(2,:));
HMMstruct_initial.initialStateProbability = [0.45 0.55];
%%优化
model = model.SetModel(HMMstruct_initial);
[model,HMMstructEstimated,residual,flag] = model.ModelOptimization(observeSequence,stateSequence);
[stateSequenceEstimate,observeSequenceEstimate] = model.GenerateObserveSequence(observeLength);
% HMMstructEstimated = model.GetModel();
observePDFestimated = model.GetObservePDF(observeSpan);
%% 比较
stateCompare = zeros(N,2);
for i=1:N
    stateCompare(i,1) = sum(stateSequence==i)/observeLength;
    stateCompare(i,2) = sum(stateSequenceEstimate==i)/observeLength;
end
stateCompare
HMMstruct.A
HMMstructEstimated.A
figure(1)
subplot(211);
plot(observeSpan,observePDF(1,:));
hold on
plot(observeSpan,observePDFestimated(1,:));
legend('True','Estimated')
title('Observe Gaussian Mixture PDF (state1)')
subplot(212);
plot(observeSpan,observePDF(2,:));
hold on
plot(observeSpan,observePDFestimated(2,:));
legend('True','Estimated')
title('Observe Gaussian Mixture PDF (state2)')
HMMstruct.initialStateProbability
HMMstructEstimated.initialStateProbability