function [x, f, lambda, flag] = solve_linprog(P, Q)

f = (1:8)';
A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
b = [zeros(3, 1); ones(2, 1)];
lb = zeros(8, 1);
opt = optimoptions("linprog", ...
    "ConstraintTolerance", 1e-8, ...
    "OptimalityTolerance", 1e-8, ...
    "MaxIterations", 10000);
[x, f, flag, ~, lambda] = linprog(-f, [], [], A, b, lb, [], opt);
f = -f;

if flag == 1
    lambda = lambda.eqlin;
end

end

