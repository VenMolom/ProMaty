clc
clear
rng('shuffle');

n = 2;

[A, b, c] = generate_problem(n);
% A = [10, -4
%     1 -9
%     -5 -2
%     -3 -9];
% b = [-6; 1; -3; -5];
% c = 0.2653;

x0 = zeros(n, 1);
eps = 1e-8;

% etap 1.
disp("Solving using fmincon");
[x_fmin, ~, flag, ~, lambda] = solve_fmincon(A, b, c, x0, eps);
display(x_fmin);
display(flag);
lambda = [lambda.ineqnonlin; lambda.lower];
display(lambda);

% etap 2.
disp("Solving using ZFK with fminsearch");
[x_zfk, ~, flag, ~, lambda] = solve_ZFK(A, b, c, x0, true, eps);
display(x_zfk);
display(flag);
display(lambda);

disp(norm(x_zfk - x_fmin, 2));
disp(constraints(x_zfk, c));

% etap 3.
disp("Solving using ZFK with NelderMead");
[x_zfk, ~, flag, ~, lambda] = solve_ZFK(A, b, c, x0, false, eps);
display(x_zfk);
display(flag);
display(lambda);

disp(norm(x_zfk - x_fmin, 2));

% testy
test(100);