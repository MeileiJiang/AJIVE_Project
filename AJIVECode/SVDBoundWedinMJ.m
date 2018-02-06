function angleBound = SVDBoundWedinMJ(datablock, r, nresample, U, S, V)
% SVDBoundWedinMJ function for estimating the perturbation bound between V 
% and its true signal through a bootstrap prosedure.
% This perturbation bound is based on Wedin's sin \theta theory (Wedin, 1972)
% Inputs:
%   datablock         - a d x n data matrix 
%   r                 - selected rank for data matrix
%   nresampe          - number of re-samples for estimating the
%                       perturbation bounds; default value is 1000;
%   U                 - a d x r left singular matrix of datablock
%   S                 - a r x r diagonal singular value matrix of datablock
%   V                 - a n x r right singular matrix of datablock
% Output:
%   bound             - Resampled perturbation principal angle bounds of
%                       SVD approximation
%   Copyright (c)  Meilei Jiang 2017


    if ~exist('U', 'var') || ~exist('S', 'var') ||~exist('V', 'var')
        [U, S, V] = svds(datablock, r);
    end

    
    angleBound = [];
    % resample p direction from null space
    Rcreatenorm = JIVErandnullQF(datablock, V, r, nresample);
    Screatenorm = JIVErandnullQF(datablock', U, r, nresample);

    delta = S(r, r);% assume no small signal

    % Wedin's bound
    angleBound(1,:) = asind(min(max(Rcreatenorm, Screatenorm)/delta, 1));
end