clc
clear

P = randi([0, 10], 3, 4);
Q = randi([0, 10], 3, 4);
% P = [10	1	0	8
% 7	7	4	10
% 1	4	1	0];
% Q = [7	9	1	8
% 7	3	8	6
% 2	0	7	9];

% etap 1.
[x, l] = solve_linprog_both(P, Q);

% etap 2.
[x_ipm, l_ipm] = solve_ipm(P, Q);

disp(norm(x - x_ipm))
disp(norm(l - l_ipm))

% etap 3.
test1(100)
test2(100)