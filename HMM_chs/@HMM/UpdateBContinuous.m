function Bupdated = UpdateBContinuous(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% baum-welch�㷨���������۲�Ļ�ϸ�˹�ֲ� %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj          input&output    ����
% Bupdated     output          ��˹��Ϸֲ��ṹ��,���º�
%% ��������
observeLength = length(obj.observeSequence);                %�۲����г���
stateNum = size(obj.HMMstruct.B.mu,1);                      %״̬����
gaussianDimension = size(obj.observeSequence,2);            %ÿ����˹�ֲ���ά�ȣ���
mixtureNum = obj.HMMstruct.B.mixtureNum;                    %��Ϸֲ��ĸ���
weights = zeros(stateNum,mixtureNum);                       %Ȩ��
mu = cell(stateNum,1);                                      %ÿ��״̬�Ļ�Ϸֲ��ľ�ֵ
sigma = cell(stateNum,1);                                   %ÿ��״̬�Ļ�Ϸֲ���Э����
PDF = cell(stateNum,1);                                     %ÿ��״̬�Ļ�Ϸֲ��ĸ����ܶ�
gammaSaparate = zeros(stateNum,mixtureNum,observeLength);
%% ����gammaSaparate
for i=1:observeLength
    %��ȡÿһʱ�̲�ͬ״̬��Ӧ��ͬ��˹�ֲ����ֵĸ����ܶ�ֵ
    temp = zeros(stateNum,mixtureNum);
    for j=1:stateNum
        for k=1:mixtureNum
            temp(j,k) = mvnpdf(obj.observeSequence(i,:),obj.HMMstruct.B.mu{j}(k,:),obj.HMMstruct.B.sigma{j}(:,:,k));
        end
    end
    %��ǰʱ�̵�gammaSaparate
    gammaSaparate(:,:,i) = repmat(obj.gamma(i,:).'/sum(obj.gamma(i,:)),1,mixtureNum);
    temp = obj.HMMstruct.B.weights.*temp;
    temp = temp./repmat(sum(temp,2),1,mixtureNum);
    gammaSaparate(:,:,i) = gammaSaparate(:,:,i).*temp;
end
%% ����
for i=1:stateNum
    mu{i} = zeros(mixtureNum,gaussianDimension);
    sigma{i} = zeros(gaussianDimension,gaussianDimension,mixtureNum);
    for j=1:mixtureNum
        %Ȩ��
        weights(i,j) = sum(gammaSaparate(i,j,:))/sum(sum(gammaSaparate(i,:,:)));
        %��ֵ
        temp = repmat(reshape(gammaSaparate(i,j,:),observeLength,1),1,gaussianDimension);
        mu{i}(j,:) = sum(temp.*obj.observeSequence,1)/sum(gammaSaparate(i,j,:));
        %Э����
        for t=1:observeLength
            sigma{i}(:,:,j) = sigma{i}(:,:,j) + gammaSaparate(i,j,t).*(obj.observeSequence(t,:)-mu{i}(j,:)).'*(obj.observeSequence(t,:)-mu{i}(j,:));
        end
        sigma{i}(:,:,j) = sigma{i}(:,:,j)/sum(gammaSaparate(i,j,:));
    end
end
for i=1:stateNum
    PDF{i} = gmdistribution(mu{i},sigma{i},weights(i,:));
end
Bupdated.mixtureNum = mixtureNum;
Bupdated.weights = weights;
Bupdated.mu = mu;
Bupdated.sigma = sigma;
Bupdated.PDF = PDF;