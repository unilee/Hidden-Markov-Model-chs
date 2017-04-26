function beta = CalculateBeta(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ������ƹ��̣��ó�ÿһ�ε��ƹ��̵Ľ�� %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj            input&output   ����
% beta           output         ������ƽ��
%% ��������
A = obj.HMMstruct.A;
observeLength = length(obj.observeSequence);
beta = zeors(observeLength,N);
states = 1:N;
beta(observeLength,:) = 1;
%% ������ƹ���
for i = observeLength-1:-1:1
    observeProbabilityTemp = obj.GetObserveProbability(states,i+1);
    for j = 1:N
        temp = A(j,:).*observeProbabilityTemp;
        temp = temp.*beta(i+1,:);
        beta(i,j) = sum(temp);
    end
end