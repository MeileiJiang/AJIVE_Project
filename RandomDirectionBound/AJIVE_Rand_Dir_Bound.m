function [pval, nullsv, svbound, ps_union, s_unions] = AJIVE_Rand_Dir_Bound(datablock, vecr,...
    nsim, dataname, threp, iplot, iprint, figdir)
%AJIVE_Rand_Dir_Bound Calculate the random direction SV distribution and
%bound. Comparing with Wedin bound. Calculate the percentile of Wedin bound
%with respect to random direction SV distribution.
%              
%   Input:
%       datablock - a cell of data matrices with dimension p_k by n.
%       vecr - a vector of input ranks for each datablock low rank
%       approximation
%       nsim - a number of simulated null singular values
%       dataname - a cell of strings representing the names of each
%       datablock.
%       threp - a percentile for resampled singular value bound
%       iplot - a indicator of making plot
%       iprint - a indicator of saving plot
%       figdir - a string of figure directory
%   Output:
%       pval - p value of test: the probability that AJIVE identifies
%       spurious joint components
%       nullsv - 95 percentile of simulated largest singular values of
%       concatenation of orthonormal basis matrices from random subspaces
%       with given ranks in vecr.
%       svbound - a vector of singular value bounds of joint space for the
%       concantenation of right singular vector matrices of each datablock
%       with given ranks in vecr.
%       ps_unions - a vector of signular values of the concantenation of 
%       right singular vector matrices of each datablock with given ranks
%       in vecr.
%       s_unions - largest singular values in each simulated stacked matrix.
%   Author:
%       Copyright (c)  Meilei Jiang 2017

    %% initialize
    if iprint == 1
        if ~exist('figdir', 'var')
            figdir = '';
        end
    end
    nresample = 1000;
    nsample = size(datablock{1}, 2);
    k = length(datablock);
    for i = 1:k
        disp(['Input rank for ' dataname{i} ' is ' num2str(vecr(i))])
    end

    %% calculate the principal angles among original datablocks
    ps_union = paa(datablock, vecr);
    fprintf('The singular value of stacked row spaces among original datablocks are: \n')
    for i = 1:length(ps_union)
        fprintf('%.2f \t', ps_union(i))
    end
    fprintf('\n')

    %% calculate the squared singular value threshold
    [ssvboundp, ssvbound] = AJIVEJointAngleBound(datablock,vecr, nresample, threp);
    svbound = sqrt(ssvbound);
    fprintf('The %d%% percentile bound of singular value for joint space is %.2f \n', threp, sqrt(ssvboundp))

    if k == 2
        pangles = acosd(min(max(ps_union.^2 - 1, 0), 1));
        fprintf('The principal angles between %s and %s: \t', dataname{1}, dataname{2})
        for i = 1:length(pangles)
            fprintf('%.2f \t', pangles(i))
        end
        fprintf('\n')
        angleBound = acosd(max(ssvbound - 1, 0));
        angleBoundp = acosd(max(ssvboundp - 1, 0));
        fprintf('The %d%% percentile bound of principal angle for joint space is %2.2f\n', threp, angleBoundp);
    end

    %% test stat null distribution
    s_unions = random_subspaces_sv_dist(nsample, vecr, nsim);
    nullsv = prctile(s_unions, 95);
    tests = s_unions > sqrt(ssvboundp); 
    
    fprintf('The 95%% percentile of the largest singular value of stacked row space bases\nunder the null distribution is %2.2f\n', ...
    nullsv);
    if k == 2
        angles = acosd(max(s_unions.^2 - 1, 0));
        nullAngle = prctile(angles, 5);
        fprintf('The 5%% percentile of the smallest principal angle between %s and %s\nunder the null distribution is %2.2f\n', ...
        dataname{1}, dataname{2}, nullAngle);
    end

    %% get p-values

    pval = sum(tests)/size(tests, 2);
    disp(['p-value of the test is ' num2str(pval)])

    %% make plot
    if iplot == 1       
        
        if k == 2
        % principal angle plot    
            PrincipalAngleDistPlot(dataname, vecr, angles, pangles, angleBound, ... 
              10, figdir, 'Principal Angle Distribution Plot', iprint)
        end
        % singular value plot
        xlimits = [1, k];
        ResampleSVDistPlot(dataname, vecr, s_unions, ps_union, svbound, 10, ...
            figdir, 'Singular Value Distribution Plot', iprint, xlimits)
        
    end

end

