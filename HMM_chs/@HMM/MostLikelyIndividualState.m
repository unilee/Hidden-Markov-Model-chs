function [stateIndex,stateProbability] = MostLikelyIndividualState(obj,observeSequence,timeIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 根据已知模型和观测量，计算特定时刻下最有可能的状态 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                    input&output  对象
% observeSequence        input         观测序列
% timeIndex              input         指定的时刻序列号
% stateIndex             output        指定时刻的最有可能的状态的序号
% state                  output        最有可能状态的概率
%% 基本参数
obj.observeSequence = observeSequence;    %观测序列
% obj = obj.CalculateAlpha();               %前向递推
% obj = obj.CalculateBeta();                %后向递推
% obj = obj.CalculateGamma();               %已知模型和观测序列，各时刻下观测量对应各个状态的概率
%% 计算前后向结果
obj = obj.ForwardBackwardProcedure();
number = length(timeIndex);
stateIndex = zeros(number,1);
stateProbability = zeros(number,1);
%% 计算概率
for i=1:number
    [stateProbability(i),stateIndex(i)] = max(obj.gamma(timeIndex(i),:));
end