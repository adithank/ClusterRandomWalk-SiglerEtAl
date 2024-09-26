function ss = wrapperSilhouette(XX)

    kmax = 6;
    ss = nan(kmax,1);
    
    for k = 2 : 6
        % [~,~,s] = cluster_kmeans(XX,k,[]);
        [CB,idsB,s] = cluster_kmeans_wBootstrap(XX,k);
        ss(k) = mean(s);
    end
    
    figure; plot([2:kmax],ss(2:end),'LineWidth',2);
    xlabel('No. of clusters k');
    ylabel('Silhouette score');
    set(gca,'fontSize',16);
end