function [x, numIter] = DSPCA(Amat, lambda)
% File: DSPCA.M
% Author: Nikhil Naikal (nnaikal@eecs.berkeley.edu)
% Date: January, 2011.
% Description:
% This matlab code implements the DSPCA method presented in the paper:
% A. d’Aspremont, L. El Ghaoui, M.I. Jordan, and G. R. G. Lanckriet.,
% "A direct formulation for sparse PCA using semidefinite programming.",
% SIAM Review, 49(3):434–448, 2007.
% Inputs: 
%       Amat - nxn Empirical covariance matrix.
%       lambda - Sparsity controlling parameter (data dependent)
%
%
% Outputs:
%       x - First sparse principal vector
%       numIter - Number of iterations
%
% Copyright: University of California at Berkeley.

    tol=.01;
    n = size(Amat,1);
    checkgap = 100;
    checkgap_count=1;
    gapchange = 1e-3;
    firstiter=0;
    
    % First, compute some local params
	d1=lambda*lambda*n/2; sig1=1.0; d2=log(n); sig2=0.5; norma12=1.0; mu=tol/(2.0*d2);
	Ntheo=(4.0*norma12*sqrt(d1*d2/(sig1*sig2)))/tol; Ntheo=ceil(Ntheo);
	L=(d2*norma12*norma12)/(2.0*sig2*tol);
    k=0;
    
    % Initialize X
%     [V, D] = eig(Amat); [~, ind] = max(diag(D));
    Xmat = zeros(n,n); %V(:,ind)*V(:,ind)';
    Fmat = zeros(n,n);
    
    MAXITER = 4000;
    converged = 0;
    
    while( (~converged) && k<MAXITER)
        % Compute objectuve and gradient
        [dmax, ~, Umat] = matrixExp(Amat, Xmat, mu);
        
        % Update gradient's weighted average 
		alpha=(k+1)/2;
		Fmat = alpha*Umat + Fmat;
        
        % Find a projection of X-Gmu/L on feasible set 
		alpha=-1/L;
		bufmata = alpha*Umat + Xmat;
        
        % Project again
		alpha=-(sig1/L);
        bufmatb = alpha*Fmat;
        
        % update X
		rho=2.0/(k+3); lambdaMat = lambda*ones(n,n);
        Xmat = rho*sign(bufmatb).*min(lambdaMat, abs(bufmatb)) + (1-rho)*sign(bufmata).*min(lambdaMat, abs(bufmata));
        if isnan(real(Xmat(1,1)))
            keyboard;
        end
        % Check gap
        if (mod(k, checkgap) == 0)
            gapk=dmax-trace(Amat*Umat)+lambda*sum(sum(abs(Umat)));
            if (firstiter==1) 
                dualitygap_alliter(checkgap_count)=gapk;
                checkgap_count = checkgap_count+1;
            end
            if (firstiter==0)
                % If first iteration, reset precision targets
				tol=gapk*gapchange; norma12=1.0; d1=lambda*lambda*n*n/2.0; sig1=1.0; d2=log(n); sig2=0.5; mu=tol/(2.0*d2);
				L=(d2*norma12*norma12)/(2.0*sig2*tol);
				Xmat = zeros(n,n); Fmat = zeros(n,n);
                firstiter = 1;
            end
            if (gapk<=tol)
                converged = 1;
            end
        end
        k = k+1;
    end
    numIter = k;
    x = GetPrimal(Amat, Xmat, mu);   
end
    
function x = GetPrimal(Amat, Xmat, mu)
    [~,~, Umat] = matrixExp(Amat, Xmat, mu);
    [V, D] = eig(Umat);
    diagD = diag(D);
    [~, ind] = max(diagD);
    x = V(:,ind);
end