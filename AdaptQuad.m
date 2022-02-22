function I = AdaptQuad(fun,a,b,n,epsilon)
format long
[x,w]=lgwt(n,a,b); % take x and w valuse for solving with n poits
max_iter = 1e3; % define maximum number of iteration
I_prev = w'*fun(x); %solving the full interval for solution quality approximate
I = AdaptQuad_rec(fun,a,b,epsilon,I_prev,n,max_iter); % solving with the recursive function
end

function I = AdaptQuad_rec(fun,a,b,epsilon,I_prev,n,remain_iter)
% This function solves the integration in interation. Every iteration the
% sum of the tow half intervals compare to the value of the complite
% interval, if it fit to the error precision the answer return ,else it
% split the interval to halfs and solve again.
    format long
    if remain_iter <= 0 % stop to avoid to long procceing time
         fprintf('Adaptive Iteration Failed on interval [%.2f , %.2f]',a,b)
         I = 0 ;
         return 
    end
    %splliting the interval to halfs.
    a1 = a; b1 = (a+b)/2; 
    a2 = b1; b2 = b;
    % get the wights and the location for solving the integration
    [x1,w1] = lgwt(n,a1,b1);
    [x2,w2] = lgwt(n,a2,b2);
    % calclate both half-intervals values
    I1 = w1'*fun(x1);
    I2 = w2'*fun(x2);
    % if the error between the full interval and the sum of the splitted
    % interval are fitting to the error precsion , return the answer
    if abs(I1+I2-I_prev)<eps
        I = I1+I2;
    else
        % if it not fit, solve again each part in separate and sum the
        % answers.
        I = AdaptQuad_rec(fun,a1,b1,epsilon,I1,n,remain_iter-1)+...
            AdaptQuad_rec(fun,a2,b2,epsilon,I2,n,remain_iter-1);
    end
end

function [x,w]=lgwt(N,a,b)

% lgwt.m
%
% This script is for computing definite integrals using Legendre-Gauss 
% Quadrature. Computes the Legendre-Gauss nodes and weights  on an interval
% [a,b] with truncation order N
%
% Suppose you have a continuous function f(x) which is defined on [a,b]
% which you can evaluate at any x in [a,b]. Simply evaluate it at all of
% the values contained in the x vector to obtain a vector f. Then compute
% the definite integral using sum(f.*w);
%
% Written by Greg von Winckel - 02/25/2004
N=N-1;
N1=N+1; N2=N+2;

xu=linspace(-1,1,N1)';

% Initial guess
y=cos((2*(0:N)'+1)*pi/(2*N+2))+(0.27/N1)*sin(pi*xu*N/N2);

% Legendre-Gauss Vandermonde Matrix
L=zeros(N1,N2);

% Derivative of LGVM
Lp=zeros(N1,N2);

% Compute the zeros of the N+1 Legendre Polynomial
% using the recursion relation and the Newton-Raphson method

y0=2;

% Iterate until new points are uniformly within epsilon of old points
while max(abs(y-y0))>eps
    
    
    L(:,1)=1;
    Lp(:,1)=0;
    
    L(:,2)=y;
    Lp(:,2)=1;
    
    for k=2:N1
        L(:,k+1)=( (2*k-1)*y.*L(:,k)-(k-1)*L(:,k-1) )/k;
    end
 
    Lp=(N2)*( L(:,N1)-y.*L(:,N2) )./(1-y.^2);   
    
    y0=y;
    y=y0-L(:,N2)./Lp;
    
end

% Linear map from[-1,1] to [a,b]
x=(a*(1-y)+b*(1+y))/2;      

% Compute the weights
w=(b-a)./((1-y.^2).*Lp.^2)*(N2/N1)^2;
end