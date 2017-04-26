function observeSequenceProbability = GetObserveProbability(obj,stateIndex,timeIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 根据给出的状态和时间序列，得到每个隐藏状态对应各个观测值的概率 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                          input&output  对象
% state                        input         需要求的状态序号值
% timeIndex                    input         时间序号值
% observeSequenceProbability   output        每个状态对应各个观测值的概率
%% 基本参数
observeSequenceProbability = zeros(length(timeIndex),length(stateIndex));
%% 计算观测概率
if strcmp(obj.HMMstruct.observePDFType,'DISCRET')
    for i=1:length(timeIndex)
        for j=1:length(stateIndex)
            observeSequenceProbability(i,j) = obj.HMMstruct.B(stateIndex(j),obj.observeSequence(timeIndex(i)));
        end
    end
elseif strcmp(obj.HMMstruct.observePDFType,'CONTINUOUS_GAUSSIAN')
%     for i=1:length(timeIndex)
%         for j=1:length(stateIndex)
%             observeSequenceProbability(i,j) = obj.HMMstruct.B.PDF{stateIndex(j)}.pdf(obj.observeSequence(timeIndex(i)));
%         end
%     end
    for i=1:length(stateIndex)
        observeSequenceProbability(:,i) = obj.HMMstruct.B.PDF{stateIndex(i)}.pdf(obj.observeSequence(timeIndex));
    end
end