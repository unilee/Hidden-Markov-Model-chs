function B = GenerateBContinuous(N,M,observeDimension)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 随机生成混合分布的观测概率结构体 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N       input      stateNum
% M       input      mixtureNum
% B       output     观测概率结构体
%% 基本参数
weights = zeros(N,M);          %各状态混合分布的权重
mu = cell(N,1);                %每个状态的混合分布的均值
sigma = cell(N,1);             %每个状态的混合分布的协方差
PDF = cell(N,1);               %每个状态的混合分布的概率密度
%% 生成权重系数
for i=1:N
    weights(i,:) = rand(1,M);
    weights(i,:) = weights(i,:)./sum(weights(i,:));
end
%% 生成均值
for i=1:N
    mu{i} = -1 + 2*rand(M,observeDimension);
end
%% 生成协方差
for i=1:N
    sigma{i} = zeros(observeDimension,observeDimension,M);
    for j=1:M
        sigma{i}(:,:,j) = 1.5*rand(observeDimension,observeDimension);
    end
end
%% 生成高恒概率密度函数
for i=1:N
    PDF{i} = gmdistribution(mu{i},sigma{i},weights(i,:));
end
%% 输出
B.mixtureNum = M;
B.weights = weights;
B.mu = mu;
B.sigma = sigma;
B.PDF = PDF;