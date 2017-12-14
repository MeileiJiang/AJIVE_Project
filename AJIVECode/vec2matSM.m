function mat = vec2matSM(vec,num, iscalhand) 
% VEC2MATSM, Turns vectors into matrices (which are duplicates),
%   Steve Marron's matlab function
% Inputs:
%     vec        - row or column vector
%     num        - number of duplicates of vec to make
%     iscalhand  - index for handling scalar input
%                    0 - treat scalar (i.e. 1x1) vec as an error, 
%                            print warning message, and give empty return
%                    1 - (default) treat scalar (i.e. 1x1) vec as 
%                            column vector, and create 1xnum row vector,
%                            and print a warning message
%                    2 - treat scalar (i.e. 1x1) vec as column vector, 
%                            and create 1xnum row vector,
%                            with no warning message
%                    3 - treat scalar (i.e. 1x1) vec as row vector, 
%                            and create numx1 col vector,
%                            and print a warning message
%                    4 - treat scalar (i.e. 1x1) vec as row vector, 
%                            and create numx1 col vector,
%                            with no warning message


% Output:
%     mat  - matrix of duplicates of vec,
%               when vec is an nc x 1 column vector, mat is nc x num
%               when vec is a  1 x nr column vector, mat is num x nr

% Note:
%     To do this for BOTH a row and column vector, it is more 
%     convenient to use "meshgrid"

%    Copyright (c) J. S. Marron 1996, 1997, 2001


if nargin > 2 ;
  iscalh = iscalhand ;    %  input value
else ;
  iscalh = 1 ;    %  default value
end ;


[nr,nc] = size(vec) ;


if nc == 1 & nr == 1 ;     %  scalar, not vector input

  if  iscalh == 1  |  iscalh == 2  ;    %  then treat as column vector
    mat = vec * ones(1,num) ;


  elseif  iscalh == 3  |  iscalh == 4 ;    %  then treat as row vector
    mat = ones(num,1) * vec ;


  else ;    %  then print warning and return empty matrix
    mat = [] ;

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from vec2matSM: not a vector, returning empty matrix !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  end ;


elseif nc == 1 ;     %  then treat as column vector

  mat = vec * ones(1,num) ;


elseif nr == 1 ; %  then treat as row vector

  mat = ones(num,1) * vec ;


else ;            %  then not a vector, give warning
                  %  and return empty matrix
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!! Error from vec2matSM: invalid input, returning empty matrix !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  mat = [] ;
end ;

