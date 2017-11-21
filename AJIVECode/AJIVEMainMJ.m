function outstruct = AJIVEMainMJ(datablock, vecr, paramstruct)
% Main function for applying AJIVE to a set of data matrices
% Use 'AJIVEdecompVisualQF.m' for visualizing the decomposition 
%     Note: careful use of 'ioutput' is needed
%
% Inputs:
%   datablock        - cells of data matrices {datablock 1, ..., datablock k}
%                    - Each data matrix is a d x n matrix that each row is
%                    a feature and each column is a data object 
%                    - Matrices are required to have same number of objects
%                    i.e. 'n'. Number of features i.e. 'd' can be different
%
%   vecr             -  a vector of estimated signal ranks for each data block 
%                    A needed input where no default is provided; 
%                    recommend to use 'AJIVEPreVisualMJ.m' for selection
%
%   paramstruct      - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%                   paramstruct = struct('field1',values1,...
%                                        'field2',values2,...
%                                        'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%                    Version for easy copying and modification:
%                    paramstruct = struct('',, ...
%                                         '',, ...
%                                         '',) ;
%
%    fields            values
%    imean             a 1xk vector indicating centering for each data
%                      block e.g. [0 0 0 0] for a datablock cell containing 4 matrices 
%                      0: no centering (default), 1: centering by row  
%                      2: centering by column, 3: centering by the overall
%                      mean of the matrix
%
%    iplot             a vector indicating whether to generate figures for
%                      visualizing JIVE step 1 and step 2; 
%                      default is [0 0];
%
%    numcompshow       number of singular values to be ploted in the scree
%                      plot; default value is 100;
%
%    dataname          a cellarray of strings: name of each data block; default
%                      name is {'datablock1', ..., 'datablockk'}
%    nresample         number of re-samples in the AJIVE step 2 for
%                      estimating the perturbation bounds; default value is 1000;
%    boundp            Additional percentiles of interest in perturbation bounds; 
%                      default is []; [50 5 95] percentiles are always given; 
%    threp             Percentile of perturbation bounds used for deciding
%                      the joint rank; default is 50 i.e. median.  
%    ioutput           0-1 indicator vector of output's structure 
%                      [CNS,  
%                       CNSloading, 
%                       BSSjoint,
%                       BSSjointLoading, 
%                       BSSindiv, 
%                       BSSindivLoading,
%                       MatrixJoint,
%                       MatrixIndiv, 
%                       MatrixResid
%                       ]  
%                      default value is [1, 1, 0, 0, 1, 1, 0, 0, 0]. i.e
%                      report common normlized score and its loading (for
%                      joint signal) and block specific scores and its
%                      loading (for individual signal)
%                      
%    
% Outputs: 
%   outstruct
%   row_joint_origin
% 



% Assumes path can find personal functions:
%    JIVEJointSelectMJ.m
%    JIVEReconstructMJ.m
%    JIVErandnullQF.m
%    JIVEPreVisualMJ.m

%    Copyright (c)  Meilei Jiang, Qing Feng, Jan Hannig & J. S. Marron 2017


k = length(datablock);
% check common number of samples
d = [];
n = size(datablock{1}, 2);
for ib = 1:k
    d(k) = size(datablock{ib}, 1);
    if size(datablock{ib}, 2) ~= n
        disp('Error Message: AJIVE terminated due to no common number of samples!')
        return;
    end
end

if nargin == 1
    disp('Error Message: AJIVE terminated due to no given rank estimates!')
    return
end

% initialize
imean = zeros(1, k);
iplot = [0 0];
numcompshow = 100;
boundp = [];
threp = 50;
nresample = 1000;
dataname = cell(1, k);
for ib = 1:k
    dataname{ib} = ['datablock' num2str(ib)];
end
ioutput = [1, 1, 0, 0, 1, 1, 0, 0, 0];


if nargin > 2    %  then paramstruct has been added
  
  if isfield(paramstruct,'imean')     %  then change to input value
    imean = getfield(paramstruct,'imean') ; 
  end 

  if isfield(paramstruct,'iplot')    %  then change to input value
    iplot = getfield(paramstruct,'iplot') ; 
  end 
  
  if isfield(paramstruct,'numcompshow')    %  then change to input value
    numcompshow = getfield(paramstruct,'numcompshow') ; 
  end 
  
  if isfield(paramstruct,'dataname')     %  then change to input value
    dataname = getfield(paramstruct,'dataname') ; 
  end 

  if isfield(paramstruct,'boundp')     %  then change to input value
    boundp = getfield(paramstruct,'boundp') ; 
  end 
  
  if isfield(paramstruct,'threp')    %  then change to input value
    threp = getfield(paramstruct,'threp') ; 
  end 
  
  if isfield(paramstruct,'nresample')    %  then change to input value
    nresample = getfield(paramstruct,'nresample') ; 
  end 
  
  if isfield(paramstruct,'ioutput')    %  then change to input value
    ioutput = getfield(paramstruct,'ioutput') ; 
  end 
  
end

% mean center 
for ib = 1:k
    
    if imean(ib) == 1 % center by row 
        datablock{ib} = bsxfun(@minus,datablock{ib},mean(datablock{ib}')');
    elseif imean(ib) == 2 % center by column
        datablock{ib} = bsxfun(@minus,datablock{ib},mean(datablock{ib}));
    elseif imean(ib) == 3 % center by overmean
        datablock{ib} = bsxfun(@minus,datablock{ib},mean(datablock{ib}(:)));
    end

end

% visualize selected ranks for each data block
if iplot(1) == 1
    for ib = 1:k
        rankv{ib} = vecr(ib); 
    end
    AJIVEPreVisualMJ(datablock, rankv, numcompshow, dataname);
end

fprintf('Signal Space Initial Extraction ... \n')
threshold = [];

for ib = 1:k
    s = svd(datablock{ib});
    threshold(ib) = (s(vecr(ib))+s(vecr(ib)+1))/2; % threshold of singular values
end

% joint row space estimation
fprintf('Score Space Segmentation ... \n')
row_joint_origin = AJIVEJointSelectMJ(datablock, vecr, dataname, boundp, threp, nresample, iplot(2));

% reconstruction of each type of signal 
fprintf('Reconstruction of each type of signal ... \n')
outstruct = AJIVEReconstructMJ(datablock, threshold, dataname, row_joint_origin, ioutput);


