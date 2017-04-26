function ksai = CalculateKsai(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     �ڸ���ģ�ͺ͹۲����������     %%%
%%% ��ȡ��ʱ��t��t+1ʱ��״̬ת��ĸ��� %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj            input&output   ����
% ksai           output         ÿһʱ�̵���һʱ�̵�״̬֮���ת�����
%% ��������
A = obj.A;
N = obj.N;
alpha = obj.alpha;
beta = obj.beta;
N = obj.HMMstruct.N;
observeLength = length(obj.observeSequence);
ksai = zeros(N,N,observeLength-1);
states = 1:N;
%% ����ksai
for i=1:observeLength-1
    observeProbability = obj.GetObserveProbability(states,i+1);
    observeProbabilityMatrix = repmat(observeProbability,N,1);
    alphaMatrix = repmat(alpha(i,:).',1,N);
    betaMatrix = repmat(beta(i+1,:),N,1);
    ksaiTemp = alphaMatrix.*A.*observeProbabilityMatrix.*betaMatrix;
    ksai(:,:,i) = ksaiTemp/sum(sum(ksaiTemp));
end