function [CB,ids,ss] = cluster_kmeans_wBootstrap(XX,k)

    B = 1000; % Number of bootstrap iterations

    CB = nan(B,k,2); % Bootstrapped cluster centroids in (a,q) space
    idsB = nan(B,size(XX,1));
    ss = nan(B,1);

    XX1 = XX; 
    
    [~,~,~,indsOut] = cluster_kmeans(XX1,k,[]);

    for ib = 1 : B
        % Resample with replacement if 
        
        XX1 = XX(randi(length(XX), length(XX),1), :);
   
        [C,ids,s] = cluster_kmeans(XX1,k,[],indsOut);
        
        CB(ib,:,:) = C;
        % idsB(ib,:) = ids;
        ss(ib) = s;
        % gscatter(XX(:,1),XX(:,2),ids,'','.',12); drawnow; pause(0.5)
    end 

    [~,ids] = cluster_kmeans(XX,k,squeeze(mean(CB,1)),0);

end