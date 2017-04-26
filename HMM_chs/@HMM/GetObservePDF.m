function observePDF = GetObservePDF(obj,observeSpan)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 获取每一个状态对应观测量的概率分布律或者概率密度 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj           input&output    对象
% observeSpan   input           观测量的取值
% observePDF    output          观测量的概率分布律活概率密度
%% 基本参数
stateNum = obj.HMMstruct.N;
observePDF = zeros(stateNum,length(observeSpan));
%% 计算各个状态对应观测量的概率分布律活概率密度
for i=1:stateNum
    for j=1:length(observeSpan)
        observePDF(i,j) = obj.HMMstruct.B.PDF{i}.pdf(observeSpan(j));
    end
end