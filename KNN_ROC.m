% k-Nearest Neighbor Search
% % 
clc;
clear;

load('')

data = Train(:,1:end-2);
Group = Train(:,end-1);

%% Construct a KNN classifier
% KNNClassifierObject = fitcknn(featureSelcted, groundTruthGroup, 'NumNeighbors', 3, 'Distance', 'euclidean');
% % KNNClassifierObject = fitcknn(featureSelcted, Group, ...
% %     'NumNeighbors',3,'NSMethod','exhaustive','Distance','minkowski',...
% %     'Standardize',1);
tic

k = 3;
AV_AUC_KNN = zeros(1,1344);

for ftrnum = 1:1344
    featureSelcted = data(:,ftrnum);
    rng('shuffle');
    for i = 1:40   
        cvFolds = crossvalind('Kfold', Group, k);
        for j = 1:3                                  
            testIdx = (cvFolds == j);
            trainIdx = ~testIdx;
            KNNClassifierObject = fitcknn(featureSelcted(trainIdx,:),Group(trainIdx), ...
                'NumNeighbors',3,'NSMethod','exhaustive','Distance', ...
                'euclidean','Standardize',1);
        
            [prediction{i},postriorprob{i}] = predict(KNNClassifierObject,featureSelcted(testIdx,:));      
            [~,~,~,AUC,~,~,~] = perfcurve(Group(testIdx),postriorprob{i}(:,2),1);
            AUCurve{i}(j) = AUC;        
        end
    end
    KNN_AUC = cell2mat(AUCurve); 
    AV_AUC_KNN(ftrnum) = mean(KNN_AUC);
end


    
    
    
    