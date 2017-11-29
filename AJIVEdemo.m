% script: AJIVE demo
clear
clc
% Toy data example 
load('DataExample/toydata.mat');
addpath 'AJIVECode/'
% orgainze data matrices into cell struct
datablock{1} = X;
datablock{2} = Y; 
% plot scree plot 
AJIVEPreVisualMJ(datablock);
% try rank 
rank{1} = [1 2 10];
rank{2} = [2 3];
AJIVEPreVisualMJ(datablock,rank);
% try rank 
rank{1} = 2;
rank{2} = 2:12;
AJIVEPreVisualMJ(datablock, rank); 

% select rank as vecr = [2, 3]
vecr = [2, 3];
dataname = {'X', 'Y'};
paramstruct0 = struct('dataname', {dataname}, ...
                      'iplot', [0 0]);
tic
outstruct0 = AJIVEMainMJ(datablock, vecr, paramstruct0);
toc
% output matrices
paramstruct = struct('ioutput', [1, 1, 1, 1, 1, 1, 1, 1, 1], ...
                     'dataname', {dataname}, ...
                     'iplot', [1 1]);
vecr = [2, 3];
outstruct = AJIVEMainMJ(datablock, vecr, paramstruct);
% visualize outputs
Xjoint = outstruct.MatrixJoint{1};
Xindiv = outstruct.MatrixIndiv{1};
AJIVEdecompVisualMJ(Xjoint, Xindiv)

Yjoint = outstruct.MatrixJoint{2};
Yindiv = outstruct.MatrixIndiv{2};
AJIVEdecompVisualMJ(Yjoint, Yindiv);