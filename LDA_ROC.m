clc;
clear;

load('')

data = Train(:,1:end-2);
Group = Train(:,end-1);

k = 3;
AV_AUC_LDA = zeros(1,1344);

for ftrnum = 1:1344
    featureSelcted = data(:,ftrnum);
    if sum(featureSelcted ~= 0) == 0
        AV_AUC_LDA(ftrnum) = 0.500;
    else
    rng('shuffle');
    for i = 1:40   
        cvFolds = crossvalind('Kfold', Group, k);
        for j = 1:3                                  
            testIdx = (cvFolds == j);
            trainIdx = ~testIdx;
        
            lda = fitcdiscr(featureSelcted(trainIdx,:),Group(trainIdx), ...
                    'discrimType','linear');
            [prediction{i},posteriorprob{i}] = predict(lda,featureSelcted(testIdx,:));
          
            [~,~,~,AUC,~,~,~] = perfcurve(Group(testIdx),posteriorprob{i}(:,2),1);
            AUCurve{i}(j) = AUC;        
        end
    end
    LDA_AUC = cell2mat(AUCurve);
    AV_AUC_LDA(ftrnum) = mean(LDA_AUC);
    end
end


