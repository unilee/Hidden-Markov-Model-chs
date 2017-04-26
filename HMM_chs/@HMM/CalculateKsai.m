function ksai = CalculateKsai(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     在给定模型和观测序列情况下     %%%
%%% 获取从时刻t到t+1时，状态转变的概率 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj            input&output   对象
% ksai           output         每一时刻到下一时刻的状态之间的转变概率
%% 基本参数
A = obj.A;
N = obj.N;
alpha = obj.alpha;
beta = obj.beta;
N = obj.HMMstruct.N;
observeLength = length(obj.observeSequence);
ksai = zeros(N,N,observeLength-1);
states = 1:N;
%% 计算ksai
for i=1:observeLength-1
    observeProbability = obj.GetObserveProbability(states,i+1);
    observeProbabilityMatrix = repmat(observeProbability,N,1);
    alphaMatrix = repmat(alpha(i,:).',1,N);
    betaMatrix = repmat(beta(i+1,:),N,1);
    ksaiTemp = alphaMatrix.*A.*observeProbabilityMatrix.*betaMatrix;
    ksai(:,:,i) = ksaiTemp/sum(sum(ksaiTemp));
end