clc
clear

P = randi([0, 10], 3, 4);
Q = randi([0, 10], 3, 4);

% etap 1.
solve_linprog_both(P, Q);

% etap 2.
solve_ipm(P, Q);

% etap 3.
% test(100)