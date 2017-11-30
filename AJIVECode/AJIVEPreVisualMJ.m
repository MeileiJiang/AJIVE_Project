function AJIVEPreVisualMJ(datablock, rank, numcompshow, dataname, ...
    iprint, figdir) 
% Visualization of AJIVE Step 1 rank selection
% Input: datablocks (cellarray) e.g. datablock{i} = genemat (d x n matrix)
%        rank: rank{i} = [] an cellarray of vectors of potential ranks for block i;
%              rank = {} generate scree plots only for each block 
%        numcompshow: numcompshow = min(numcompshow, min(d, n)) for each data block
%        dataname: name of each data block; used for saving plots
%   iprint          - 0: not generate figure in the figdir
%                   - 1: generate figure in the figdir
%   figdir          - diretory to save figure
 

% Output: graphics only 

%    Copyright (c) J. S. Marron, Jan Hannig, Qing Feng, & Meilei Jiang 


nb = length(datablock);

if nargin < 2
   disp('Note: only display scree plots!')
   for ib = 1:nb
       s = svd(datablock{ib});
       figure;
       plot(s,'marker','o', 'linewidth', 1, 'color','blue');
       xlabel('Component Index');
       ylabel('Singluar Value');
   end
   return;
end
    
if ~exist('numcompshow', 'var')
    numcompshow = 100;
end

if ~exist('dataname', 'var')
    dataname = cell(1,nb);
    for ib = 1:nb
        dataname{ib} = ['datablock' num2str(ib)];
    end
end

colormat = [1 0 0; ... % red
            0 1 0; ... % green 
            0 0 1; ... % blue
            0 0 0; ... % black
            1 1 0; ... % yellow
            1 0 1; ... % magenta 
            0 1 1]; % cyan
        
for ib = 1:nb
    s = svd(datablock{ib});
    rt = rank{ib};
    shows = min(numcompshow, length(s)); % number of singular values to be ploted 
    
    fig1 = figure;
    clf;
    subplot(1, 2, 1)
    plot(s(1:shows),'marker','o', 'linewidth', 1, 'color','blue');
    xlabel('Component Index');
    ylabel('Singluar Value');
    XL = get(gca,'XLim');
    hold on;
    for ir = 1:length(rt)
        icolorindex = mod(ir, 7);
        if icolorindex == 0
            line(XL, [(s(rt(ir)) + s(rt(ir)+1))/2 (s(rt(ir)) + s(rt(ir)+1))/2], 'linewidth', 1, 'linestyle', '--', 'color', colormat(7, :))
        else
            line(XL, [(s(rt(ir)) + s(rt(ir)+1))/2 (s(rt(ir)) + s(rt(ir)+1))/2], 'linewidth', 1, 'linestyle', '--', 'color', colormat(icolorindex, :))
        end
    end
    subplot(1, 2, 2);
    plot(diff(s(1:shows)),'marker','o', 'linewidth', 1, 'color','blue');
    xlabel('Component Index');
    ylabel('Difference between Adjacent Singluar Value');
    hold on;
    for ir = 1:length(rt)
        icolorindex = mod(ir, 7);
        if icolorindex == 0
            plot(rt(ir), s(rt(ir)+1)-s(rt(ir)), 'marker','o', 'MarkerFaceColor', colormat(7, :));
        else
            plot(rt(ir), s(rt(ir)+1)-s(rt(ir)), 'marker','o', 'MarkerFaceColor', colormat(icolorindex, :));
        end
    end
    
    axes('Units','Normal');
    h = title(['Singular Value Plot: ' dataname{ib}],'FontSize',14);
    set(gca,'visible','off')
    set(h,'visible','on')
    
    if exist('iprint', 'var') && iprint == 1
        if ~exist('figdir', 'var') || ~exist(figdir, 'dir')
            disp('No valid figure directory found! Will save to current folder.')
            figdir = '';
        end
        
        
        figname1_1 = strcat(dataname{ib}, 'AJIVEStep1ScreePlot');
        savestr1_1 = strcat(figdir, figname1_1);        
        try
            orient landscape
            print(fig1, '-deps', savestr1_1)
            disp('Save scree plot successfully!')
        catch
            disp('Fail to save scree plot!')
        end
    end    
   

    fig2 = figure;
    clf;
    subplot(1,2,1);
    plot(log10(s(1:shows)),'marker','o', 'linewidth', 1, 'color','blue');
    xlabel('Component Index');
    ylabel('Log_{10}(Singluar Value)');
    XL = get(gca,'XLim');
    hold on;
    for ir = 1:length(rt)
        icolorindex = mod(ir, 7);
        if icolorindex == 0
            line(XL, [log10((s(rt(ir)) + s(rt(ir)+1))/2) log10((s(rt(ir)) + s(rt(ir)+1))/2)], 'linewidth', 1, 'linestyle', '--', 'color', colormat(7, :))
        else
            line(XL, [log10((s(rt(ir)) + s(rt(ir)+1))/2) log10((s(rt(ir)) + s(rt(ir)+1))/2)], 'linewidth', 1, 'linestyle', '--', 'color', colormat(icolorindex, :))
        end
    end

    subplot(1, 2, 2)
    plot(diff(log10(s(1:shows))),'marker','o', 'linewidth', 1, 'color','blue');
    xlabel('Component Index');
    ylabel('Difference between Adjacent Log_{10}(Singluar Value)');
    hold on;
    for ir = 1:length(rt)
        icolorindex = mod(ir, 7);
        if icolorindex == 0
            plot(rt(ir), log10(s(rt(ir)+1))-log10(s(rt(ir))), 'marker','o', 'MarkerFaceColor', colormat(7, :));
        else
            plot(rt(ir), log10(s(rt(ir)+1))-log10(s(rt(ir))), 'marker','o', 'MarkerFaceColor', colormat(icolorindex, :));
        end
    end

    axes('Units','Normal');
    h = title(['Log_{10} of Singular Value Plot: ' dataname{ib}],'FontSize',14);
    set(gca,'visible','off')
    set(h,'visible','on')
    if exist('iprint', 'var') && iprint == 1
        if ~exist('figdir', 'var') || ~exist(figdir, 'dir')
            disp('No valid figure directory found! Will save to current folder.')
            figdir = '';
        end
        
        figname1_2 = strcat(dataname{ib}, 'AJIVEStep1LogScreePlot');
        savestr1_2 = strcat(figdir, figname1_2);        
        try
            orient landscape
            print(fig2, '-depsc', savestr1_2)
            disp('Save log scree plot successfully!')
        catch
            disp('Fail to save log scree plot!')
        end
    end    

end