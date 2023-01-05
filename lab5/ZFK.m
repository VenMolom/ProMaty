function [x, flag, iter, lambda]=ZFK(A, b, c, w, solver, x0, eps)

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
   if pk(x_next, rk) < eps || ...
       norm(x_next - xk, 2) < eps || ...
       norm(gradFk(A, b, c, x_next, rk), 2) < eps
        flag = 1;
        x = x_next;
        return;
   end

   rk = w * rk;
   xk = x_next;
   iter = iter + 1;
end

x = xk;
flag = 0;

end
function grad = gradFk(A, b, c, x, rk)

[~, gradF] = fun(x, A, b);
[C, gradC] = constraints(x, c);
gradP = rk * (2 * max(0, C) * gradC - 2 * max(0, -x));

grad = gradF + gradP;

end
