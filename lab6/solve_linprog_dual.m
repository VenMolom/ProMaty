function [y, flag] = solve_linprog_dual(P, Q)

f = (1:8)';
A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
b = [zeros(3, 1); ones(2, 1)];
opt = optimoptions("linprog", "Algorithm", "interior-point");
[y, ~, flag] = linprog(b, -A', -f, [], [], [], [], opt);

end

