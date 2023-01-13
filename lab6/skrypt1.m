clc
clear

% etap 1.
P = randi([0, 10], 3, 4);
Q = randi([0, 10], 3, 4);

solve_linprog_both(P, Q);

% etap 3.
% test(100)