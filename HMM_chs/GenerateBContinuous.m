function B = GenerateBContinuous(N,M,observeDimension)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ������ɻ�Ϸֲ��Ĺ۲���ʽṹ�� %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N       input      stateNum
% M       input      mixtureNum
% B       output     �۲���ʽṹ��
%% ��������
weights = zeros(N,M);          %��״̬��Ϸֲ���Ȩ��
mu = cell(N,1);                %ÿ��״̬�Ļ�Ϸֲ��ľ�ֵ
sigma = cell(N,1);             %ÿ��״̬�Ļ�Ϸֲ���Э����
PDF = cell(N,1);               %ÿ��״̬�Ļ�Ϸֲ��ĸ����ܶ�
%% ����Ȩ��ϵ��
for i=1:N
    weights(i,:) = rand(1,M);
    weights(i,:) = weights(i,:)./sum(weights(i,:));
end
%% ���ɾ�ֵ
for i=1:N
    mu{i} = -1 + 2*rand(M,observeDimension);
end
%% ����Э����
for i=1:N
    sigma{i} = zeros(observeDimension,observeDimension,M);
    for j=1:M
        sigma{i}(:,:,j) = 1.5*rand(observeDimension,observeDimension);
    end
end
%% ���ɸߺ�����ܶȺ���
for i=1:N
    PDF{i} = gmdistribution(mu{i},sigma{i},weights(i,:));
end
%% ���
B.mixtureNum = M;
B.weights = weights;
B.mu = mu;
B.sigma = sigma;
B.PDF = PDF;