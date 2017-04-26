function observeSequenceProbability = GetObserveProbability(obj,stateIndex,timeIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ���ݸ�����״̬��ʱ�����У��õ�ÿ������״̬��Ӧ�����۲�ֵ�ĸ��� %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                          input&output  ����
% state                        input         ��Ҫ���״̬���ֵ
% timeIndex                    input         ʱ�����ֵ
% observeSequenceProbability   output        ÿ��״̬��Ӧ�����۲�ֵ�ĸ���
%% ��������
observeSequenceProbability = zeros(length(timeIndex),length(stateIndex));
%% ����۲����
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