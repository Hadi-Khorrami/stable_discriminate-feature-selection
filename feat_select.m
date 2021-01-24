clc;
clear;

load('')

data = Train_intra(:,1:end-1);
[data, ~] = balance_data(data);
labels = Train-intra(:,end)+1;


% [MIM] = feast('mim',10,data,labels);
[MRMR] = feast('mrmr',30,data,labels);
% [CMIM] = feast('cmim',10,data,labels);
% [sel_Feat_jmi] = feast('jmi',35,data,labels);
% [sel_Feat_disr] = feast('disr',35,data,labels);
% [sel_Feat_cife] = feast('cife',35,data,labels);
% [sel_Feat_icap] = feast('icap',35,data,labels);
% [sel_Feat_cond] = feast('condred',35,data,labels);
% [sel_Feat_cmi] = feast('cmi',35,data,labels);
% [sel_Feat_relief] = feast('relief',35,data,labels);
% [MIFS] = feast('mifs',10,data,labels);
% [sel_Feat_fcbf] = feast('fcbf',3,data,labels,0.1);
% [sel_Feat_betagamma] = feast('betagamma',35,data,labels,0.1,0.1);
[~, WLCX] = Wilkcoxnew(data,labels);
[~, TTEST] = ttestnew(data,labels);
% [~, sel_Feat_Kolmogorov_Smirnov] = kstestnew(data,labels);
% [~, sel_Feat_ftest] = ftestnew(data,labels);
% [sel_Feat_chisquare] =  fsChiSquare(data,labels);
% [sel_Feat_fisher] = fsFisher(data,labels);
% [sel_Feat_gini] = fsGini(data,labels);
% [FCBF] = fsFCBF(data,labels);
% [Kruskal] = fsKruskalWallis(data, labels);
% [sel_feat_Fuz_MI, sel_feat_Fuz_Entropy] = Fuzzy_MI(data, labels);

%%%%%%%%%%%%%%%%%%%% FEED FORWARD FEATURE SELECTION %%%%%%%%%%%%%%%%%%%%%
% X = data;
% y = Train(:,end);
% c = cvpartition(y,'k',3);
% opts = statset('display','iter');
% [fs,history] = sequentialfs(@PartLDA,X,y,'cv',c,'options',opts);
MRMR = MRMR';
WLCX = WLCX(1,1:30);
TTEST = TTEST(1,1:30);







