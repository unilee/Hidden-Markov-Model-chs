function obj = CalculateAlpha(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ǰ����ƹ��̣�����ÿһ�ε��ƹ��̵Ľ�� %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj             input&output   ����
%% ��������
A = obj.HMMstruct.A;
N = obj.HMMstruct.N;
observeLength = length(obj.observeSequence);
alpha = zeros(observeLength,N);     %ǰ����ƽ��
states = 1:N;
observeProbabilityTemp = obj.GetObserveProbability(states,1);
alpha(1,:) = obj.HMMstruct.initialStateProbability.*observeProbabilityTemp;
%% ǰ����ƹ���
for i = 2:observeLength
    observeProbabilityTemp = obj.GetObserveProbability(states,i);
    for j=1:N
        alpha(i,j) = sum(alpha(i-1,:).*A(:,j).')*observeProbabilityTemp(j);
    end
end
%% ����alpha
obj.alpha = alpha;