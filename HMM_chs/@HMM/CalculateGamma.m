function gamma = CalculateGamma(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 在给定模型和观测序列情况下 %%%
%%%   获取t时刻状态为i的概率   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj        input&output  对象
% gamma      output        已知模型和观测序列，各时刻下观测量对应各个状态的概率
%% 基本参数
observeLength = length(obj.observeSequence);
alpha = obj.alpha;
beta = obj.beta;
N = obj.HMMstruct.N;
%% 计算gamma
gamma = zeros(observeLength,N);
for i = 1:observeLength
    gamma(i,:) = alpha(i,:).*beta(i,:)/sum(alpha(i,:).*beta(i,:));
end