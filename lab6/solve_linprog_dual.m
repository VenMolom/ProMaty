function [y, f, lambda, flag] = solve_linprog_dual(P, Q)

f = (1:8)';
A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
b = [zeros(3, 1); ones(2, 1)];
opt = optimoptions("linprog", ...
    "ConstraintTolerance", 1e-8, ...
    "OptimalityTolerance", 1e-8, ...
    "MaxIterations", 10000);
[y, f, flag, ~, lambda] = linprog(b, -A', -f, [], [], [], [], opt);

if flag == 1
    lambda = lambda.ineqlin;
end

end

