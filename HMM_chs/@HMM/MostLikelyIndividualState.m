function [stateIndex,stateProbability] = MostLikelyIndividualState(obj,observeSequence,timeIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ������֪ģ�ͺ͹۲����������ض�ʱ�������п��ܵ�״̬ %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                    input&output  ����
% observeSequence        input         �۲�����
% timeIndex              input         ָ����ʱ�����к�
% stateIndex             output        ָ��ʱ�̵����п��ܵ�״̬�����
% state                  output        ���п���״̬�ĸ���
%% ��������
obj.observeSequence = observeSequence;    %�۲�����
% obj = obj.CalculateAlpha();               %ǰ�����
% obj = obj.CalculateBeta();                %�������
% obj = obj.CalculateGamma();               %��֪ģ�ͺ͹۲����У���ʱ���¹۲�����Ӧ����״̬�ĸ���
%% ����ǰ������
obj = obj.ForwardBackwardProcedure();
number = length(timeIndex);
stateIndex = zeros(number,1);
stateProbability = zeros(number,1);
%% �������
for i=1:number
    [stateProbability(i),stateIndex(i)] = max(obj.gamma(timeIndex(i),:));
end