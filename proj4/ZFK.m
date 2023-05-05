function [x, flag, iter, lambda]=ZFK(A, b, c, w, solver, x0, eps)
% flag:
%   2 - converged to solution that is not optimal
%   1 - converged to optimal solution (within eps)
%   0 - iterations ended, did not reach optimal solution

assert(w > 1)
rk = 1;
iter = 0;
xk = x0;
lambda = 0;

pk = @(x, rk) rk * (max(0, constraints(x, c))^2 + max(0, -x)' * max(0, -x));
fk = @(x, rk) fun(x, A, b) + pk(x, rk);

while iter < 1000
    % solve current problem
    [x_next, flag] = solver(@(x) fk(x, rk), xk);
    
    if flag < 0
        x = xk;
        return;
    end

   % check stop criteriums
   pk_next = pk(x_next, rk);
   if pk_next < eps || ...
       norm(gradFk(A, b, c, x_next, rk), 2) < eps
        x = x_next;
        [lambda, flag] = WKT(x, A, b, c, 1, eps);
        return;
   end

   rk = w * rk;
   xk = x_next;
   iter = iter + 1;
end

x = xk;
[lambda, flag] = WKT(x, A, b, c, 0, eps);

end

function grad = gradFk(A, b, c, x, rk)

[~, gradF] = fun(x, A, b);
[C, ~, gradC] = constraints(x, c);
gradP = rk * (2 * max(0, C) * gradC - 2 * max(0, -x));

grad = gradF + gradP;

end

function [lambda, flag] = WKT(x, A, b, c, flag, eps)

[~, gradF] = fun(x, A, b);
[C, ~, gradC] = constraints(x, c);
G = [gradC, -eye(length(x))];

b = [-gradF; 0];
A = [G; C, -x'];

lambda = linsolve(A, b);

if sum(lambda < -0.001) > 0 % value of constraints <= 0

    if flag == 1
        flag = 2;
    end
    return;
end

flag = 1;

end