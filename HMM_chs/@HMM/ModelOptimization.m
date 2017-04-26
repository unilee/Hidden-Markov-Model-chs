function [obj,HMMstruct,residual,flag] = ModelOptimization(obj,observeSequence,stateSequence)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 根据已知观测量优化HMM模型 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                  input&output     对象
% observeSequence      input            观测序列
% stateSequence        input            状态序列
% HMMstructEstimated   output           估计的HMM模型
% residual             output           状态估计错误率
% flag                 output           标志位，0:迭代次数达到上限,1:错误率小于指定值
%% 基本参数
obj.observeSequence = observeSequence;
observeLength = length(obj.observeSequence);
N = obj.HMMstruct.N;
M = obj.HMMstruct.M;
%% 循环优化模型，Baum-Welch算法
tolerance = obj.optPara.tolerance;
criteriaValue = inf;
correctRatioPrevious = 0;
count = 0;
while correctRatioPrevious <= (1-tolerance)
    tic
    %% 计算需要使用的alpha，beta，gamma，ksai等
%     obj = obj.CalculateAlpha();
%     obj = obj.CalculateBeta();
%     obj = obj.CalculateGamma();
%     obj = obj.CalculateKsai();
    obj = obj.ForwardBackwardProcedure();
    %% 计算模型的更新值
    initialStateProbability = zeros(1,N);
    A = zeros(N,N);
    B = zeros(N,M);
    for i=1:N
        %% 初始状态分布
        initialStateProbability(i) = obj.gamma(1,i);
        %% 状态转移矩阵
        for j=1:N
            A(i,j) = sum(obj.ksai(i,j,:))/sum(obj.gamma(1:observeLength-1,i));
        end
        %% 观测概率矩阵
        if strcmp(obj.HMMstruct.observePDFType,'DISCRET')
            for j=1:M
                B(i,j) = sum(obj.gamma(observeSequence==j,i))/sum(obj.gamma(:,i));
            end
        elseif strcmp(obj.HMMstruct.observePDFType,'CONTINUOUS_GAUSSIAN')
            B = obj.UpdateBContinuous();
        end
    end
    %% 计算模型两次迭代的变化
%     initialStateProbabilityError = max(abs((initialStateProbability - obj.HMMstruct.initialStateProbability)./obj.HMMstruct.initialStateProbability));
%     Aerror = max(max(abs((A - obj.HMMstruct.A)./obj.HMMstruct.A)));
%     Berror = max(max(abs((B - obj.HMMstruct.B)./obj.HMMstruct.B)));
%     toc
%     criteriaValue = max([initialStateProbabilityError Aerror Berror])
    bestBackwardStateCurrent = zeros(observeLength,1);
    for i=1:observeLength
        [~,bestBackwardStateCurrent(i)] = max(obj.gamma(i,:));
    end
    correctRatio = sum(bestBackwardStateCurrent==stateSequence)/observeLength;
    criteriaValue = abs(correctRatio-correctRatioPrevious)/correctRatioPrevious;
    correctRatioPrevious = correctRatio
    %% 模型更新
    obj.HMMstruct.initialStateProbability = initialStateProbability;
    obj.HMMstruct.A = A;
    obj.HMMstruct.B = B;
    if mod(count,50)==0
        initialStateProbability
        A
        B
    end
    count = count + 1;
    if count>obj.optPara.maxIter
        break;
    end
end
%% 优化结果
HMMstruct = obj.HMMstruct;
if count>obj.optPara.maxIter
    flag = 0;
end
residual = correctRatioPrevious;
