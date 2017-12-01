function row_joint = AJIVEJointSelectMJ(M, angleBound, vecr, threp, rj, dataname, ...
    iplot, iprint, figname, figdir, ferror)
% function for selecting number of joint components of a set of datablocks
% use Wedin's perturbation bound
% Inputs:
%   datablock        - cells of data matrices {datablock 1, ..., datablock k}
%                    - Each data matrix is a d x n matrix that each row is
%   vecr             - a vector of selected ranks for each data matrix 
%   dataname         - cells of names for each datablock
%   rj               - manually input the joint rank. Default is -1, which indicates no joint rank input. 
%   threp            - Percentile of perturbation bounds used for deciding
%                      the joint rank; defaule is 50 i.e. median. 
%
%   iplot            - binary number to indicate whether to visualize the diagnositic graphics  
%   iprint           - binary number to indicate whether to save the diagnostic graphics
%   figname          - a cell of strings: names of two diagnostic graphics
%   figdir           - a directory to save the diagnostic graphics
%   ferror           - a small number add to singular value to avoid floating 
%                      error. The default value is 10^(-10).  
% Output:
%   row_joint        - estimate of joint row space 

%    Copyright (c) Meilei Jiang, Qing Feng, Jan Hannig & J. S. Marron 2017

    if ~exist('rj', 'var')
        rj = -1;
    end
    if ~exist('ferror', 'var')
        ferror = 10^(-10);
    end
    
    nb = length(vecr);
    n = size(M, 2); % number of samples


    % Apply SVD on concatenated row basis matrix

    [~,S_M,V_M]=svds(M, min(vecr));
    s_M = diag(S_M);

    % threshold based on Wedin Bound

    WedinSSVbds = max(sum(cosd(angleBound).^2, 1), 1);
    WedinSSVbd = prctile(WedinSSVbds, threp); 

    % random directon bound
    randSSVs = RandDirSSVMJ(n, vecr, 100);
    randSSVbd = prctile(randSSVs, 95);
    
    % use selected bound percentile for rank selection 
    if rj == -1
        if randSSVbd > prctile(WedinSSVbds, 5)
        disp('The Wedin bound is too loose that it is smaller than the random direction bound.')
        disp('This suggests reducing the input rank. Will use random direction bound instead.')
        rjoint = sum(s_M.^2 + ferror > randSSVbd);
        else
            rjoint = sum(s_M.^2 + ferror > WedinSSVbd);
        end
    else
        rjoint = rj;
    end
    


    row_joint = V_M(:, 1:rjoint)';
    disp(['Proposed Joint rank: ' num2str(rjoint)]);

    % make diagnostic plot 
    if iplot == 1
        % square singular value diagnostic plot
        ssv_hard_cut = -1;
        if exist('rj', 'var') && rj >= 0
            if rj == 0
                ssv_hard_cut = (nb + s_M(1)^2)/2;
            elseif rj >= length(s_M)
                if randSSVbd < WedinSSVbd
                    ssv_hard_cut = (randSSVbd + s_M(end)^2)/2;
                else
                    ssv_hard_cut = (1 + s_M(end)^2)/2;
                end
            else
                ssv_hard_cut = (s_M(rj)^2 + s_M(rj + 1)^2)/2;
            end
        
        end
        DiagPlotSSVMJ(dataname, vecr, randSSVs, s_M, WedinSSVbds, 10, ...
            [1 nb], iprint, figdir, figname{1}, ssv_hard_cut);
        % make principal angle diagnostic plot in the two block case
        if nb == 2
            WedinAnglebds = acosd(min(WedinSSVbds - 1, 1));
            randAngles = acosd(min(randSSVs - 1, 1));
            pangles = acosd(min(s_M.^2 - 1, 1));
            angle_hard_cut = -1;
            if ssv_hard_cut >= 0
                angle_hard_cut = acosd(min(ssv_hard_cut - 1, 1));
            end
            DiagPlotAngleMJ(dataname, vecr, randAngles, pangles, WedinAnglebds, ...
                10,  iprint, figdir, figname{2}, angle_hard_cut)
        end
    end
end


