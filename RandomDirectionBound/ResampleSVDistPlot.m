function ResampleSVDistPlot(dataname, vecr, s_unions, ps_union, ...
    svbound, n_sv, figdir, filename, iprint, xlimits, true_bound)
% ResampleSVDistPlot Make the cdf and density plot of singular values of  
% union matrix under null distribution, the singular value bound and  
% sigular values of original union matrix.
% Inputs:
%   dataname  - cell of strings. Names of each datablock
%   s_unions  - array of largest singular values of each union matrix under 
%               null distribution.
%   ps_union  - Singualr values of original union matrix
%   svbound   - Resampled singular value bound for joint space
%   n_sv      - number of singular value of original union matrix to show 
%               in the plot
%   figdir    - diretory to save figure
%   iprint    - 0: not generate figure in the figdir
%             - 1: generate figure in the figdir
%   xlimit    - a vector [l u] specifying the limits of x axis
%   true_bound - theoretical value of the bound
% Outputs:
%   Make figure. No value returns.
    
    svbound(svbound < 1) = 1;
    %sortSVs = sort(s_unions, 'descend');
    sortSVs = quantile(s_unions, 1 - (0:100)/100);
    ygrid = 0:1/(length(sortSVs) - 1):1;
    
    nullsv = prctile(s_unions, 95);
    svboundp = prctile(svbound, 5);
    sortSVbound = quantile(svbound, (0:100)/100);
    bound_ygrid = 0:1/(length(sortSVbound) - 1):1;
    titletxt = '';
    for i = 1:length(vecr)
        titletxt = strcat(titletxt, {dataname{i}}, {':'},{num2str(vecr(i))}, {'  '});
    end
        
    fig = figure;
    scatter(sortSVs.^2, ygrid, 2, 'r')
    hold on
    scatter(sortSVbound.^2, bound_ygrid, 2, 'b')
    line([nullsv^2 nullsv^2], [0 1], ...
        'color', 'r', 'LineStyle', '--', 'LineWidth', 2)
    line(xlimits, [0.05 0.05], ...
        'color', [0.5, 0.5, 0.5], 'LineStyle', '-.')
    line([svboundp^2 svboundp^2], [0 1], ...
         'color', 'b', 'LineStyle', '--', 'LineWidth', 2)
    if nargin >= 11
        if true_bound < 1
            true_bound = 1;
        end
        line([true_bound true_bound], [0 1], ...
     'color', 'b')
    end
    for i = 1:min(length(ps_union), n_sv)
        line([ps_union(i)^2 ps_union(i)^2], [0.25 0.75], ...
             'color', 'k')
    end
    scatter(ps_union.^2, linspace(0.65, 0.35, length(ps_union)), 30, 'k+')
    title({'Squared Singular Value and Squared Singular Value Bound',...
        titletxt{1}}, 'Fontsize', 14)
    if nargin >= 10
        xlim(xlimits);
    end
    hold off
    
    if iprint == 1
        if filename == ""
            filename = 'SingularValue';
            for i = 1:length(vecr)
                filename = strcat(filename, dataname{i}, num2str(vecr(i)));
            end
        end
        savestr = strcat(figdir, filename);        
        orient landscape
        print(fig, '-dpdf', savestr)
    end    
end