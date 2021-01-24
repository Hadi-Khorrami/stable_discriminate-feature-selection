% Calcultes intra- and inter-dataset stability
% Inputs:
% data: Cell array where each cell contains a matrix of feature values from a specific site
% rows of the data are patients, columns are feature values
% nIter: Number of random splits to perform in calculating instability
% outputDir: Where to save results (note, saves all variables, not just
% scores).  Will save 'stability.mat' to this location

function [interDifScore] = measureStability(data,nIter)

% If no save directory is given
if(nargin < 3)
    outputDir = [];
end

% Number of features is number of columns
featCount = length(data{1}(1,:));

%% Intra-dataset stability (Latent instability score)
% Randomly splits a dataset in half, compares features for significance
% across splits.  Tests "noisyness" of data.  Measures "expected"
% instability that would be seen without inter-dataset effects that is, if
% dataset variation did not affect features.
% Performed seperately for each dataset

% Recomended to load pre-computed LI scores after having run once and saved
% results
% load('path to intraDifScore');

% store tally of feature differences across random splits
% % intraDifTally = cell(1,length(data));
% % 
% % % To store final normalized scores
% % intraDifScore = cell(1,length(data));
% % 
for(k = 1:length(data))
    
    % Initalize to matrix of zeros with length = number of features
    intraDifTally{k} = zeros(1,featCount);
    
    % split dataset and tally features different
    for(i = 1:nIter)
        
        if(mod(i,10) == 0)
            fprintf('LI Iteration %d \n',i)
        end
        
        % randomly split dataset
        B=randperm(length(data{k}(:,1)));
        set1 = B(1:floor(length(B)/2));
        set2 = B((floor(length(B)/2) + 1):length(B));
        
        H = zeros(1,featCount);
        
        % Compare every feature across halves
        parfor(ii = 1:featCount)
            [P H(ii)] = ranksum(data{k}(set1,ii),data{k}(set2,ii));
        end
        
        intraDifTally{k} = intraDifTally{k} + H;
    end
    
    % normalize scores
    intraDifScore{k} = intraDifTally{k} / nIter;
end

Recomended to save intraDifScore to avoid running each time
save('filepath','intraDifScore');

%% Inter-dataset stability (Preperation-induced instability score)
% Measures observed instability between datasets
% Tests a feature across every possible pairwise comparion of datasets

% Tallies feature differences between datasets
interDifTally = zeros(1,featCount);
%
% Old one-shot method
% for(i = 1:featCount)
%     for(ii = 1:length(data))
%         for(r = (ii+1):length(data))
%             [P H] = ranksum(data{ii}(:,i),data{r}(:,i));
%             interDifTally(i) = interDifTally(i) + H;
%         end
%     end
% end
%
% % normalize scores
% interDifScore= interDifTally / nchoosek(length(data),2);

% New subsampling method
parfor(i = 1:featCount)
    fprintf('Inter-Dif feature %d \n',i)
    for(ii = 1:length(data))
        for(r = (ii+1):length(data))
            
            % Store result of each subset comparison
            H = zeros(1,nIter);
            
            % split dataset and tally features different
            for(z = 1:nIter)
                                
                % use 3/4 of each dataset per iteration
                B1=randi(size(data{r},1),[round(length(data{r}(:,1)) * 3/4), 1]);
                B2=randi(size(data{ii},1),[round(length(data{ii}(:,1)) * 3/4), 1]);
                
                
                % Compare feature across subsets
                [P,H(z)] = ranksum(data{ii}(B2,i),data{r}(B1,i));
                
            end
            
            interDifTally(i) = interDifTally(i) +  mean(H);
        end
    end
end

% normalize scores
interDifScore= interDifTally / nchoosek(length(data),2);

%% presentation
% Some output and plots which you may find useful

% % if(~isempty(outputDir))
% %     save([outputDir filesep 'stabiliFty.mat']);
% % end

