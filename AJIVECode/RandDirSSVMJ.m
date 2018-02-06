function randSSVs = RandDirSSVMJ(n, vecr, nsim)
% RandDirSSVMJ Empirical distribution of largest squared singular value
% of M generating from of random subspaces with given ranks.
% 
%   Inputs:
%       n - dimension of the whole space
%       vecr - a vector of dimensions of each subspaces
%       nsim - number of simulated samples
%   Outputs:
%       randSSVs - largest squared singular values in random M. 
%
%   Copyright (c) Meilei Jiang 2017

    if ~exist('nsim', 'var')
        nsim = 1000;
    end

    nb = length(vecr);
    M = zeros(sum(vecr), n);

    randSSVs = zeros(1, nsim);

    for i = 1:nsim
        for ib = 1:nb
        irow_start = sum(vecr(1 : (ib - 1))) + 1;
        irow_end = sum(vecr(1 : ib));    
        M(irow_start : irow_end, :) =  orth(randn(n, vecr(ib)))';
        end
        randSSVs(i) = norm(M, 2)^2;
    end

end

