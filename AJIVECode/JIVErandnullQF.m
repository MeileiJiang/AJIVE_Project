function nullnorm = JIVErandnullQF(data, U, num, nsim)
% function for estimating energy on noisy directions
% Inputs:
% data: observed data matrix
% U: orthonormal basis of the estimated signal row space of the data
% num: number of directions to obtain. (equal to the number of signal components)
% nsim: number of re-samplings
% Output:
% nullnorm: estimated L2 norm of 'noisy' directions 

%    Copyright (c) J. S. Marron, Jan Hannig & Qing Feng

nullnorm = [] ;
d = size(U, 1);

parfor isim = 1:nsim
    
    nulldir = [];
    Usim = U;

    for i = 1:num
    
        tmp = randn(d,1);
    
        projvec = Usim'*tmp;
    
        tmp = tmp-  Usim*projvec;
    
        tmp = tmp/norm(tmp) ;
    
        nulldir = [nulldir tmp];
    
        Usim = [Usim tmp];
    
    end
    
    nulldir=orth(nulldir);
    
    nullnorm = [nullnorm; norm(data*nulldir)];
    
end


end