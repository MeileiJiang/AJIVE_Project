function [ssvboundp, ssvbound] = AJIVEJointAngleBound(datablock, vecr, nresample, threp)
%JIVEJointThreshold Gives the angle bound for segment the joint space
%   Input:
%       datablock:  - cells of data matrices {datablock 1, ..., datablock k}
%                     Each data matrix is a d x n matrix that each row is a
%                     mesurement.
%       vecr:       - a vector of selected ranks for each data matrix;
%       nresample:  - number of re-samples in the AJIVE step 2 for estimating 
%                     the perturbation bounds; default value is 1000;
%       threp:      - the choice of percentile for singular value bound
%                     from resampled singular values.
%   Output:
%       ssvbound:   - bounds on squared singular value
%       ssvboundp:  - percentile of bounds on squared singular value

%    Copyright (c) Meilei Jiang, Jan Hannig & J. S. Marron 2017

nb = length(datablock);

% compute perturbation bound for each data block
% append customized percentile with default
if nargin < 4
    disp('No input of threp. Median of re-sampled  is used as threhold.');
    threp = 50;
end

bound = zeros(nb, nresample);
for ib = 1:nb
    % perturbation bound of SVD of each data block (Wedin)
    bound(ib,:) = SVDBoundWedin(datablock{ib}, vecr(ib), nresample);
end

% bound on squared singular value (s_union^2)
ssvbound = sum(cosd(bound).^2, 1); 

% percentile of squared singualr value bound
ssvboundp = prctile(ssvbound, threp);

end

