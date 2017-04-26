function Bupdated = UpdateBContinuous(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% baum-welch算法更新连续观测的混合高斯分布 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj          input&output    对象
% Bupdated     output          高斯混合分布结构体,更新后
%% 基本参数
observeLength = length(obj.observeSequence);                %观测序列长度
stateNum = size(obj.HMMstruct.B.mu,1);                      %状态个数
gaussianDimension = size(obj.observeSequence,2);            %每个高斯分布的维度，即
mixtureNum = obj.HMMstruct.B.mixtureNum;                    %混合分布的个数
weights = zeros(stateNum,mixtureNum);                       %权重
mu = cell(stateNum,1);                                      %每个状态的混合分布的均值
sigma = cell(stateNum,1);                                   %每个状态的混合分布的协方差
PDF = cell(stateNum,1);                                     %每个状态的混合分布的概率密度
gammaSaparate = zeros(stateNum,mixtureNum,observeLength);
%% 计算gammaSaparate
for i=1:observeLength
    %获取每一时刻不同状态对应不同高斯分布部分的概率密度值
    temp = zeros(stateNum,mixtureNum);
    for j=1:stateNum
        for k=1:mixtureNum
            temp(j,k) = mvnpdf(obj.observeSequence(i,:),obj.HMMstruct.B.mu{j}(k,:),obj.HMMstruct.B.sigma{j}(:,:,k));
        end
    end
    %当前时刻的gammaSaparate
    gammaSaparate(:,:,i) = repmat(obj.gamma(i,:).'/sum(obj.gamma(i,:)),1,mixtureNum);
    temp = obj.HMMstruct.B.weights.*temp;
    temp = temp./repmat(sum(temp,2),1,mixtureNum);
    gammaSaparate(:,:,i) = gammaSaparate(:,:,i).*temp;
end
%% 更新
for i=1:stateNum
    mu{i} = zeros(mixtureNum,gaussianDimension);
    sigma{i} = zeros(gaussianDimension,gaussianDimension,mixtureNum);
    for j=1:mixtureNum
        %权重
        weights(i,j) = sum(gammaSaparate(i,j,:))/sum(sum(gammaSaparate(i,:,:)));
        %均值
        temp = repmat(reshape(gammaSaparate(i,j,:),observeLength,1),1,gaussianDimension);
        mu{i}(j,:) = sum(temp.*obj.observeSequence,1)/sum(gammaSaparate(i,j,:));
        %协方差
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