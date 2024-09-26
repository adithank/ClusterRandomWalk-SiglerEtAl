clearvars;
restoredefaultpath;
addpath(genpath(cd));

% Load all dataset of AR13D fits for clustering
AR13DFits = {};
tt=dir('./Results/*AR13D-*.mat');
for ii = 1:length(tt); tt1=load(tt(ii).name); AR13DFits = [AR13DFits; tt1.AR1Fit]; end; clear tt;

%Get cell-averaged (qt,at) 
amean = nan(length(AR13DFits),1); qmean = amean;
for ii = 1 : length(AR13DFits)
    amean(ii) = mean(AR13DFits{ii}.at);
    qmean(ii) = mean(AR13DFits{ii}.qt);
end

XX = [amean qmean];

%% Perform Silhouette test (Optional)
ss = wrapperSilhouette(XX); 

%% Set k value guided by the Silhouette test
k=4;
% Run k-means with bootstrap
[CB,ids] = cluster_kmeans_wBootstrap(XX,k);

%% Plot scatter
figure; plotScatter(CB,XX,ids); 