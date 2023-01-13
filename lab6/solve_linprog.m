function [x, lambda, flag] = solve_linprog(P, Q)

f = (1:8)';
A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
b = [zeros(3, 1); ones(2, 1)];
lb = zeros(8, 1);
opt = optimoptions("linprog", "Algorithm", "interior-point");
[x, ~, flag, ~, lambda] = linprog(-f, [], [], A, b, lb, [], opt);

if flag == 1
    lambda = lambda.eqlin;
end

end

