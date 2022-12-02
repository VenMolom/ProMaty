function [y, fval, flag, out, lambda] = solve_linprog_dual(c, A, b, g)
%SOLVE_LINPROG_DUAL Find optimal solution to dual problem to problem
% max c'x where Ax <= b and x <= g
%
% y - found solution, or empty if none.
% fval - function value corresponding to found solution or NaN if no
% solution found.
% flag - exit flag, same as in `linprog`.
% out - output structure, same as in `linprog`.
% lambda - Lagrange multipliers

n = length(c);
m = length(b);

Aeq = [A', eye(n)];
beq = c;
c = [b; g];
opt = optimoptions("linprog", "Algorithm", "dual-simplex");
lb = zeros(m+n, 1);
[y, fval, flag, out, lambda] = linprog(c, [], [], Aeq, beq, lb, [], opt);

if flag <= 0 
    fval = NaN;
    y = [];
    lambda = [];
    return;
end

lambda = lambda.eqlin;


end

