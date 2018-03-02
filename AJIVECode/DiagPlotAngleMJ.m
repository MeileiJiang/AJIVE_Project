function DiagPlotAngleMJ(dataname, vecr, randAngles, pangles, WedinAnglebds, ...
    n_sv,  iprint,figdir, figname, angle_hard_cut, true_WedinAnglebd)
% DiagPlotAngleMJ Make principal angle diagnostic plot. The values of
% principal angles between the two datablock are shown as solid vertical black 
% line segments. The values of survival function of the resampled Wedin
% bound distribution are shown as blue dots, and its 95th percentile is
% shown as a blue dashed line. The values of the c.d.f. of the random
% dierction angles are shown as red dots, and its 5th percentile is shown
% as a red dashed line. If the red dashed line is smaller than the blue
% dashed line, i.e., the Wedin bound is more loose than the random directon
% bound, we suggests to use random direction bound or reduce the initial
% ranks.
% Inputs:
%   dataname          - cell of strings. Names of each datablock
%   randAngles        - array of smallest principal angles of among two datablocks  
%                       under null distribution.
%   pangles           - array of principal angle between original datablocks
%   WedinAnglebds     - Resampled angle bounds
%   n_sv              - number of singular value of original union matrix to show 
%                       in the plot
%   iprint            - 0: not generate figure in the figdir
%                     - 1: generate figure in the figdir
%   figdir            - diretory to save figure
%   figname           - a string: name of figure file.
%   true_WedinAnglebd - theoretical value of the Wedin bound
% Outputs:
%   Graphics only. No value returns.
%
%   Copyright (c)  Meilei Jiang 2017 

    sortAngles = quantile(randAngles, 0:0.025:1);
    ygrid = 0:1/(length(sortAngles) - 1):1;
    
    nullAngle = prctile(randAngles, 5);
    
    angleBoundp = prctile(WedinAnglebds, 95);
    sortAngleBound = quantile(WedinAnglebds, 1:-0.025:0);
    bound_ygrid = 0:1/(length(sortAngleBound) - 1):1;
    titletxt = '';
    for i = 1:length(vecr)
        titletxt = strcat(titletxt, {dataname{i}}, {':'},{num2str(vecr(i))}, {'  '});
    end
    fig = figure;    
    scatter(sortAngles, ygrid, 30, 'ro')
    hold on
    scatter(sortAngleBound, bound_ygrid, 45, 'b+')
    line([nullAngle nullAngle], [0 1], ...
        'color', 'r', 'LineStyle', '-.', 'LineWidth', 1.8)
    line([0 90], [0.05 0.05], ...
        'color', [0.5, 0.5, 0.5], 'LineStyle', '-.')
    line([angleBoundp angleBoundp], [0 1], ...
     'color', 'b', 'LineStyle', '--', 'LineWidth', 1.8)
    if exist('true_WedinAnglebd', 'var')
        line([true_WedinAnglebd true_WedinAnglebd], [0 1], ...
     'color', 'b', 'LineWidth', 2)
    end
    if exist('angle_hard_cut', 'var') && angle_hard_cut >= 0
        line([angle_hard_cut angle_hard_cut], [0 1], 'color', 'c', ...
            'LineStyle', '--', 'LineWidth', 2)
    end
    for i = 1:min(length(pangles), n_sv)
        line([pangles(i) pangles(i)], [0.25 0.75], ...
             'color', 'k')
    end
    scatter(pangles, linspace(0.65, 0.35, length(pangles)), 30, 'k+')
    title({'Principal Angles', ... 
          titletxt{1}},...
         'Fontsize', 14)
    hold off
    
    if exist('iprint', 'var') && iprint == 1
        if ~exist('figdir', 'var') || ~exist(figdir, 'dir')
            disp('No valid figure directory found! Will save to current folder.')
            figdir = '';
        end
        
        if ~exist('figname', 'var') || isempty(figname)
            figname = 'DiagPlot_Angle';
            for i = 1:length(vecr)
                figname = strcat(figname, '_', dataname{i}, '_', num2str(vecr(i)));
            end
        end
        
        savestr = strcat(figdir, figname);        
        try
            orient landscape
            print(fig, '-depsc', savestr)
            disp('Save principal angle diagnostic plot successfully!')
        catch
            disp('Fail to save principal angle diagnostic plot!')
        end
    end    
end