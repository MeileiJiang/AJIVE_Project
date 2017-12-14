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
disp('Run AJIVE algorithm over GE, CN, RPPA, and Mut four datablocks!')
tic
outstruct = AJIVEMainMJ(datablock, vecr, paramstruct);
toc
disp('Press any key to continue!')
pause;
%% score analysis: GE - CN - Rppa - Mut
disp('Visualizing the scores of the first joint component among four data block!')
subtypeKey = {'LumA', 'LumB', 'Her2', 'Basal'};
markerValue = {'+', 'x', '*', '<'};
colorValue = {[1 0 0], [1 0 1], [0 1 1], [0 0 1]};
labelcellstr = {{'CNS 1'}};
iprint = 1;
savedir = 'Figures/';
figname = 'TCGA_CNS1';
scorePlot1d(-outstruct.CNS, 1, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)
disp('Press any key to continue!')
pause;
%% AJIVE analysis: GE - CN - Rppa
disp('Run AJIVE algorithm over GE, CN and Rppa data blocks with first joint component among four datablocks removed!')
datablock0 = {outstruct.MatrixIndiv{1} + outstruct.MatrixResid{1}, ...
              outstruct.MatrixIndiv{2} + outstruct.MatrixResid{2}, ...
              outstruct.MatrixIndiv{3} + outstruct.MatrixResid{3}};
paramstruct0 = struct('iplot', iplot, ...
                      'dataname', {dataname(1:3)}, ...
                      'threp', threp, ...
                      'ioutput', ioutput);
vecr0 = [19 16 14];

outstruct0 = AJIVEMainMJ(datablock0, vecr0, paramstruct0);
disp('Press any key to continue!')
pause;
%% %% score analysis: GE - CN - Rppa

iprint = 1;
savedir = 'Figures/';
disp('Visulizing the scores of the second joint component among the three datablocks!')
labelcellstr = {{'CNS 2'}};
figname = 'TCGA_CNS2';
scorePlot1d(outstruct0.CNS, 1, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)
disp('Press any key to continue!')
pause;

disp('Visulizing the scores of the third joint component among the three datablocks!')
labelcellstr = {{'CNS 3'}};
figname = 'TCGA_CNS3';
scorePlot1d(outstruct0.CNS, 2, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)
disp('Press any key to continue!')
pause;

disp('Visulizing the scores of the fourth joint component among the three datablocks!')
labelcellstr = {{'CNS 4'}};
figname = 'TCGA_CNS4';
scorePlot1d(outstruct0.CNS, 3, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)

disp('Press any key to continue!')
pause;