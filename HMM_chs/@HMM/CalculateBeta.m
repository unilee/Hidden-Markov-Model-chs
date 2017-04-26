function beta = CalculateBeta(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 后向递推过程，得出每一次递推过程的结果 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj            input&output   对象
% beta           output         后向递推结果
%% 基本参数
A = obj.HMMstruct.A;
observeLength = length(obj.observeSequence);
beta = zeors(observeLength,N);
states = 1:N;
beta(observeLength,:) = 1;
%% 后向递推过程
for i = observeLength-1:-1:1
    observeProbabilityTemp = obj.GetObserveProbability(states,i+1);
    for j = 1:N
        temp = A(j,:).*observeProbabilityTemp;
        temp = temp.*beta(i+1,:);
        beta(i,j) = sum(temp);
    end
end