% % assignin('base','interDifScore',interDifScore)
% % assignin('base','intraDifScore',intraDifScore)
% % 
% % % You will often want to split your features out by feature type, ex:
% % %     graph = (1:51);
% % %     shape = (52:151);
% % %     CGT = (152:190);
% % %     clusterG = (191:216);
% % %     texture = (217:242);
% % %     
% % %     cats{1} = graph;
% % %     cats{2} = shape;
% % %     cats{3} = CGT;
% % %     cats{4} = clusterG;
% % %     cats{5} = texture;     
% % %     % And the labels for those families
% % %     labels = {'Global graph','Shape','CGT','Sub-graph','Texture'};
% % %     colors = linspecer(length(cats));
% % %     
% % % Plot mean and std of each catagory
% % %     for(i = 1:length(cats));
% % %         fprintf('Mean PI of %s : %f std: %f \n',labels{i},mean(interDifScore(cats{i})),std(interDifScore(cats{i})));
% % %     end
% %     
% %     % For this example just one catagory is used
% %     allFeats = 1:featCount;
% %     cats{1} = allFeats;
% %     % and one label
% %     labels = {'All features'};
% %     % Plot and print LI results
% %     
% %     % Grouping variables for boxplot
% %     groups = zeros(1,featCount);
% %     for(i = 1:length(cats))
% %         groups(cats{i}) = i;
% %     end
% %     
% %     figure
% %     for(i = 1:length(data))
% %         subplot(1,length(data),i);
% %         boxplot(intraDifScore{i},groups);
% %         title(['LI Scores of Dataset ' num2str(i)]);
% %         ylabel('LI Score');
% %         set(gca,'XTickLabel',labels)
% %         fprintf('Mean LI of dataset %d: %f \n',i,mean(intraDifScore{i}));
% %     end
% %     
% %     % Five catagory per-feature catagory plotting
% % %     figure
% % %     meanIntraDifs = mean(cell2mat(intraDifScore'));
% % %     boxplot(meanIntraDifs,[ones(1,length(cats{1}))*1,ones(1,length(cats{2}))*2,ones(1,length(cats{3}))*3,ones(1,length(cats{4}))*4,ones(1,length(cats{5}))*5]);
% % 
% %     
% %     % Plot PI results
% %     figure
% %     
% %     % Binning of PI results for presentation, here the number of bins is
% %     % one eighth of the number of unique scores
% %     uVals = round(length(unique(interDifScore))/8);
% %     bars = zeros(length(cats),uVals);
% %     for(i = 1:length(cats));
% %         bars(i,:) = histcounts(interDifScore(cats{i}),uVals)'/length(cats{i});
% %     end
% %         
% %     % Some special code is needed if only one catagory is used
% %     
% %     if(length(cats) > 1)
% %         bar(bars,'stack');
% %     else
% %         bar([bars;nan(size(bars))],'stack'); xlim([.5,1.5]);
% %     end    
% %     ylim([0 1])
% % 
% %     colormap(jet);    
% %     %colormap(linspecer(uVals))
% %     colorbar('Ticks',[1,round(uVals/4),round(uVals/2),round(3*uVals/4),round(uVals)],'TickLabels',{'0','.25','.5','.75','1'})
% %     
% % %     colorBarVals = linspecer(uVals);
% % %     colorBarLabels = cell(1,length(colorBarVals));
% % %     
% % %     for(i = 1:length(colorBarVals))
% % %         colorBarLabels{i} = num2str(round(colorBarVals(i),2));
% % %     end
% % %     
% % %     colorbar('Ticks',[1,round(uVals/4),round(uVals/2),round(3*uVals/4),round(uVals)],'TickLabels',{'0','.25','.5','.75','1'})
% %     set(gca,'XTickLabel',labels)
% %     box('off')
% % %     title('PI Score Breakdown');
% %     ylabel('Percentage of Features')
% %     hold off
% %     
% %     % Instability added by dataset variation = PI/LI
% %     % Note: LI calculated as mean across all datasets, you should adjust as
% %     % appropriate if you want a different LI used
% %      meanIntraDifs = mean(cell2mat(intraDifScore'));
% %     
% %      % Multi-catagory case
% %      % figure
% %     % for(i = 1:length(cats));
% %     %     scatter(interDifScore(cats{i})./meanIntraDifs(cats{i}),zeros(1,length(cats{i})),[],colors(i,:));
% %     %     hold on
% %     % end
% %     % legend(labels)
% %     % xlabel('Ratio of PI/LI')
% %     % title('Instability added by dataset variation')
% %     
% %     % Single catagory case
% %     figure
% %     boxplot(interDifScore./meanIntraDifs,groups);
% %     title('Instability added by site');
% %     ylabel('PI/LI');
% %     set(gca,'XTickLabel',labels)
end