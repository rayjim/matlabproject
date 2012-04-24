function [x, numIter] = SPCA_ALM(A, lambda)
% File: SPCA_ALM.M
% Author: Nikhil Naikal (nnaikal@eecs.berkeley.edu)
% Date: January, 2011.
% Description:
% This matlab code implements the augmented Lagrange multiplier method for
% Sparse PCA. For algorithm details, refer to the paper: N. Naikal, A.Yang, 
% S.S. Sastry, "Informative Feature Selection for Object Recognition via 
% Sparse PCA", ICCV 2011.
%
% Inputs: 
%       A - nxn Empirical covariance matrix.
%       lambda - Sparsity controlling parameter (data dependent)
%
%
% Outputs:
%       x - First sparse principal vector
%       numIter - Number of iterations
%
% Copyright: University of California at Berkeley.

    % Initialize
    disp('this is SVD');
    n = size(A,1);
    [U, S, V] = svd(A);
    disp('this is the end of SVD');
    X = (U(:,1)*U(:,1)');
    Y = zeros(n,n);
    c = 1;
    nIter = 100;
    iter = 1;
    X_Old = X;
    converged = 0;
    numIter = 0;
    lambdaMat = lambda*ones(n,n);
    
    while(iter<nIter && ~converged)

        % Minimize unconstrained lagrangian
        %%%%%%%%%%%%%%%%%%%%%%%%
                disp(iter);
                Xk = X;
                Xkm1 = Xk;
                Yalm = Xk;
                Z = rand(n,n);
                t1 = 1;
                k = 1;
                objt_grad = @(In)objt_grad_func(A, c, Y, lambdaMat, In);
                [~, gY] = objt_grad(Yalm);
                [~, gZ] = objt_grad(Z);
                alpha = norm(Yalm - Z)/norm(gY - gZ);
                nIter2 = 100;
                converged2 = 0;

                % Repeat till convergence
                while(~converged2 && (k<nIter2))
                    % Step1 - Calculate smallest i
                    [fYk, gYk] = objt_grad(Yalm);
                    for i = 0:5
                        [fChk, ~] = objt_grad(Yalm - (alpha/(2^i))*gYk);
                        if (fYk - fChk) >= ((alpha/(2^(i+1)))*(norm(gYk)^2))
                            break;
                        end
                    end

                    % Step2 - Update x and alpha
                    alpha = alpha/(2^i);
                    Xk = Yalm - alpha*gYk;

                    % Step3 - Update step size
                    t2 = (1 + sqrt(1 + 4*(t1^2)))/2;

                    % Step4 - Update y
                    Yalm = Xk + ((t1-1)/t2)*(Xk - Xkm1);

                    % Check for convergence
                    t1 = t2;
                    curDiff2 = norm(Xk - Xkm1);
                    if (curDiff2<1e-6)
                        converged2 = 1;
                    end
                    Xkm1 = Xk;
                    k = k+1;
                end
                X = Xk;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        numIter = numIter + k;
        gap = norm(X - X_Old);
        
        % update lagrange multiplier, y
        chk1 = Y + c*(X - lambda*ones(n,n));
        chk2 = Y + c*(X + lambda*ones(n,n));
        fnd1 = find(chk1>0);
        fnd2 = find(chk2<0);
        Y = zeros(n,n);
        Y(fnd1) = chk1(fnd1);
        Y(fnd2) = chk2(fnd2);

        % update c
        c = 2^iter;

%         fprintf('\n Outer = %i;  Inner = %i  Duality Gap = %f',iter, k, gap);
        if (gap<1e-6)
            converged = 1;
        end
        X_Old = X;
        iter = iter + 1;
    end
    % Extract the primal from the dual
    x = GetPrimal(A, X);
    
end

function [fX, gX] = objt_grad_func(A, c, Y, lambda, X)

    n = size(X,1);
    chk1 = lambda - Y/c;
    chk2 = -lambda - Y/c;
    
    dP = zeros(n,n);
    dP(X>=chk1) = Y(X>=chk1) + c*(X(X>=chk1) - lambda(X>=chk1));
    dP(X<=chk2) = Y(X<=chk2) + c*(X(X<=chk2) + lambda(X<=chk2));
    
    P = -( (Y.^2)/(2*c) );
    P(X>=chk1) = Y(X>=chk1).*(X(X>=chk1) - lambda(X>=chk1)) + (c/2)*((X(X>=chk1) - lambda(X>=chk1)).^2);
    P(X<=chk2) = Y(X<=chk2).*(X(X<=chk2) + lambda(X<=chk2)) + (c/2)*((X(X<=chk2) + lambda(X<=chk2)).^2);

    epsilon = 0.01;
    mu = epsilon/(2*log(n));
    [~, f, g] = matrixExp(A, X, mu);
%     buf_exp = expm((A + X)/mu);
%     f = mu*log(trace(buf_exp)) - mu*log(n);
%     g = (buf_exp/trace(buf_exp));
    fX = f + sum(P(:));
    gX = g + dP;
    
end

function x = GetPrimal(Amat, Xmat)
    epsilon = 0.01;
    mu = epsilon/(2*log(size(Amat,1)));
    [~, ~, Umat] = matrixExp(Amat, Xmat, mu);
    [V, D] = eig(Umat);
    diagD = diag(D);
    [~, ind] = max(diagD);
    x = V(:,ind);
end