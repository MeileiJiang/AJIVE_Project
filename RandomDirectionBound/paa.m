function s_union = paa(datablock, vecr)
% paa               Calculate the singluar values of union of row space basis 
%                   among low rank approximations of datablocks.
% Inputs:
%   datablock        - cells of data matrices {datablock 1, ..., datablock k}
%                    - Each data matrix is a d x n matrix that each row is
%                    a feature and each column is a data object
%                    - Matrices are required to have same number of objects
%                    i.e. 'n'. Number of features i.e. 'd' can be different
%
%   vecr             - a vector of estimated signal ranks for each data block 
%                    A needed input where no default is provided; 
%                    recommend to use 'AJIVEPreVisualMJ.m' for selection
% Outputs

nb = length(datablock);

% Step 1: low rank approximation of each data block
V = cell(nb, 1);
union = zeros(sum(vecr), size(datablock{1}, 2)); % stack of row space basis vectors

for ib = 1:nb
    [~, ~, V{ib}] = svds(datablock{ib}, vecr(ib));
    irow_start = sum(vecr(1 : (ib - 1))) + 1;
    irow_end = sum(vecr(1 : ib));    
    union(irow_start : irow_end, :) =  V{ib}';
end

% Step 2: calculate principal angles by svd of union

s_union = svds(union, min(vecr));
