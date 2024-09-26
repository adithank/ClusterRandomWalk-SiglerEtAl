function [C,ids,s,inds] = cluster_kmeans(XX,k,C,indsOut)
    
    if nargin < 4 
       indsOut = [];
    end
    
    eps = 0.5; 
    nMin = floor(0.02*size(XX,1));
    XXO = XX; XXdb = XX; 
    if isempty(indsOut)
        % Remove outliers with dbscan
        inds = dbscan(normalize(XXdb),eps,nMin) == -1;
    elseif indsOut == 0
        inds = logical(zeros(size(XXO,1),1));
    else
        inds = indsOut;
    end
    XXdb(inds,:) = [];
    ids = nan(size(XXO,1),1);
    
    

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

        % Sort C to standardize clusters
        [~,I] = sort(sum(C,2),'descend');
        C = C(I,:);
        
        [~,idstt] = pdist2(Cz,z,'euclidean','Smallest',1);
        idstt = idstt';

        % Consider outliers as well
        % if isempty(indsOut)
        %     tt = setdiff(XXO,XXdb,'rows');
        %     XX = [XXdb; XXO(inds==-1,:)]; 
        %     ids = [idstt; -1*ones(sum(inds==-1),1)];
        % else
        %     ids(indsOut) = -1;
        %     ids(~indsOut) = idstt;
        % end
        
        


    else % Use previous C if supplied
        s = [];
        % z = (XX - mu)./sigma;
        
        % Scale the cluster centroid to the z-score
        Cz = (C-mu)./sigma;

        [~,idstt] = pdist2(Cz,z,'euclidean','Smallest',1);
        idstt = idstt';
    end
    ids(inds) = -1;
    ids(~inds) = idstt;


    


    

end