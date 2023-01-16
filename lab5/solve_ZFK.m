function [x, fval, flag, iter, lambda] = solve_ZFK(A, b, c, x0, fmin, eps)

w = 5;

if fmin 
    opts = optimset('fminsearch');
    opts = optimset(opts, 'TolX', eps, 'TolFun', eps, 'MaxFunEvals', 10000, 'Display', 'none');
    solver = @(f, x) fminsearch(f, x, opts);
else
    solver = @(f, x) NelderMead(f, x, 10000, eps);
end

[x, flag, iter, lambda] = ZFK(A, b, c, w, solver, x0, eps);
fval = fun(x, A, b);

end

