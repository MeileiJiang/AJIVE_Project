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
%                      visualizing AJIVE step 1 and step 2; 
%                      default is [0 1];
%
%    numcompshow       number of singular values to be ploted in the scree
%                      plot; default value is 100;
%
%    dataname          a cellarray of strings: name of each data block; default
%                      name is {'datablock1', ..., 'datablockk'}
%    nresample         number of re-samples in the AJIVE step 2 for
%                      estimating the perturbation bounds; default value is 1000;
%    threp             Percentile of perturbation bounds used for deciding
%                      the joint rank; default is 5. 
%    iprint            a vector indicating whether to save figures for
%                      visualizing AJIVE step 1 and step 2;
%                      default is [0 0];
%    figname2_1         a string: name of the SSV diagnostic plot in step 2
%    figname2_2         a string: name of the principal angle diagnostic
%                      plot in step 2
%    figdir            a directory to save figure.
%    ferror            a small number add to singular value to avoid float 
%                      error. The default value is 10^(-10).    
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
% 



% Assumes path can find personal functions:
%    AJIVEPreVisualMJ.m
%    AJIVEInitExtrctMJ.m
%    AJIVEJointSelectMJ.m
%    AJIVEReconstructMJ.m
%    JIVErandnullQF.m
%    DiagPlotSSVMJ.m
%    DiagPlotAngleMJ.m
%    SVDBoundWedinMJ.m
%    randorth.m
%    num2order.m
%    axisSM.m

%    Copyright (c)  Meilei Jiang, Qing Feng, Jan Hannig & J. S. Marron 2017


    nb = length(datablock); % number of blocks
    % check common number of samples
    d = zeros(1, nb);
    n = size(datablock{1}, 2);
    for ib = 1:nb
        d(nb) = size(datablock{ib}, 1);
        if size(datablock{ib}, 2) ~= n
            disp('Error Message: AJIVE terminated due to no common number of samples!')
            return;
        end
    end

    if nargin == 1
        disp('Error Message: AJIVE terminated due to no given rank estimates!')
        return;
    end

    % defaul value of parameters in paramstruct
    imean = zeros(1, nb);
    iplot = [0 1];
    numcompshow = 100;
    threp = 5;
    nresample = 1000;
    dataname = cell(1, nb);
    for ib = 1:nb
        dataname{ib} = ['datablock' num2str(ib)];
    end
    iprint = [0 0];
    figname2_1 = '';
    figname2_2 = '';
    figdir = '';
    ferror = 10^(-10);
    ioutput = [1, 1, 0, 0, 1, 1, 0, 0, 0];

    % If paramstruct has been added, then change to input value
    if exist('paramstruct', 'var')   

      if isfield(paramstruct,'imean')     
        imean = paramstruct.imean; 
      end 

      if isfield(paramstruct,'iplot')    
        iplot = paramstruct.iplot; 
      end 

      if isfield(paramstruct,'numcompshow')    
        numcompshow = paramstruct.numcompshow; 
      end 

      if isfield(paramstruct,'dataname')     
        dataname = paramstruct.dataname; 
      end 

      if isfield(paramstruct,'threp')    
        threp = paramstruct.threp; 
      end 

      if isfield(paramstruct,'nresample')   
        nresample = paramstruct.nresample; 
      end 
      
      if isfield(paramstruct,'iprint')   
        iprint = paramstruct.iprint; 
      end 
      
      if isfield(paramstruct,'figname2_1')
        figname2_1 = paramstruct.figname2_1; 
      end
      
      if isfield(paramstruct,'figname2_2')
        figname2_2 = paramstruct.figname2_2; 
      end
      
      if isfield(paramstruct,'ferror')
        ferror = paramstruct.ferror; 
      end
      
      if isfield(paramstruct,'ioutput')
        ioutput = paramstruct.ioutput; 
      end 

    end

    % mean center 
    for ib = 1:nb

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
        rankv = cell(1, nb);
        for ib = 1:nb
            rankv{ib} = vecr(ib); 
        end
        AJIVEPreVisualMJ(datablock, rankv, numcompshow, dataname, iprint(1), figdir);
    end

    % Step 1: Signal Space Initial Extraction 
    fprintf('Signal Space Initial Extraction ... \n')
    [M, angleBound, threshold] = AJIVEInitExtractMJ(datablock, vecr, nresample, dataname);

    % Step 2: Joint Score Space Estimation
    disp('Score Space Segmentation ...')
    row_joint_origin = AJIVEJointSelectMJ(M, angleBound, vecr, threp, dataname, ...
        iplot(2), iprint(2), {figname2_1, figname2_2}, figdir, ferror);

    % Step 3: Final Decomposition And Outputs 
    fprintf('Reconstruction of each type of signal ... \n')
    outstruct = AJIVEReconstructMJ(datablock, threshold, dataname, row_joint_origin, ioutput);
end


