function [x, flag] = solve_sympleks(P, Q, verbose)
%SOLVE_SYMPLEX Find intersection betwem two tetrahedrons defined by
%vertices in P and Q, using custom simplex implementation.
% P, Q - matrices containing tetrahedron vertices as columns and their
% coordinates as rows.
%
% x - coordinates of found intersection point or empty vector if no
% solution found.
% flag - exit flag, same as in `linprog`.

f = zeros(8, 1);
A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
b = [zeros(3, 1); ones(2, 1)];
[x, ~, flag] = sympleks(f, A, b, SymplexOptions(verbose, 1e-10));

if flag == 1
    x = P * x(1:4);
end

end

