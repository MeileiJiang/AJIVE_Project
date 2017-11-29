function randU = randorth(nsim)
% function for generating random orthogonal matrix
% generating random gaussion matrix and then doing the QR decomposition. 
[randU, ~] = qr(randn(nsim));
end