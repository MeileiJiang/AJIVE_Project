function scorePlot1d(scoreMat, numcomp, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)
%scorePlot1d Make 1d score plot with density estimation with samples group
%by datasubtype
%   Inputs:
%       scoreMat - a p x n score matrix
%       datasubtype - a n x 1 array of string representing subtype of each
%                     sample
%       subtypeKey - a 1 x nl array of string representing the key value of
%                    subtype in datasubtype
%       markerValue - a 1 x nl array of string representing corresponding
%                     mareker value in the subtypeKey
%       colorValue - a 1 x nl array of 1 x 3 vector representing RGB triplet
%       labelcellstr - cell array of strings for legend (nl of them),
%                      useful for (colored) classes, create this using
%                      cellstr, or {{string1 string2 ...}}
%       iprint - a 0-1 index of whether print the figure
%       savedir - a directory to save the file
%       figname - a string of file name
%   Outputs:
%       Graphics only.
%   Assumes path can find personal functions:
%       projplot1SM.m
%       axisSM.m
%       bwsjpiSM.m
%       kdeSM.m
%       lbinrSM.m
%       vec2matSM.m
%       bwrfphSM.m
%       bwosSM.m
%       rootfSM
%       vec2matSM.m
%       bwrotSM.m
%       bwsnrSM.m
%       iqrSM.m
%       cquantSM.m
%   Copyright (c) Meilei Jiang

    nsample = size(datasubtype, 1);
    markerMap = containers.Map(subtypeKey, markerValue);
    colorMap = containers.Map(subtypeKey, colorValue);

    markerstr = blanks(nsample)';
    icolorsub = zeros(nsample, 3);
    for i = 1:nsample
        markerstr(i) = markerMap(datasubtype{i});
        icolorsub(i, :) = colorMap(datasubtype{i});
    end

    legendcellstr = {subtypeKey};
    mlegendcolor = zeros(length(subtypeKey), 3);
    for i = 1:length(subtypeKey)
        mlegendcolor(i, :) = colorValue{i};
    end
        
    figure;
    paramstruct = struct('icolor',icolorsub, ...
        'markerstr',markerstr, ...
        'legendcellstr',legendcellstr, ...
        'mlegendcolor',mlegendcolor, ...
        'npcadiradd',0, ...
        'isubpopkde',1, ...
        'labelcellstr',labelcellstr) ;
    projplot1SM(scoreMat(numcomp, :), 1, paramstruct) ; % lumA (pos) - other (neg)
    if iprint == 1
        if nargin < 9
            disp('No savedir is provided. Will save to current folder')
            savestr = 'ScorePlot';
        else
            savestr = strcat(savedir, figname);
        end
        try
            orient portrait;            
            print('-deps', savestr) ;
            disp('Make plot successfully!')
        catch
            disp('Fail to generate plot!')
        end
        
    end

end

