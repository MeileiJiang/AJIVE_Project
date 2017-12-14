clear
clc
addpath ../AJIVECode/
load ../DataExample/TCGA.mat

%% AJIVE set up
ioutput = [1, 1, 1, 1, 1, 1, 1, 1, 1];
iplot = [0 1];
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
labelcellstr = {{'CNS 4-1'}};
iprint = 1;
savedir = 'Figures/';
figname = 'TCGA_CNS4_1';
scorePlot1d(-outstruct.CNS, 1, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)
disp('Press any key to continue!')
pause;
%% AJIVE analysis: GE - CN - Rppa
disp('Run AJIVE algorithm over GE, CN and Rppa data blocks with joint matrices above removed!')
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
disp('Visulizing the common normalized scores of first joint component among the three datablocks!')
labelcellstr = {{'CNS 3-1'}};
figname = 'TCGA_CNS3_1';
scorePlot1d(outstruct0.CNS, 1, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)
disp('Press any key to continue!')
pause;


%% score analysis: GE - CN - ppa
disp('Visualizing the common normalized scores of all joint components among the three data blocks!')
labelcellstr = {{'CNS 3-1'; 'CNS 3-2'; 'CNS 3-3'}};
figname = 'TCGA_CNS3';
scorePlot2d(outstruct0.CNS, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)
disp('Press any key to continue!')
pause;

disp('Visualizing the common normalized scores of all four joint components among the orignal three data blocks!')
CNS = [outstruct.CNS; outstruct0.CNS];
labelcellstr = {{'CNS 4-1'; 'CNS 3-1'; 'CNS 3-2'; 'CNS 3-3'}};
figname = 'TCGA_CNS4';
scorePlot2d(CNS, datasubtype, subtypeKey, markerValue, ...
    colorValue, labelcellstr, iprint, savedir, figname)


