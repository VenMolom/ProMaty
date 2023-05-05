function [x, fval, flag, out, lambda] = solve_linprog(c, A, b, g)
%SOLVE_LINPROG Find optimal solution to problem
% max c'x where Ax <= b and x <= g
%
% x - found solution, or empty if none.
% fval - function value corresponding to found solution or NaN if no
% solution found.
% flag - exit flag, same as in `linprog`.
% out - output structure, same as in `linprog`.
% lambda - Lagrange multipliers, or empty if no solution found.

opt = optimoptions("linprog", "Algorithm", "dual-simplex");
lb = repmat(-Inf, length(c), 1);
[x, fval, flag, out, lambda] = linprog(-c, A, b, [], [], lb, g, opt);

if flag <= 0 
    fval = NaN;
    x = [];
    lambda = [];
    return;
end

fval = -fval;
lambda = [lambda.ineqlin; lambda.upper];

end

