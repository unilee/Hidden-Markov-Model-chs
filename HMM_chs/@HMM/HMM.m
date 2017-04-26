classdef HMM
    %% ���г�Ա����
    properties
        
    end
    %% ˽�г�Ա����
    properties (Access = 'private')
        HMMstruct;         %HMMģ�ͽṹ��
        optPara;
        observeSequence;   %�۲�����
        alpha;
        beta;
        gamma;
        ksai;
        observeSequenceProbability;
    end
    %% ���캯��
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
    %% ���г�Ա����
    methods
        %����ģ��
        obj = SetModel(obj,HMMstruct);
        %��ȡģ��
        HMMstruct = GetModel(obj);
        %����֪�۲������Ż�HMMģ�ͺ���
        [obj,HMMstruct,residual,flag] = ModelOptimization(obj,observeSequence,stateSequence);
        %������֪ģ�ͺ͹۲����������ض�ʱ�������п��ܵ�״̬
        [stateIndex,stateProbability] = MostLikelyIndividualState(obj,observeSequence,timeIndex);
        %�õ�ǰ����ƽ��
        alpha = GetAlpha(obj);
        %�õ�������ƽ��
        beta = GetBeta(obj);
        %��֪ģ�ͺ͹۲����У���ȡ��ʱ���¹۲�����Ӧ����״̬�ĸ���
        gamma = GetGamma(obj);
        %��ȡ��ʱ��t��t+1ʱ��״̬ת��ĸ��ʺ���
        ksai = GetKsai(obj);
        %���ɹ۲�����
        [stateSequence,observeSequence] = GenerateObserveSequence(obj,observeLength);
        %�Ż���������
        obj = SetOptPara(obj,optPara);
        %��ȡǰ�������ƽ��
        [forwardResult,backwardResult] = GetForwardBackward(obj,observeSequence);
        %��ȡÿһ��״̬��Ӧ�۲����ĸ��ʷֲ��ɻ��߸����ܶ�
        observePDF = GetObservePDF(obj,observeSpan);
    end
    %% ˽�г�Ա����
    methods (Access = 'private')
        %ǰ����ƺ���
        obj = CalculateAlpha(obj);
        %������ƺ���
        obj = CalculateBeta(obj);
        %ǰ��������
        obj = ForwardBackwardProcedure(obj);
        %��֪ģ�ͺ͹۲����У���ʱ���¹۲�����Ӧ����״̬�ĸ���
        obj = CalculateGamma(obj);
        %��ȡ��ʱ��t��t+1ʱ��״̬ת��ĸ��ʺ���
        obj = CalculateKsai(obj);
        %���ݸ�����״̬��ʱ�����У��õ�ÿ������״̬��Ӧ�����۲�ֵ�ĸ���
        observeSequenceProbability = GetObserveProbability(obj,stateIndex,timeIndex);
        %baum-welch�㷨���������۲�Ļ�ϸ�˹�ֲ�
        B = UpdateBContinuous(B,gamma);
    end
end