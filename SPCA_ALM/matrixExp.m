function [dmax, f, g] = matrixExp(A, X, mu)
% File: MATRIXEXP.M
% Author: Nikhil Naikal (nnaikal@eecs.berkeley.edu)
% Date: January, 2011.
% Description:
% This matlab code computes the smooth uniform approximation of the maximum
% eigenvalue function, and it's gradient. For details refer to the paper:
% A. d’Aspremont, L. El Ghaoui, M.I. Jordan, and G. R. G. Lanckriet.,
% "A direct formulation for sparse PCA using semidefinite programming.",
% SIAM Review, 49(3):434–448, 2007.
%
% Inputs: 
%       A - nxn Empirical covariance matrix.
%       X - nxn Dual variable
%       mu - Precision controlling parameter.
%
% Outputs:
%       dmax - Largest eigenvalue
%       f - the function: mu log (Tr exp((A+ X)/mu)) ? mu log n.
%       g - function gradient: exp ((A + X)/mu) /trace (exp ((A + X)/mu))
%
% Copyright: University of California at Berkeley.

    n = size(A,1);
    if nargin<3
        eps = 10;
        mu = eps/(2*log(n));
    end
    [V, D] = eig(A + X);
    V = real(V);
    D = real(D);
    [~, ind] = max(diag(D));
    dmax = D(ind,ind);
    hvec = exp((diag(D) - ones(n,1)*dmax)/mu);
    buf = sum(hvec);
    f = dmax + mu*log(buf) - mu*log(n);
    gvec = hvec/buf;
    g = V*diag(gvec)*V';
%     buf_exp = expm((A + X)/mu);
%     f = mu*log(trace(buf_exp)) - mu*log(n);
%     g = (buf_exp/trace(buf_exp));
end
    