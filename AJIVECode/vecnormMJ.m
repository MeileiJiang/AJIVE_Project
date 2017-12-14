function n = vecnormMJ(A, p, DIM)
%vecnormMJ Vector norm
%   n = vecnormMJ(A) returns the 2-norm of the elements of vector A. For
%   matrices, N is a row vector containing the 2-norm of each column. For
%   N-D arrays, N is the 2-norm of the elements along the first array
%   dimension whose size does not equal 1. The size of the dimension
%   operated on by VECNORM becomes 1 while the size of all other dimensions
%   remains the same.
%
%   n = vecnormMJ(A,p) returns the vector p-norm defined by
%   sum(abs(v).^p)^(1/p), where p is any positive real value or Inf.
%
%   n = vecnormMJ(A,p,DIM) finds the p-norm along the dimension DIM of A.  

%   Copyright 2017 Meilei Jiang
    if ~exist('p', 'var')
        p = 2;
    end

    if ~exist('DIM', 'var')
        DIM = 1;
    end

    n = (sum(abs(A).^p, DIM)).^(-1/p);

end

