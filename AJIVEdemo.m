% script: AJIVE demo
clear
clc
% Toy data example 
load('Dataexample/ToyData.mat');
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
outstruct = AJIVEMainMJ(datablock, vecr);

% output matrices
paramstruct = struct('ioutput', [1, 1, 1, 1, 1, 1, 1, 1, 1]);
vecr = [2, 3];
outstruct = AJIVEMainMJ(datablock, vecr, paramstruct);

% visualize matrices
Xjoint = outstruct.MatrixJoint{1};
Xindiv = outstruct.MatrixIndiv{1};
AJIVEdecompVisualMJ(Xjoint, Xindiv)