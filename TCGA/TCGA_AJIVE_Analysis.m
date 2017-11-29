clear
clc
addpath ../AJIVECode/
load ../DataExample/TCGA.mat

%% AJIVE set up
ioutput = [1, 1, 1, 1, 1, 1, 1, 1, 1];
iplot = [0 0];
threp = 5;
paramstruct = struct('iplot', iplot, ...
                     'dataname', {dataname}, ...
                     'threp', threp, ...
                     'ioutput', ioutput);
vecr = [20 16 15 27];

%% Run AJIVE
tic
outstruct = AJIVEMainMJ(datablock, vecr, paramstruct);
toc
%% score analysis: GE - CN - Rppa - Mut
subtypeKey = {'LumA', 'LumB', 'Her2', 'Basal'};
markerValue = {'+', 'x', '*', '<'};
colorValue = {[1 0 0], [1 0 1], [0 1 1], [0 0 1]};
labelcellstr = {{'CNS 1'}};
iprint = 1;
savedir = 'Figures/';
figname = 'TCGA_CNS1';
delete(strcat(savedir, figname))
scorePlot1d(-outstruct.CNS, 1, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)

%% AJIVE analysis: GE - CN - Rppa
datablock0 = {outstruct.MatrixIndiv{1} + outstruct.MatrixResid{1}, ...
              outstruct.MatrixIndiv{2} + outstruct.MatrixResid{2}, ...
              outstruct.MatrixIndiv{3} + outstruct.MatrixResid{3}};
paramstruct0 = struct('iplot', iplot, ...
                      'dataname', {dataname(1:3)}, ...
                      'threp', threp, ...
                      'ioutput', ioutput);
vecr0 = [19 16 14];

outstruct0 = AJIVEMainMJ(datablock0, vecr0, paramstruct0);

%% %% score analysis: GE - CN - Rppa

iprint = 1;
savedir = 'Figures/';

labelcellstr = {{'CNS 2'}};
figname = 'TCGA_CNS2';
delete(strcat(savedir, figname))
scorePlot1d(outstruct0.CNS, 1, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)

labelcellstr = {{'CNS 3'}};
figname = 'TCGA_CNS3';
delete(strcat(savedir, figname))
scorePlot1d(outstruct0.CNS, 2, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)

labelcellstr = {{'CNS 4'}};
figname = 'TCGA_CNS4';
delete(strcat(savedir, figname))
scorePlot1d(outstruct0.CNS, 3, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)

