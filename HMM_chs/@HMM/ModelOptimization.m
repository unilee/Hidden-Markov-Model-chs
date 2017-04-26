function [obj,HMMstruct,residual,flag] = ModelOptimization(obj,observeSequence,stateSequence)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ������֪�۲����Ż�HMMģ�� %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                  input&output     ����
% observeSequence      input            �۲�����
% stateSequence        input            ״̬����
% HMMstructEstimated   output           ���Ƶ�HMMģ��
% residual             output           ״̬���ƴ�����
% flag                 output           ��־λ��0:���������ﵽ����,1:������С��ָ��ֵ
%% ��������
obj.observeSequence = observeSequence;
observeLength = length(obj.observeSequence);
N = obj.HMMstruct.N;
M = obj.HMMstruct.M;
%% ѭ���Ż�ģ�ͣ�Baum-Welch�㷨
tolerance = obj.optPara.tolerance;
criteriaValue = inf;
correctRatioPrevious = 0;
count = 0;
while correctRatioPrevious <= (1-tolerance)
    tic
    %% ������Ҫʹ�õ�alpha��beta��gamma��ksai��
%     obj = obj.CalculateAlpha();
%     obj = obj.CalculateBeta();
%     obj = obj.CalculateGamma();
%     obj = obj.CalculateKsai();
    obj = obj.ForwardBackwardProcedure();
    %% ����ģ�͵ĸ���ֵ
    initialStateProbability = zeros(1,N);
    A = zeros(N,N);
    B = zeros(N,M);
    for i=1:N
        %% ��ʼ״̬�ֲ�
        initialStateProbability(i) = obj.gamma(1,i);
        %% ״̬ת�ƾ���
        for j=1:N
            A(i,j) = sum(obj.ksai(i,j,:))/sum(obj.gamma(1:observeLength-1,i));
        end
        %% �۲���ʾ���
        if strcmp(obj.HMMstruct.observePDFType,'DISCRET')
            for j=1:M
                B(i,j) = sum(obj.gamma(observeSequence==j,i))/sum(obj.gamma(:,i));
            end
        elseif strcmp(obj.HMMstruct.observePDFType,'CONTINUOUS_GAUSSIAN')
            B = obj.UpdateBContinuous();
        end
    end
    %% ����ģ�����ε����ı仯
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
    %% ģ�͸���
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
%% �Ż����
HMMstruct = obj.HMMstruct;
if count>obj.optPara.maxIter
    flag = 0;
end
residual = correctRatioPrevious;
