function obj = ForwardBackwardProcedure(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%      ǰ��������       %%%%
%%% ����Baum-Welch�㷨�Ħúͦ�%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj           input&output    ����
% gamma         output          ��֪ģ�ͺ͹۲����У���ʱ���¹۲�����Ӧ����״̬�ĸ���
% ksai          output          ÿһʱ�̵���һʱ�̵�״̬֮���ת�����
%% ��������
N = obj.HMMstruct.N;
initialStateProbability = obj.HMMstruct.initialStateProbability;
observeLength = length(obj.observeSequence);
forwardResult = zeros(observeLength,N);
backwardResult = zeros(observeLength,N);
states = 1:N;
%% ǰ��
observeProbability = obj.GetObserveProbability(states,1);
forwardResult(1,:) = observeProbability.*initialStateProbability./sum(observeProbability.*initialStateProbability);
for i = 2:observeLength
    forwardNextState = forwardResult(i-1,:)*obj.HMMstruct.A;
    observeProbability = obj.GetObserveProbability(states,i);
    forwardResult(i,:) = observeProbability.*forwardNextState/sum(observeProbability.*forwardNextState);
end
%% ���򼰦�
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
%% ��
obj.gamma = backwardResult;