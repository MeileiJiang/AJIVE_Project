function s_unions = random_subspaces_sv_dist(n, vecr, nsim)
%random_subspaces_sv_dist Empirical distribution of largest singular value
%of concatenation of orthonormal basis matrices of random subspaces with
%given ranks.
%   Input Argument:
%       n - dimension of space
%       vecr - a vector of dimensions of each subspaces
%       nsim - number of simulated samples
%   Output:
%       s_unions - largest singular values in each simulated stacked matrix. 

if nargin < 3
    nsim = 1000;
end

nb = length(vecr);
V = cell(nb, 1);

union = zeros(sum(vecr), n);
for ib = 1:nb
    V{ib} = eye(vecr(ib), n);
end

s_unions = zeros(1, nsim);

for i = 1:nsim
    for ib = 1:nb
    irow_start = sum(vecr(1 : (ib - 1))) + 1;
    irow_end = sum(vecr(1 : ib));    
    union(irow_start : irow_end, :) =  V{ib} * randorth(n);
    end
    s_unions(i) = norm(union, 2);
end

end

