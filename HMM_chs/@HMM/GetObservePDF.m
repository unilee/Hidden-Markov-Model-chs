function observePDF = GetObservePDF(obj,observeSpan)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ��ȡÿһ��״̬��Ӧ�۲����ĸ��ʷֲ��ɻ��߸����ܶ� %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj           input&output    ����
% observeSpan   input           �۲�����ȡֵ
% observePDF    output          �۲����ĸ��ʷֲ��ɻ�����ܶ�
%% ��������
stateNum = obj.HMMstruct.N;
observePDF = zeros(stateNum,length(observeSpan));
%% �������״̬��Ӧ�۲����ĸ��ʷֲ��ɻ�����ܶ�
for i=1:stateNum
    for j=1:length(observeSpan)
        observePDF(i,j) = obj.HMMstruct.B.PDF{i}.pdf(observeSpan(j));
    end
end