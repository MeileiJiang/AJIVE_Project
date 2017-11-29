function row_joint = AJIVEJointSelectMJ(M, angleBound, vecr, threp, dataname, ...
    iplot, iprint, figname, figdir, ferror)
% function for selecting number of joint components of a set of datablocks
% use Wedin's perturbation bound
% Inputs:
%   datablock        - cells of data matrices {datablock 1, ..., datablock k}
%                    - Each data matrix is a d x n matrix that each row is
%   vecr             - a vector of selected ranks for each data matrix 
%   dataname         - cells of names for each datablock
%   threp            - Percentile of perturbation bounds used for deciding
%                      the joint rank; defaule is 50 i.e. median.  
%   iplot            - binary number to indicate whether to visualize the diagnositic graphics  
%   iprint           - binary number to indicate whether to save the diagnostic graphics
%   figname          - a cell of strings: names of two diagnostic graphics
%   figdir           - a directory to save the diagnostic graphics
%   ferror           - a small number add to singular value to avoid floating 
%                      error. The default value is 10^(-10).  
% Output:
%   row_joint        - estimate of joint row space 

%    Copyright (c) Meilei Jiang, Qing Feng, Jan Hannig & J. S. Marron 2017
    if ~exist('ferror', 'var')
        ferror = 10^(-10);
    end
    
    nb = length(vecr);
    n = size(M, 2); % number of samples


    % Apply SVD on concatenated row basis matrix

    [~,S_M,v_M]=svds(M, min(vecr));
    s_M = diag(S_M);
    v_M=v_M';

    % threshold based on Wedin Bound

    WedinSSVbds = max(sum(cosd(angleBound).^2, 1), 1);
    WedinSSVbd = prctile(WedinSSVbds, threp); 

    % random directon bound
    randSSVs = RandDirSSVMJ(n, vecr, 100);
    randSSVbd = prctile(randSSVs, 95);
    
    % use selected bound percentile for rank selection 
    if randSSVbd > prctile(WedinSSVbds, 5)
        disp('The Wedin bound is too loose that it is smaller than the random direction bound.')
        disp('This suggests reducing the input rank. Will use random direction bound instead.')
        rjoint = sum(s_M.^2 + ferror > randSSVbd);
    else
        rjoint = sum(s_M.^2 + ferror > WedinSSVbd);
    end


    row_joint = v_M(1:rjoint, :);
    disp(['Proposed Joint rank: ' num2str(rjoint)]);

    % make diagnostic plot 
    if iplot == 1
        % square singular value diagnostic plot
        DiagPlotSSVMJ(dataname, vecr, randSSVs, s_M, WedinSSVbds, 10, ...
            [1 nb], iprint, figdir, figname{1});
        % make principal angle diagnostic plot in the two block case
        if nb == 2
            WedinAnglebds = acosd(WedinSSVbds - 1);
            randAngles = acosd(randSSVs - 1);
            pangles = acosd(s_M.^2 - 1);
            DiagPlotAngleMJ(dataname, vecr, randAngles, pangles, WedinAnglebds, ...
                10,  iprint, figdir, figname{2})
        end
    end
end


