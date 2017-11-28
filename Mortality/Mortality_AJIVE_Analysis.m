%% load the data
clear
clc
load ../DataExample/mortality.mat
addpath ../AJIVECode/   

%% Setting up
vecr = [3, 2];
datablock = {X, Y};
dataname = {'Male', 'Female'};
paramstruct = struct('ioutput', [1, 1, 1, 1, 1, 1, 1, 1, 1], ...
                     'dataname', {dataname}, ...
                     'threp', 5);
%% AJIVE algorithm
outstruct = AJIVEMainMJ(datablock, vecr, paramstruct);

%% test Martiality AJIVE Output Visualization
MatrixJoint = outstruct.MatrixJoint;
MatrixIndiv = outstruct.MatrixIndiv;

%% get AJIVE output
MatrixJointMale = MatrixJoint{1};
MatrixJointFemale = MatrixJoint{2};
MatrixIndivMale = MatrixIndiv{1};

%% First Joint Component
paramstructMaleJC1 = struct('mat_name', 'Male JC1', ...
                            'iprint', 1, ...
                            'save_dir', 'Figures/', ...
                            'file_name', 'MaleJC1');
Mortality_AJIVE_Output_Visual(MatrixJointMale, 2, 1, paramstructMaleJC1);

paramstructFemaleJC1 = struct('mat_name', 'Female JC1', ...
                            'iprint', 1, ...
                            'save_dir', 'Figures/', ...
                            'file_name', 'FemaleJC1');
Mortality_AJIVE_Output_Visual(MatrixJointFemale, 2, 1, paramstructFemaleJC1);

%% Second Joint Component
paramstructMaleJC2 = struct('mat_name', 'Male JC2', ...
                            'iprint', 1, ...
                            'save_dir', 'Figures/', ...
                            'file_name', 'MaleJC2');
Mortality_AJIVE_Output_Visual(MatrixJointMale, 2, 2, paramstructMaleJC2);

paramstructFemaleJC2 = struct('mat_name', 'Female JC2', ...
                            'iprint', 1, ...
                            'save_dir', 'Figures/', ...
                            'file_name', 'FemaleJC2');
Mortality_AJIVE_Output_Visual(MatrixJointFemale, 2, 2, paramstructFemaleJC2);

%% Individual Component
paramstructMaleIC1 = struct('mat_name', 'Male IC1', ...
                            'iprint', 1, ...
                            'save_dir', 'Figures/', ...
                            'file_name', 'MaleIC1');
Mortality_AJIVE_Output_Visual(MatrixIndivMale, 1, 1, paramstructMaleIC1);
