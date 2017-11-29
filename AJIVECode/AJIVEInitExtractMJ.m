function [M, angleBound, threshold] = AJIVEInitExtractMJ(datablock, vecr, ...
         nresample, dataname)
%AJIVEInitExtractMJ First step of AJIVE: Signal Space Inital Extraction.
%   Inputs:
%       datablock        - cells of data matrices {datablock 1, ..., datablock nb}
%                        - Each data matrix is a d x n matrix that each row is
%                        a feature and each column is a data object 
%                        - Matrices are required to have same number of objects
%                        i.e. 'n'. Number of features i.e. 'd' can be different
%       vecr             -  a vector of estimated signal ranks for each data block.
%       nresample        - number of re-samples in the AJIVE step 2 for
%                          estimating the perturbation bounds; default value is 1000;
%   Outputs:
%       M                - a sum(vecr) x n matrix which stacks the
%                        transpose extracted right singular matrix of each 
%                        data block.
%       angleBound       - a nb x nresample matrix containing the resampled 
%                        Wedin bound for the SVD perturbation angle of each
%                        data matrix.
%       threshold        - a nb x 1 vector containing the singular value
%                        threshold for noise and signal.

%    Copyright (c)  Meilei Jiang 2017

    nb = length(datablock); % number of blocks
    
    % low rank svd of each data block separately
    M = zeros(sum(vecr), size(datablock{1}, 2)); % stack of each row space basis vectors
    threshold = zeros(1, nb);
    angleBound = zeros(nb, nresample);
    for ib = 1:nb
        fprintf('The input initial signal rank for %s: %d \t', dataname{ib}, vecr(ib))
        [u, s, v] = svds(datablock{ib}, vecr(ib) + 1);
        threshold(ib) = (s(vecr(ib), vecr(ib)) + s(vecr(ib)+1, vecr(ib)+1))/2; % threshold of singular values
        U0 = u(:, 1:vecr(ib));
        V0 = v(:, 1:vecr(ib));
        S0 = s(1:vecr(ib), 1:vecr(ib));
        if ib == 1
            M(1:vecr(ib), :) = V0';
        else
            M((sum(vecr(1:(ib-1))) + 1):sum(vecr(1:ib)), :) =  V0';       
        end
        % estimating approximation accuracy
        angleBound(ib, :) = SVDBoundWedinMJ(datablock{ib}, vecr(ib), nresample, U0, S0, V0);
        % report the 95 percentile perturbation angle of SVD approximation       
        fprintf('SVD perturbation angle: %.2f \n', prctile(angleBound(ib,:), 95) )
    end
    
end

