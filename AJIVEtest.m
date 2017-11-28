function AJIVEtest(itest, data_dir, func_path)
%    FOR DEVELOPMENT AND TESTING OF AJIVE MATLAB FUNCTIONS
%    This function can run independently
%    Inputs:
%       itest       - test case number for different test cases.
%                     Test Main Program:
%                     itest = 1 % test no ranks input
%                           = 2,3,4 % test small rank input
%                           = 5 % test good rank input
%                           = 6,7,8,9 % test big rank input
%                           = 10,11,12 % mean subtraction
%                           = 13,14,15,16,17,18,19 % test iplot, boundp, threp
%                     Test Initial SVD Code
%                     itest = 101,102,103,104,105
%       data_dir    - a directory of input dataset.
%       func_path   - a path of AJIVECode.
%   Outputs:
%       Graphics only.




    if ~exist('data_dir', 'var')
        data_dir = 'DataExample/ToyData.mat';
    end

    if ~exist('func_path', 'var')
        func_path = 'AJIVECode/';
    end

    try
        load(data_dir);
    catch
        disp('Fail to load the data!')
        return;
    end
    try
        addpath(func_path);
    catch
        disp('Fail to AJIVE code addpath!')
        return;
    end


    if itest == 1 

      disp('Test Main Program, no ranks input') ;
      AJIVEMainMJ({X,Y})

    elseif itest == 2 

      disp('Test Main Program, small ranks input, 2 & 1') ;
      outstruct = AJIVEMainMJ({X,Y},[2 1]) 

    elseif itest == 3 

      disp('Test Main Program, small ranks input, 1 & 2') ;
      paramstruct = struct('ioutput',[0 0 0 0 0 0 1 1 0]) ;
      outstruct = AJIVEMainMJ({X,Y},[1; 2],paramstruct)
      Xj = outstruct.MatrixJoint{1} ;
      Xi = outstruct.MatrixIndiv{1} ;
      Yj = outstruct.MatrixJoint{2} ;
      Yi = outstruct.MatrixIndiv{2} ;
      AJIVEdecompVisualMJ(Xj,Xi,'X') ;
      AJIVEdecompVisualMJ(Yj,Yi,'Y') ;

    elseif itest == 4 

      disp('Test Main Program, small ranks input, 2 & 2') ;
      paramstruct = struct('ioutput',[0 0 0 0 0 0 1 1 0]) ;
      outstruct = AJIVEMainMJ({X,Y},[2; 2],paramstruct)
      Xj = outstruct.MatrixJoint{1} ;
      Xi = outstruct.MatrixIndiv{1} ;
      Yj = outstruct.MatrixJoint{2} ;
      Yi = outstruct.MatrixIndiv{2} ;
      AJIVEdecompVisualMJ(Xj,Xi,'X') ;
      AJIVEdecompVisualMJ(Yj,Yi,'Y') ;

    elseif itest == 5 

      disp('Test Main Program, good ranks input, 2 & 3') ;
      paramstruct = struct('ioutput',[0 0 0 0 0 0 1 1 0]) ;
      outstruct = AJIVEMainMJ({X,Y},[2; 3],paramstruct)
      Xj = outstruct.MatrixJoint{1} ;
      Xi = outstruct.MatrixIndiv{1} ;
      Yj = outstruct.MatrixJoint{2} ;
      Yi = outstruct.MatrixIndiv{2} ;
      AJIVEdecompVisualMJ(Xj,Xi,'X') ;
      AJIVEdecompVisualMJ(Yj,Yi,'Y') ;

    elseif itest == 6 

      disp('Test Main Program, ranks input, 3 & 3') ;
      paramstruct = struct('ioutput',[0 0 0 0 0 0 1 1 0]) ;
      outstruct = AJIVEMainMJ({X,Y},[3; 3],paramstruct)
      Xj = outstruct.MatrixJoint{1} ;
      Xi = outstruct.MatrixIndiv{1} ;
      Yj = outstruct.MatrixJoint{2} ;
      Yi = outstruct.MatrixIndiv{2} ;
      AJIVEdecompVisualMJ(Xj,Xi,'X') ;
      AJIVEdecompVisualMJ(Yj,Yi,'Y') ;

    elseif itest == 7 

      disp('Test Main Program, big ranks input, 4 & 5') ;
      paramstruct = struct('ioutput',[0 0 0 0 0 0 1 1 0]) ;
      outstruct = AJIVEMainMJ({X,Y},[4; 5],paramstruct)
      Xj = outstruct.MatrixJoint{1} ;
      Xi = outstruct.MatrixIndiv{1} ;
      Yj = outstruct.MatrixJoint{2} ;
      Yi = outstruct.MatrixIndiv{2} ;
      AJIVEdecompVisualMJ(Xj,Xi,'X') ;
      AJIVEdecompVisualMJ(Yj,Yi,'Y') ;

    elseif itest == 8 

      disp('Test Main Program, big ranks input, 10 & 5') ;
      paramstruct = struct('ioutput',[0 0 0 0 0 0 1 1 0]) ;
      outstruct = AJIVEMainMJ({X,Y},[10; 5],paramstruct)
      Xj = outstruct.MatrixJoint{1} ;
      Xi = outstruct.MatrixIndiv{1} ;
      Yj = outstruct.MatrixJoint{2} ;
      Yi = outstruct.MatrixIndiv{2} ;
      AJIVEdecompVisualMJ(Xj,Xi,'X') ;
      AJIVEdecompVisualMJ(Yj,Yi,'Y') ;

    elseif itest == 9 

      disp('Test Main Program, big ranks input, 20 & 30') ;
      paramstruct = struct('ioutput',[0 0 0 0 0 0 1 1 0]) ;
      outstruct = AJIVEMainMJ({X,Y},[20; 30],paramstruct)
      Xj = outstruct.MatrixJoint{1} ;
      Xi = outstruct.MatrixIndiv{1} ;
      Yj = outstruct.MatrixJoint{2} ;
      Yi = outstruct.MatrixIndiv{2} ;
      AJIVEdecompVisualMJ(Xj,Xi,'X') ;
      AJIVEdecompVisualMJ(Yj,Yi,'Y') ;

    elseif itest == 10 

      disp('Test Main Program, mean subtraction 0 0') ;
      paramstruct = struct('imean',[0 0]) ;
      AJIVEMainMJ({X,Y},[2; 3],paramstruct)

    elseif itest == 11 

      disp('Test Main Program, mean subtraction 1 1') ;
      paramstruct = struct('imean',[1; 1]) ;
      AJIVEMainMJ({X,Y},[2; 3],paramstruct)

    elseif itest == 12 

      disp('Test Main Program, mean subtraction 2 3') ;
      paramstruct = struct('imean',[2 3]) ;
      JIVEMainMJ({X,Y},[2; 3],paramstruct)

    elseif itest == 13 

      disp('Test Main Program, iplot 0 0') ;
      paramstruct = struct('iplot',[0 0]) ;
      AJIVEMainMJ({X,Y},[2; 3],paramstruct)

    elseif itest == 14 

      disp('Test Main Program, iplot 1 1') ;
      paramstruct = struct('iplot',[1 1]) ;
      AJIVEMainMJ({X,Y},[2; 1],paramstruct)

    elseif itest == 15 

      disp('Test Main Program, iplot 1 1') ;
      paramstruct = struct('iplot',[1 1]) ;
      AJIVEMainMJ({X,Y},[3; 5],paramstruct)

    elseif itest == 16 

      disp('Test Main Program, iplot 0 1, boundp = 65 85') ;
      paramstruct = struct('iplot',[0 1], ...
                           'boundp',[65 85]) ;
      AJIVEMainMJ({X,Y},[3; 5],paramstruct)

    elseif itest == 17 

      disp('Test Main Program, iplot 0 1, boundp = 20, threp = 20') ;
      paramstruct = struct('iplot',[0 1], ...
                           'boundp',20, ...
                           'threp',20) ;
      AJIVEMainMJ({X,Y},[3; 5],paramstruct)

    elseif itest == 18 ;

      disp('Test Main Program, iplot 0 1, boundp = 20, threp = 80') ;
      paramstruct = struct('iplot',[0 1], ...
                           'boundp',20, ...
                           'threp',80) ;
      AJIVEMainMJ({X,Y},[3; 5],paramstruct)

    elseif itest == 19 

      disp('Test Main Program, iplot 1 1') ;
      paramstruct = struct('iplot',[1 1], ...
                           'dataname', ...
                           {{'Name X' 'Name Y'}}) ;
      AJIVEMainMJ({X,Y},[3; 5],paramstruct)

    elseif itest == 101 

      disp('Test Initial SVD Code') ;
      AJIVEPreVisualMJ({X,Y})

    elseif itest == 102 

      disp('Test Initial SVD Code') ;
      AJIVEPreVisualMJ({X,Y},{[1 2], [2 3]})

    elseif itest == 103 

      disp('Test Initial SVD Code') ;
      AJIVEPreVisualMJ({X,Y},{[1 2 5 10], [5 15 25 35 45 55 65 75 85]})

    elseif itest == 104 

      disp('Test Initial SVD Code, numcompshow 20') ;
      AJIVEPreVisualMJ({X,Y},{[1 2], [2 3]},20)

    elseif itest == 105 

      disp('Test Initial SVD Code, numcompshow 200') ;
      AJIVEPreVisualMJ({X,Y},{[1 2], [2 3]},200)


    end 

end


