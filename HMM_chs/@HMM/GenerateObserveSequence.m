function [stateSequence,observeSequence] = GenerateObserveSequence(obj,observeLength)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 根据已知模型生成观测序列 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj              input&output    对象
% observeLength    input           观测长度
% stateSequence    output          状态序列
% observeSequence  output          观测序列
%% 基本参数
observeSequence = zeros(observeLength,1);
stateSequence = zeros(observeLength,1);
N = obj.HMMstruct.N;
M = obj.HMMstruct.M;
A = obj.HMMstruct.A;
Adistribution = zeros(N,N);
for i=1:N
    Adistribution(:,i) = sum(A(:,1:i),2);
end
if strcmp(obj.HMMstruct.observePDFType, 'DISCRET')
    B = obj.HMMstruct.B;
    Bdistribution = zeros(N,M);
    for i=1:M
        Bdistribution(:,i) = sum(B(:,1:i),2);
    end
elseif strcmp(obj.HMMstruct.observePDFType, 'CONTINUOUS_GAUSSIAN')
    Bdistribution = obj.HMMstruct.B.PDF;
end
initialStateProbability = obj.HMMstruct.initialStateProbability;
initialStateDistribution = zeros(1,N);
for i=1:N
    initialStateDistribution(i) = sum(initialStateProbability(1:i));
end
%% 生成观测序列
if strcmp(obj.HMMstruct.observePDFType, 'DISCRET')
    %% 初始值
    randomNumber = rand;
    if randomNumber<=initialStateDistribution(1)
        state = 1;
    end
    for i=2:N
        if randomNumber>initialStateDistribution(i-1) && randomNumber<=initialStateDistribution(i)
            state = i;
            break;
        end
    end
    stateSequence(1) = state;
    randomNumber = rand;
    if randomNumber<Bdistribution(state,1)
        observance = 1;
    end
    for i=2:M
        if randomNumber>Bdistribution(state,i-1) && randomNumber<=Bdistribution(state,i)
            observance = i;
            break;
        end
    end
    observeSequence(1) = observance;
    %% 递推
    for i = 2:observeLength
        randomNumber = rand;
        if randomNumber<=Adistribution(stateSequence(i-1),1)
            state = 1;
        end
        for j=2:N
            if randomNumber>Adistribution(stateSequence(i-1),j-1) && randomNumber<=Adistribution(stateSequence(i-1),j)
                state = j;
                break;
            end
        end
        stateSequence(i) = state;
        randomNumber = rand;
        if randomNumber<Bdistribution(state,1)
            observance = 1;
        end
        for j=2:M
            if randomNumber>Bdistribution(state,j-1) && randomNumber<=Bdistribution(state,j)
                observance = j;
                break;
            end
        end
        observeSequence(i) = observance;
    end
elseif strcmp(obj.HMMstruct.observePDFType, 'CONTINUOUS_GAUSSIAN')
    %% 初始值
    randomNumber = rand;
    if randomNumber<=initialStateDistribution(1)
        state = 1;
    end
    for i=2:N
        if randomNumber>initialStateDistribution(i-1) && randomNumber<=initialStateDistribution(i)
            state = i;
            break;
        end
    end
    stateSequence(1) = state;
    observeSequence(1) = random(Bdistribution{state},1);
    %% 递推
    for i = 2:observeLength
        randomNumber = rand;
        if randomNumber<=Adistribution(stateSequence(i-1),1)
            state = 1;
        end
        for j=2:N
            if randomNumber>Adistribution(stateSequence(i-1),j-1) && randomNumber<=Adistribution(stateSequence(i-1),j)
                state = j;
                break;
            end
        end
        stateSequence(i) = state;
        observeSequence(i) = random(Bdistribution{state},1);
    end
end