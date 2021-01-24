clc;
clear;
load('')

data = Train(:,1:end-2);
Group = Train(:,end-1);

tic
k = 3;
AV_AUC_NB = zeros(1,1344);

for ftrnum = 1:1344
    featureSelcted = data(:,ftrnum);
    if all(~diff(sort(featureSelcted(:)))) == 1
        AV_AUC_NB(ftrnum) = 0.500;
    else
        featureSelcted = data(:,ftrnum);
        rng('shuffle');
        for i = 1:40   
            cvFolds = crossvalind('Kfold', Group, k);
            for j = 1:3                                  
                testIdx = (cvFolds == j);
                trainIdx = ~testIdx;         
                %# train an Naive Bayse model over training instances
                %# distribution: 'kernel' | 'mn' | 'mvmn' | 'normal' | 
                distribution = repmat({'kernel'},1,1);
                Nb = fitcnb(featureSelcted(trainIdx,:),Group(trainIdx),'dist',distribution);
        
                [prediction{i},posteriorprob{i}] = predict(Nb,featureSelcted(testIdx,:));
      
                [~,~,~,AUC,~,~,~] = perfcurve(Group(testIdx),posteriorprob{i}(:,2),1);
                AUCurve{i}(j) = AUC;
            end
        end
    NB_AUC = cell2mat(AUCurve);
    AV_AUC_NB(ftrnum) = mean(NB_AUC);
    end
end


