clearvars;

useDemoData = 1; % Set to 0 to use other data

if useDemoData 
    load ./Results/demoResults.mat;
else
    % Load the dataset of AR13D fits
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

end

% Perform Silhouette test
ss = wrapperSilhouette(XX); 

% Set k value guided by the Silhouette test
k=4;

% Run without bootstrap
[C,ids,ss] = cluster_kmeans(XX,k,[]);



%%
% With bootstrap
[CB,idsB] = cluster_kmeans_wBootstrap(XX,k);

% Plot scatter
figure; plotScatter(XX,ids);

function plotScatter(XX,ids)
    gg=gscatter(XX(:,1),XX(:,2),ids);
    pbaspect(gca,[1 1 1])
    axis([0 5 0 1])
    set(gca,'LineWidth',2,'fontSize',18); box on;
    xlabel('Activity, \it{a}',FontSize=20,Interpreter='tex');
    ylabel('Persistence, \it{q}',FontSize=20,Interpreter='tex');
    legTxt = {'Outliers','\uparrow a \uparrow q','\downarrow a \uparrow q','\downarrow a \downarrow q','Non-motile'};
    legend(legTxt, 'fontSize',16,'Location','southeast');
    set(gg,'markerSize',10);
end

function ss = wrapperSilhouette(XX)

    kmax = 6;
    ss = nan(kmax,1);
    
    for k = 2 : 6
        [~,~,s] = cluster_kmeans(XX,k,[]);
        [CB,idsB,s] = cluster_kmeans_wBootstrap(XX,k);
        ss(k) = s;
    end
    
    figure; plot([2:kmax],ss(2:end),'LineWidth',2);
    xlabel('No. of clusters k');
    ylabel('Silhouette score');
    set(gca,'fontSize',16);
end


function [CB,idsB,ss] = cluster_kmeans_wBootstrap(XX,k)

    B = 100; % Number of bootstrap iterations

    CB = nan(B,k,2); % Bootstrapped cluster centroids in (a,q) space
    idsB = nan(B,size(XX,1));
    ss = nan(B,1);

    for ib = 1 : B
        % Resample with replacement if 
        XX1 = XX; 
        XX = XX1(randi(length(XX1), length(XX1),1), :);
   
        [C,ids,s] = cluster_kmeans(XX,k,[]);
        
        CB(ib,:,:) = C;
        idsB(ib,:) = ids;
        ss(ib) = s;
    end
        


         
end



function [C,ids,s] = cluster_kmeans(XX,k,C)
    
    
    % Remove outliers with dbscan
    XXO = XX;
    XXdb = XX; inds = dbscan(normalize(XXdb),0.2,5);
    XXdb(inds == - 1,:) = [];

    % Normalize to z-scores
    mu = mean(XXdb,1);
    sigma = std(XXdb,0,1);
    
    z = (XXdb - mu)./sigma;

    if isempty(C) % 
        % Use k = 4
        [ids,Cz] = kmeans(z,k);
        s = median( silhouette(normalize(XXdb),ids) ); 

        % Revert normalization
        C = Cz.*sigma + mu;
        
    else % Use previous C if supplied
        s = [];
    end

    % Sort C to standardize clusters
    z = (XX - mu)./sigma;

    [~,I] = sort(sum(C,2),'descend');
    C = C(I,:);

    % Assign clusters to datapoints after sorting
    % Scale the cluster centroid to the z-score
    Cz = (C-mu)./sigma;

    [~,ids] = pdist2(Cz,z,'euclidean','Smallest',1);
    ids = ids';
    ids(inds==-1,:) = -1;

    % % XX = XXdb;
    % tt = setdiff(XXO,XXdb,'rows');
    % XX = [XX; tt]; ids = [ids'; -1*ones(length(tt),1)];

    

end