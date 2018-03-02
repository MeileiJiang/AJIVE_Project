function DiagPlotSSVMJ(dataname, vecr, randSSVs, s_M, WedinSSVbds, ...
    n_sv, xlimits, iprint, figdir, figname, ssv_hard_cut, true_WedinSSVbd)
% DiagPlotSSVMJ Make squared singular value diagnostic plot. The values of
% square singular values of M are shown as solid vertical black 
% line segments. The values of the c.d.f. of the resampled Wedin bound 
% distribution are shown as blue dots, and its 5th percentile is shown as 
% a blue dashed line. The values of the survival function of the random
% dierction angles are shown as red dots, and its 95th percentile is shown
% as a red dashed line. If the red dashed line is larger than the blue
% dashed line, i.e., the Wedin bound is more loose than the random directon
% bound, we suggests to use random direction bound or reduce the initial
% ranks. The cyan vertical dashed line shows the pre-specified joint rank cutoff.
% Inputs:
%   dataname        - cell of strings. Names of each datablock
%   randSSVs        - array of largest singular values of each union matrix under 
%                     null distribution.
%   s_M             - Singualr values of original union matrix
%   WedinSSVbds     - Resampled singular value bound for joint space
%   n_sv            - number of singular value of original union matrix to show 
%                     in the plot
%   iprint          - 0: not generate figure in the figdir
%                   - 1: generate figure in the figdir
%   figdir          - diretory to save figure
%   figname         - a string: figure file name
%   xlimit          - a vector [l u] specifying the limits of x axis
%   ssv_hard_cut    - a threshold to give the pre-specified joint rank. Default is -1. 
%   true_WedinSSVbd - theoretical value of the Wedin bound
% Outputs:
%   Graphics only. No value returns.
%
%    Copyright (c)  Meilei Jiang 2017
    
    WedinSSVbds(WedinSSVbds < 1) = 1;
    sortRandSSVs = quantile(randSSVs, 1:-0.025:0);
    ygrid = 0:1/(length(sortRandSSVs) - 1):1;
    
    randSSVbd = prctile(randSSVs, 95);
    WedinSSVbd = prctile(WedinSSVbds, 5);
    sortSVbound = quantile(WedinSSVbds, 0:0.025:1);
    bound_ygrid = 0:1/(length(sortSVbound) - 1):1;
    titletxt = '';
    for i = 1:length(vecr)
        titletxt = strcat(titletxt, {dataname{i}}, {':'},{num2str(vecr(i))}, {'  '});
    end
        
    fig = figure;
    scatter(sortRandSSVs, ygrid, 30, 'ro')
    hold on
    scatter(sortSVbound, bound_ygrid, 45, 'b+')
    line([randSSVbd randSSVbd], [0 1], ...
        'color', 'r', 'LineStyle', '-.', 'LineWidth', 1.8)
    line(xlimits, [0.05 0.05], ...
        'color', [0.5, 0.5, 0.5], 'LineStyle', '-.')
    line([WedinSSVbd WedinSSVbd], [0 1], ...
         'color', 'b', 'LineStyle', '--', 'LineWidth', 1.8)
    if exist('true_WedinSSVbd', 'var')
        if true_WedinSSVbd < 1
            true_WedinSSVbd = 1;
        end
        line([true_WedinSSVbd true_WedinSSVbd], [0 1], ...
     'color', 'b')
    end
    if exist('ssv_hard_cut', 'var') && ssv_hard_cut >= 0
        line([ssv_hard_cut ssv_hard_cut], [0 1], 'color', 'c', ...
            'LineStyle', '--', 'LineWidth', 2)
    end
    for i = 1:min(length(s_M), n_sv)
        line([s_M(i)^2 s_M(i)^2], [0.25 0.75], ...
             'color', 'k')
    end
    scatter(s_M.^2, linspace(0.65, 0.35, length(s_M)), 30, 'k+')
    title({'Squared Singular Value', ...
        titletxt{1}}, 'Fontsize', 14)
    if exist('xlimits', 'var')
        xlim(xlimits);
    end
    hold off
    
    if exist('iprint', 'var') && iprint == 1
        if ~exist('figdir', 'var') || ~exist(figdir, 'dir')
            disp('No valid figure directory found! Will save to current folder.')
            figdir = '';
        end
              
        if ~exist('figname', 'var') || isempty(figname)
            figname = 'DiagPlot_SSV';
            for i = 1:length(vecr)
                figname = strcat(figname, '_', dataname{i}, '_', num2str(vecr(i)));
            end
        end
        
        savestr = strcat(figdir, figname);        
        try
            orient landscape
            print(fig, '-depsc', savestr)
            disp('Save squared singular value diagnostic plot successfully!')
        catch
            disp('Fail to save squared singular value diagnostic plot!')
        end
    end    
end