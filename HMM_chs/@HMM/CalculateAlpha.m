function obj = CalculateAlpha(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 前向递推过程，计算每一次递推过程的结果 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj             input&output   对象
%% 基本参数
A = obj.HMMstruct.A;
N = obj.HMMstruct.N;
observeLength = length(obj.observeSequence);
alpha = zeros(observeLength,N);     %前向递推结果
states = 1:N;
observeProbabilityTemp = obj.GetObserveProbability(states,1);
alpha(1,:) = obj.HMMstruct.initialStateProbability.*observeProbabilityTemp;
%% 前向递推过程
for i = 2:observeLength
    observeProbabilityTemp = obj.GetObserveProbability(states,i);
    for j=1:N
        alpha(i,j) = sum(alpha(i-1,:).*A(:,j).')*observeProbabilityTemp(j);
    end
end
%% 更新alpha
obj.alpha = alpha;