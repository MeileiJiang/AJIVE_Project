function Mortality_AJIVE_Output_Visual(mat, mat_rank, icomp, paramstruct)
%Mortality_AJIVE_Output_Visual This function generates a four panel figure 
% for AJIVE output component visualization over Mortality dataset. The upper 
% left panel shows rows as curves. The upper right panel makes the loading
% plot. The lower left panel shows the columns as curves. The lower right
% panel shows the scores plot.
%   Input Arguments:
%       mat - A matrix representation of AJIVE Output component.
%       mat_rank - A integer represents the rank of mat.
%       icomp - Index of principal component in mat.
%       paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%                   paramstruct = struct('field1',values1,...
%                                        'field2',values2,...
%                                        'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%                   filds        values
%                   mat_name     a string of mat name 
%                   iprint       a index of whether print the figure to the
%                   local directory
%                   save_dir     a directory to save figure
%                   file_name    a string of file name
%
%   Output Arguments:
%       Only figure will be generated and save at local directory.
%
%       Copyright (c) Meilei Jiang, Qing Feng 2017

% set up
    if ~exist('mat', 'var')
        disp('Error message: No matrix input found!')
        return;
    end

    if ~exist('mat_rank', 'var')
        mat_rank = rank(mat);
    end

    if ~exist('icomp', 'var')
        disp('Error message: No input of the index of principal component found!')
        disp('Show the 1st principal component')
        icomp = 1;
    end

    mat_name = 'matrix';
    save_dir = '';
    iprint = 0;
    file_name = strcat(mat_name, '_visual');

    if exist('paramstruct', 'var')
        if isfield(paramstruct, 'mat_name')
            mat_name = paramstruct.mat_name;
        end
        if isfield(paramstruct, 'iprint')
            iprint = paramstruct.iprint;
        end
        if isfield(paramstruct, 'save_dir')
            save_dir = paramstruct.save_dir;
        end
        if isfield(paramstruct, 'file_name')
            file_name = paramstruct.file_name;
        end
    end



    d = size(mat, 1);
    n = size(mat, 2);

    % get the scores and loadings

    [rmsigcol, rvsigval, rmsigrow] = svds(mat, mat_rank);

    % make figure
    figure;
    % col color setup
    icolorcol = colormap(hot(d))  ;  
    colmapcol = icolorcol  ;

    % row color setup
    nfifth = ceil((n - 1) / 5) ;
    del = 1 / nfifth ;
    vwt = (0:del:1)' ;
    colmaprow = [flipud(vwt), zeros(nfifth+1,1), ones(nfifth+1,1)] ;
    colmaprow = colmaprow(1:size(colmaprow,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmaprow = [colmaprow; ...
              [zeros(nfifth+1,1), vwt, ones(nfifth+1,1)]] ;
    colmaprow = colmaprow(1:size(colmaprow,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmaprow = [colmaprow; ...
              [zeros(nfifth+1,1), ones(nfifth+1,1), flipud(vwt)]] ;
    colmaprow = colmaprow(1:size(colmaprow,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmaprow = [colmaprow; ...
              [vwt, ones(nfifth+1,1), zeros(nfifth+1,1)]] ;
    colmaprow = colmaprow(1:size(colmaprow,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmaprow = [colmaprow; ...
              [ones(nfifth+1,1)], flipud(vwt), zeros(nfifth+1,1)] ;

    rmpc = (rvsigval * rmsigrow')';
                %  projection of centered residuals, 
                %  in original data space
                %  onto direction vectors (scores)

    ra3proj= rvsigval(1,1) * rmsigcol(:,1) * rmsigrow(:,1)';

    for ipc = 1:mat_rank    %  loop through eigenvectors

      vpc = rmsigrow(:,ipc) ;
          %  vector of right singular vectors (scores)

      if sum(vpc) < 0     %  then flip this eigenvector and the projections
        rmsigcol(:,ipc) = -rmsigcol(:,ipc) ;
        rmsigrow(:,ipc) = -rmsigrow(:,ipc) ;
        rmpc(:,ipc) = -rmpc(:,ipc) ;
      end 

    end 

    % plot each direction
    xgridcol = (1:d)';
    xgridrow = 1907+(1:n)'; 


    ax = subplot (2, 2, 1);
    position = ax.Position ;
    % reset the axes         
    position(2) = position(2) + 0.005 * 2 ;
    position(4) = position(4)  - 0.005  * 2 ;
    set(ax, 'Position', position);

    % Add the plot
    plot(xgridrow, ra3proj(1,:),'-','Color',colmapcol(1,:)) ;
    hold on ;
    for idat = 2:d 
        plot(xgridrow, ra3proj(idat, :),'-','Color',colmapcol(idat,:)) ;
    end               

    vax = axisSM(ra3proj(:,:)');     
    axis([1908, 1907+n, vax]);
    % Add title for subplot
    title_str1 = strcat(['Rows as Curves in ', mat_name]);
    title(title_str1, 'fontsize', 12);

    % Plot the colorbar showing the color scheme
    position(2) = position(2) - 0.005*2;
    position(4) = 0.005*2 ;
    axes('Position', position);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []) ;
    YLim = get(gca, 'YLim') ;
    XLim = get(gca, 'XLim') ;
    % number of color
    width = (XLim(2)-XLim(1))/size(colmaprow,1);
    linewidth = 1.9;

    % plot colorbar 
    for idat = 1: size(colmaprow, 1)
        line([XLim(1)+(idat-1)*width XLim(1)+(idat-1)*width], YLim, 'color', colmaprow(idat, :), 'linewidth', linewidth);
        hold on;
    end

    subplot (2,2,2);
    vax = axisSM(rmsigcol(:, icomp)');

    title_str2 = strcat([mat_name, ' Loadings Plot']);
    paramstruct1 = struct('icolor', icolorcol, ...
                                    'markerstr', 'o', ...
                                    'ibigdot',0, ...
                                    'isubpopkde',0, ...
                                    'idatovlay', 1, ...
                                    'datovlaymin', 0.4,...
                                     'datovlaymax', 0.6,...
                                    'vaxlim', vax, ...
                                    'titlestr', title_str2, ...
                                    'titlefontsize', 12, ... ,
                                    'iscreenwrite', 0) ;
    vdir = 1;
    projplot1SM(rmsigcol(:, icomp)',vdir,paramstruct1);


    ax = subplot (2, 2, 3);
    position = ax.Position ; 
    % reset the axes 
    position(1) = position(1) + 0.005*2 ;
    position(3) = position(3) - 0.005*2 ;
    set(ax, 'Position', position);

    % Add plot on resized canvas
    plot(xgridcol, ra3proj(:,1), '-', 'Color', colmaprow(1,:));
    hold on;
    for idat = 2:n 
        plot(xgridcol, ra3proj(:, idat),'-','Color',colmaprow(idat,:));
    end                  
    vax = axisSM(ra3proj(:,:));
    axis([1,d,vax]);
    view([90 90]);
    % Add title
    title_str3 = strcat(['Columns as Curves in ', mat_name]);
    title(title_str3, 'fontsize', 12);


    % Plot the colorbar showing the color scheme
    position(1) = position(1) - 0.005*2 ;
    position(3) = 0.005*2 ;
    axes('Position', position);
    % remove X-axis
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    YLim = get(gca, 'YLim');
    XLim = get(gca, 'XLim');
    % number of color
    width = (YLim(2)-YLim(1))/size(colmapcol,1);
    linewidth = 1.9;

    % plot the colorbar
    for idat = 1: size(colmapcol, 1)
        line(XLim,[YLim(2)-(idat-1)*width YLim(2)-(idat-1)*width], 'color', colmapcol(idat, :), 'linewidth', linewidth);
        hold on ;
    end

    subplot(2, 2, 4);
    vax = axisSM(rmsigrow(:, icomp));
    title_str4 = strcat([mat_name, ' Scores Plot']);
    paramstruct2 = struct('icolor', 2, ...
                          'markerstr', 'o', ...
                          'ibigdot',0, ...
                          'isubpopkde',0, ...
                          'idatovlay', 1, ...
                          'datovlaymin', 0.4,...
                          'datovlaymax', 0.6,...
                          'vaxlim', vax, ...
                          'titlestr', title_str4, ...
                          'titlefontsize', 12, ... 
                          'iscreenwrite', 0);
    vdir = 1;
    projplot1SM(rmsigrow(:, icomp)',vdir,paramstruct2) ;

    %% save the plot
    if iprint == 1
        try
            print('-depsc', strcat(save_dir, file_name));
            disp('Save figure successfully!')
        catch
            disp('Error Message: fail to save the figure! Check directory!')
        end
        
    end
end

