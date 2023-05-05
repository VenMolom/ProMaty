clc
clear

P = randi([0, 10], 3, 4);
Q = randi([0, 10], 3, 4);

% etap 1.
[x, l] = solve_linprog_both(P, Q);

% etap 2.
[x_ipm, l_ipm] = solve_ipm(P, Q);

disp(norm(x - x_ipm))
disp(norm(l - l_ipm))

% etap 3.
test1(100)
test2(100)