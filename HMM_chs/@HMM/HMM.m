classdef HMM
    %% 公有成员变量
    properties
        
    end
    %% 私有成员变量
    properties (Access = 'private')
        HMMstruct;         %HMM模型结构体
        optPara;
        observeSequence;   %观测序列
        alpha;
        beta;
        gamma;
        ksai;
        observeSequenceProbability;
    end
    %% 构造函数
    methods
        function obj = HMM()
            obj.HMMstruct = struct('N',0,'M',0,'A',0,'B',0,'initialStateProbability',0,'observePDFType',0);
            obj.optPara = struct('maxIter',1000,'tolerance',1e-3);
            obj.observeSequence = [];
            obj.alpha = [];
            obj.beta = [];
            obj.gamma = [];
            obj.ksai = [];
            obj.observeSequenceProbability = [];
        end
    end
    %% 公有成员函数
    methods
        %设置模型
        obj = SetModel(obj,HMMstruct);
        %获取模型
        HMMstruct = GetModel(obj);
        %由已知观测序列优化HMM模型函数
        [obj,HMMstruct,residual,flag] = ModelOptimization(obj,observeSequence,stateSequence);
        %根据已知模型和观测量，计算特定时刻下最有可能的状态
        [stateIndex,stateProbability] = MostLikelyIndividualState(obj,observeSequence,timeIndex);
        %得到前向递推结果
        alpha = GetAlpha(obj);
        %得到后向递推结果
        beta = GetBeta(obj);
        %已知模型和观测序列，获取各时刻下观测量对应各个状态的概率
        gamma = GetGamma(obj);
        %获取从时刻t到t+1时，状态转变的概率函数
        ksai = GetKsai(obj);
        %生成观测序列
        [stateSequence,observeSequence] = GenerateObserveSequence(obj,observeLength);
        %优化参数设置
        obj = SetOptPara(obj,optPara);
        %获取前向后向递推结果
        [forwardResult,backwardResult] = GetForwardBackward(obj,observeSequence);
        %获取每一个状态对应观测量的概率分布律或者概率密度
        observePDF = GetObservePDF(obj,observeSpan);
    end
    %% 私有成员函数
    methods (Access = 'private')
        %前向递推函数
        obj = CalculateAlpha(obj);
        %后向递推函数
        obj = CalculateBeta(obj);
        %前向后向过程
        obj = ForwardBackwardProcedure(obj);
        %已知模型和观测序列，各时刻下观测量对应各个状态的概率
        obj = CalculateGamma(obj);
        %获取从时刻t到t+1时，状态转变的概率函数
        obj = CalculateKsai(obj);
        %根据给出的状态和时间序列，得到每个隐藏状态对应各个观测值的概率
        observeSequenceProbability = GetObserveProbability(obj,stateIndex,timeIndex);
        %baum-welch算法更新连续观测的混合高斯分布
        B = UpdateBContinuous(B,gamma);
    end
end