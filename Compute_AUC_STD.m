clc;
clear;

% load('C:\Users\mxk760\Desktop\Site_mat\Decision_tree_AUC.mat')
load('C:\Users\mxk760\Desktop\Site_mat\half\KNN_AUC.mat')
load('C:\Users\mxk760\Desktop\Site_mat\half\LDA_AUC.mat')
% load('C:\Users\mxk760\Desktop\Site_mat\LinRegression_AUC.mat')
% load('C:\Users\mxk760\Desktop\Site_mat\logitBoost_AUC.mat')
% load('C:\Users\mxk760\Desktop\Site_mat\NN_AUC.mat')
load('C:\Users\mxk760\Desktop\Site_mat\half\libSVMlin_AUC.mat')
load('C:\Users\mxk760\Desktop\Site_mat\half\libSVMpoly_AUC.mat')
load('C:\Users\mxk760\Desktop\Site_mat\half\libSVMRBF_AUC.mat')
% load('C:\Users\mxk760\Desktop\Site_mat\RF_AUC.mat')
% load('C:\Users\mxk760\Desktop\Site_mat\RobustBoost_AUC.mat')
% load('C:\Users\mxk760\Desktop\Site_mat\SVM_AUC.mat')
load('C:\Users\mxk760\Desktop\Site_mat\half\NB_AUC.mat')
load('C:\Users\mxk760\Desktop\Site_mat\half\TreeBoost_AUC.mat')

Mean = zeros(1,1344);
STD = zeros(1,1344);
for i = 1:1344
    Mean(i) = (AV_AUC_KNN(i)+AV_AUC_LDA(i)+AV_AUC_libSVMlin(i) ...
        +AV_AUC_libSVMpoly(i)+AV_AUC_libSVMRBF(i)+ AV_AUC_NB(i) ...
        +AV_AUC_Tree(i))/7;
    
    STD(i) = sqrt(((AV_AUC_KNN(i)-Mean(i))^2+(AV_AUC_LDA(i)-Mean(i))^2 ...
      +(AV_AUC_libSVMlin(i)-Mean(i))^2 +(AV_AUC_libSVMpoly(i)-Mean(i))^2 ...
      +(AV_AUC_libSVMRBF(i)-Mean(i))^2+(AV_AUC_NB(i)-Mean(i))^2 ...
      +(AV_AUC_Tree(i)-Mean(i))^2)/6);
end

save('C:\Users\mxk760\Desktop\Site_mat\half\AUC_Mean_STD','Mean','STD');