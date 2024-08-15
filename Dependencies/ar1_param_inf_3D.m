function [qmean,amean,postsequ_mean,postsequ] = ar1_param_inf_3D(v)
% Heterogenous AR(1) Bayesian parameter inference
% Translating the code from Christoph Mark (2015)
% Ref:

% Inference algorithm only
% Parameter boundaries
gridsize = 200;
qbound = [-1.5,1.5];
abound = [0, 20]; 

% Algorithm parameters
pmin = 1E-7;
Rq = 2;
Ra = 2;

% Likelihood function
% Parameter grid (w/o boundaries)
qgridf = linspace(qbound(1),qbound(2), gridsize+2);
qgrid = repmat(qgridf(2:end-1),gridsize,1); qgrid = qgrid';
agridf = linspace(abound(1),abound(2), gridsize+2);
agrid = repmat(agridf(2:end-1),gridsize,1);
a2grid = repmat(agridf(2:end-1),gridsize,1).^2;

% disp('Inference algorithm start');
postsequ = compostsequ(v,gridsize,pmin,Rq,Ra,qgrid,a2grid);
postsequ_mean = mean(postsequ,1);
[qmean,amean] = comppostmean(postsequ,qgrid,agrid);
% disp('Done');

end

%% Additional functions
function res = complikeInCode(vp,v,qgrid,a2grid)
% Compute likeliood on parameter grid
res = exp(...
    -(    (v(1) - qgrid.*vp(1)).^2   + (v(2) - qgrid .* vp(2)).^2 + (v(3) - qgrid .* vp(3)).^2     ) ./( 2 .* a2grid) - ...
    log(2.*pi.*a2grid)...
    );
end

% Compute new prior for next step (posterior for this step)
function newprior = compnewprior(oldprior,like,pmin,Rq,Ra)
% Posterior distribution
post = oldprior.*like;
post = post./ sum(post,'all');

% Use posterior as a starting point for new prior
newprior = post;

% Introduce minimal probability
mask = find(newprior < pmin);
newprior(mask) = pmin;

% Apply boxcar filter
ker = ones(2*Rq + 1, 2* Ra + 1 ) ./ ( (2*Rq+1).*(2*Ra+1));

newprior = conv2(newprior,ker,'same');
end

% Compute sequence of posterior dists for a sequence of measured velocities
function dist = compostsequ(ulist,gridsize,pmin,Rq,Ra,qgrid,a2grid)
%%
dist = zeros( length(ulist), gridsize, gridsize);

% Flat prior
dist(1,:,:) = 1./ (gridsize.^2);

% Forward pass
for i = 2 : length(ulist)
    dist(i,:,:) = compnewprior(squeeze(dist(i-1,:,:)), complikeInCode(ulist(i-1,:), ulist(i,:),qgrid,a2grid) ,pmin,Rq,Ra);
end

% Backward pass
backwardprior = ones(gridsize,gridsize)./(gridsize.^2);
like = [];
for i = length(ulist) : -1 : 2
    % Recompute likelihood
    like = complikeInCode(ulist(i-1,:), ulist(i,:),qgrid,a2grid);
    
    % Forward prior * likelihood * Backward prior
    dist(i,:,:) = squeeze(dist(i-1,:,:)) .* like .* backwardprior;
    dist(i,:,:) = squeeze(dist(i,:,:)) ./ sum(sum(squeeze(dist(i,:,:))));
    
    % Generate new backward prior for next iteration
    backwardprior = compnewprior(backwardprior, complikeInCode(ulist(i-1,:),ulist(i,:),qgrid,a2grid),pmin,Rq,Ra);
end

dist = dist(2:end,:,:);
end

% Compute posterior mean values from a list of posterior distributions
function [qmean,amean] = comppostmean(postsequ,qgrid,agrid)
qmean = zeros(size(postsequ,1),1);
amean = zeros(size(postsequ,1),1);
for i = 1 : size(postsequ,1)
    qmean(i) = sum(squeeze(postsequ(i,:,:)).*qgrid,'all');
    amean(i) = sum(squeeze(postsequ(i,:,:)).*agrid,'all');
end
end
