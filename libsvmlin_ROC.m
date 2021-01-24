% support_vector_machine
clc;
clear;
tic

load('')

data = Train(:,1:end-2);
label = Train(:,end-1);

AV_AUC_libSVMlin = zeros(1,1344);
params = '-t 0 -q -b 1';

for ftrnum = 1:1344  
    Ftr = data(:,ftrnum);
    for i = 1:100
        [train,test] = crossvalind('HoldOut', label, 0.34);
        %# Train and test with new version
        SVMModel = svmtrain(label(train),Ftr(train,:),params);
        
        [predicted_label,~,prob_estimates] = svmpredict(label(test), Ftr(test,:), SVMModel, '-q -b 1');
        
        [~,~,~,AUCsvm(i)] = perfcurve(label(test),prob_estimates(:,1),1);
    end
    AV_AUC_libSVMlin(ftrnum) = mean(AUCsvm);
end

