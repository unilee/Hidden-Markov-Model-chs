function gamma = CalculateGamma(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% �ڸ���ģ�ͺ͹۲���������� %%%
%%%   ��ȡtʱ��״̬Ϊi�ĸ���   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj        input&output  ����
% gamma      output        ��֪ģ�ͺ͹۲����У���ʱ���¹۲�����Ӧ����״̬�ĸ���
%% ��������
observeLength = length(obj.observeSequence);
alpha = obj.alpha;
beta = obj.beta;
N = obj.HMMstruct.N;
%% ����gamma
gamma = zeros(observeLength,N);
for i = 1:observeLength
    gamma(i,:) = alpha(i,:).*beta(i,:)/sum(alpha(i,:).*beta(i,:));
end