function [x, flag, out] = solve_linprog(P, Q)
%SOLVE_LINPROG Find intersection betwem two tetrahedrons defined by
%vertices in P and Q, using `linprog` function.
% P, Q - matrices containing tetrahedron vertices as columns and their
% coordinates as rows.
%
% x - coordinates of found intersection point or empty vector if no
% solution found.
% flag - exit flag, same as in `linprog`.
% out - output structure, same as in `linprog`.

f = zeros(8, 1);
Aeq = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
beq = [zeros(3, 1); ones(2, 1)];
opt = optimoptions("linprog", "Algorithm", "dual-simplex");
lb = zeros(8, 1);
[x, ~, flag, out] = linprog(-f, [], [], Aeq, beq, lb, [], opt);

if flag == 1
    x = P * x(1:4);
end

end

