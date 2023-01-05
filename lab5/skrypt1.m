clc
clear
rng('shuffle');

n = 2;
m = 2*n;

[A, b, c] = generate_problem(n);
% A = [10 -4
%     1 -9
%     -5 -2
%     -3 -9];
% b = [-6 1 -3 -5]';
% c = 0.2653;

x0 = zeros(n, 1);
eps = 1e-8;

% etap 1.
disp("Solving using fmincon");
[x_fmin, ~, ~, output] = solve_fmincon(A, b, c, x0, eps);
disp(x_fmin);
disp(output);

% etap 2.
disp("Solving using ZFK with fminsearch");
[x_zfk, ~, ~, it] = solve_ZFK(A, b, c, x0, true, eps);
disp(x_zfk);
disp(it);

disp(norm(x_zfk - x_fmin, 2));

% etap 3.
disp("Solving using ZFK with NelderMead");
[x_zfk, ~, ~, it] = solve_ZFK(A, b, c, x0, false, eps);
disp(x_zfk);
disp(it);

disp(norm(x_zfk - x_fmin, 2));