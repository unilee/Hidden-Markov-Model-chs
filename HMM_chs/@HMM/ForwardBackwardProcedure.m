function obj = ForwardBackwardProcedure(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%      前向后向过程       %%%%
%%% 计算Baum-Welch算法的γ和ξ%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj           input&output    对象
% gamma         output          已知模型和观测序列，各时刻下观测量对应各个状态的概率
% ksai          output          每一时刻到下一时刻的状态之间的转变概率
%% 基本参数
N = obj.HMMstruct.N;
initialStateProbability = obj.HMMstruct.initialStateProbability;
observeLength = length(obj.observeSequence);
forwardResult = zeros(observeLength,N);
backwardResult = zeros(observeLength,N);
states = 1:N;
%% 前向
observeProbability = obj.GetObserveProbability(states,1);
forwardResult(1,:) = observeProbability.*initialStateProbability./sum(observeProbability.*initialStateProbability);
for i = 2:observeLength
    forwardNextState = forwardResult(i-1,:)*obj.HMMstruct.A;
    observeProbability = obj.GetObserveProbability(states,i);
    forwardResult(i,:) = observeProbability.*forwardNextState/sum(observeProbability.*forwardNextState);
end
%% 后向及ξ
backwardResult(observeLength,:) = forwardResult(observeLength,:);
obj.ksai = zeros(N,N,observeLength-1);
for i = observeLength-1:-1:1
    forwardResultMatrix = repmat(forwardResult(i,:).',1,N);
    backwardResultMatrix = repmat(backwardResult(i+1,:),N,1);
    forwardNextState = forwardResult(i,:)*obj.HMMstruct.A;
    forwardNextStateMatrix = repmat(forwardNextState,N,1);
    obj.ksai(:,:,i) = forwardResultMatrix.*obj.HMMstruct.A.*backwardResultMatrix./forwardNextStateMatrix;
    backwardResult(i,:) = sum(obj.ksai(:,:,i),2).';
end
%% γ
obj.gamma = backwardResult;