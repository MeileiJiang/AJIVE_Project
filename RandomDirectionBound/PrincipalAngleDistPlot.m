function PrincipalAngleDistPlot(dataname, vecr, angles, pangles, ...
    angleBound, n_sv, figdir, filename, iprint, true_bound)
% ResampleSVDist Make the cdf and density plot of singular values of union 
% matrix under null distribution, the singular value bound and sigular 
% values of original union matrix.
% Inputs:
%   dataname  - cell of strings. Names of each datablock
%   angles    - array of smallest principal angles of among two datablocks  
%               under null distribution.
%   pangles   - array of principal angle between original datablocks
%   angleBound- Resampled angle bounds
%   n_sv      - number of singular value of original union matrix to show 
%               in the plot
%   figdir    - diretory to save figure
%   iprint    - 0: not generate figure in the figdir
%             - 1: generate figure in the figdir
%   true_bound - theoretical value of the bound
% Outputs:
%   Make figure. 

%    sortAngles = sort(angles);
    sortAngles = quantile(angles, 0:0.01:1);
    ygrid = 0:1/(length(sortAngles) - 1):1;
    
    nullAngle = prctile(angles, 5);
    
    angleBoundp = prctile(angleBound, 95);
%    sortAngleBound = sort(angleBound, 'descend');
    sortAngleBound = quantile(angleBound, 1 - (0:100)/100);
    bound_ygrid = 0:1/(length(sortAngleBound) - 1):1;
    titletxt = '';
    for i = 1:length(vecr)
        titletxt = strcat(titletxt, {dataname{i}}, {':'},{num2str(vecr(i))}, {'  '});
    end
    fig = figure;    
    scatter(sortAngles, ygrid, 2, 'r')
    hold on
    scatter(sortAngleBound, bound_ygrid, 2, 'b')
    line([nullAngle nullAngle], [0 1], ...
        'color', 'r', 'LineStyle', '--', 'LineWidth', 2)
    line([0 90], [0.05 0.05], ...
        'color', [0.5, 0.5, 0.5], 'LineStyle', '-.')
    line([angleBoundp angleBoundp], [0 1], ...
     'color', 'b', 'LineStyle', '--', 'LineWidth', 2)
    if nargin == 10
        line([true_bound true_bound], [0 1], ...
     'color', 'b', 'LineWidth', 2)
    end
    for i = 1:min(length(pangles), n_sv)
        line([pangles(i) pangles(i)], [0.25 0.75], ...
             'color', 'k')
    end
    scatter(pangles, linspace(0.65, 0.35, length(pangles)), 30, 'k+')
    title({'Principal Angles and Angle Bound', ... 
          titletxt{1}},...
         'Fontsize', 14)
    hold off
    
    if iprint == 1
        if filename == ""
            filename = 'PrincipalAngle';
            for i = 1:length(vecr)
                filename = strcat(filename, dataname{i}, num2str(vecr(i)));
            end
        end
        savestr = strcat(figdir, filename);        
        orient landscape
        print(fig, '-dpdf', savestr)
    end    
end