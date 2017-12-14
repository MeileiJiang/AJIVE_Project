%% load the data
clear
clc
disp('This shows the AJIVE analysis on the Mortality dataset!')
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
disp('Run AJIVE algorithm')
outstruct = AJIVEMainMJ(datablock, vecr, paramstruct);
disp('Press any key to continue!')
pause;
%% test Martiality AJIVE Output Visualization
MatrixJoint = outstruct.MatrixJoint;
MatrixIndiv = outstruct.MatrixIndiv;

%% get AJIVE output
MatrixJointMale = MatrixJoint{1};
MatrixJointFemale = MatrixJoint{2};
MatrixIndivMale = MatrixIndiv{1};

%% First Joint Component
disp('Visualizing the first joint components!')
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
disp('Press any key to continue!')
pause;
%% Second Joint Component
disp('Visualizing the second joint components!')
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
disp('Press any key to continue!')
pause;
%% Individual Component
disp('Visualizing the individual component in Male!')
paramstructMaleIC1 = struct('mat_name', 'Male IC1', ...
                            'iprint', 1, ...
                            'save_dir', 'Figures/', ...
                            'file_name', 'MaleIC1');
Mortality_AJIVE_Output_Visual(MatrixIndivMale, 1, 1, paramstructMaleIC1);
