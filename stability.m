clc;
clear
close all;

load('')

% data{1} = CCF set;
data{1} = Train(find(Train(:,1346)==2),:);
% data{2} = UH set;
data{2} = Train(find(Train(:,1346)==3),:);
%% for patients have no cancer

% data{1} = data{1}(find(~data{1}(:,673)),1:672);

% data{2} = data{2}(find(~data{2}(:,673)),1:672);

%% for patients have cancer

data{1} = data{1}(find(data{1}(:,1345)),1:1344);

data{2} = data{2}(find(data{2}(:,1345)),1:1344);

%% compute Sinstability

nIter = 1000;
PI = measureStability(data,nIter);

