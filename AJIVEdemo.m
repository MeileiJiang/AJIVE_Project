% script: AJIVE demo
clear
clc
disp('This is a demostration of applying AJIVE algorithm on the toy dataset in Feng et al. (2017) !')
%% Toy data example 
load('DataExample/toydata.mat');
addpath 'AJIVECode/'
% orgainze data matrices into cell struct
datablock{1} = X;
datablock{2} = Y; 
dataname = {'X', 'Y'};
%% Heatmap of toy data example
disp('Show heatmap of X')
HeatmapVisualQF(X, dataname{1})
disp('Press any key to continue!')
pause;

disp('Show heatmap of Y')
HeatmapVisualQF(Y, dataname{2})
disp('Press any key to continue!')
pause;

%% plot scree plot 
disp('Show scree plot of the toy dataset!')
AJIVEPreVisualMJ(datablock);
disp('Press any key to continue!')
pause;
%% try rank
disp('Show scree plot along with the initial rank choices!')
rank{1} = [1 2 10];
rank{2} = [2 3];
AJIVEPreVisualMJ(datablock,rank, dataname);
disp('Press any key to continue!')
pause;


%% select rank as vecr = [2, 3]
disp('Test AJIVE algorithm on the toy dataset!')
vecr = [2, 3];

paramstruct0 = struct('dataname', {dataname}, ...
                      'iplot', [0 0]);
tic
outstruct0 = AJIVEMainMJ(datablock, vecr, paramstruct0);
toc

disp('Press any key to continue!')
pause;
%% save diagnostic plots and visualize outputs.
disp('Run AJIVE algorithm with diagnostic plot!')
paramstruct = struct('ioutput', [1, 1, 1, 1, 1, 1, 1, 1, 1], ...
                     'dataname', {dataname}, ...
                     'iplot', [1 1], ...
                     'iprint', [1 1], ...
                     'figdir', 'Figures/');
outstruct = AJIVEMainMJ(datablock, vecr, paramstruct);
disp('Press any key to continue!')
pause;
% visualize outputs
disp('Visualizing AJIVE outputs!')
Xjoint = outstruct.MatrixJoint{1};
Xindiv = outstruct.MatrixIndiv{1};
AJIVEdecompVisualMJ(Xjoint, Xindiv)

Yjoint = outstruct.MatrixJoint{2};
Yindiv = outstruct.MatrixIndiv{2};
AJIVEdecompVisualMJ(Yjoint, Yindiv);
disp('Press any key to continue!')
pause;
%% manually specified joint ranks.
disp('Manually specified joint ranks to be 2 in AJIVE algorithm')
paramstruct1 = struct('ioutput', [1, 1, 1, 1, 1, 1, 1, 1, 1], ...
                     'dataname', {dataname}, ...
                     'iplot', [0 1], ...
                     'rj', 2);
outstruct1 = AJIVEMainMJ(datablock, vecr, paramstruct1);
disp('Press any key to continue!')
pause;
disp('Visualizing AJIVE outputs!')

Xjoint = outstruct1.MatrixJoint{1};
Xindiv = outstruct1.MatrixIndiv{1};
AJIVEdecompVisualMJ(Xjoint, Xindiv)

Yjoint = outstruct1.MatrixJoint{2};
Yindiv = outstruct1.MatrixIndiv{2};
AJIVEdecompVisualMJ(Yjoint, Yindiv);
disp('Press any key to continue!')
pause;



