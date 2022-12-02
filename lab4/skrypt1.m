clear;
clc;

p1 = 1;
p2 = 10;
n = 5;

[A, b] = generate_problem(p1, p2, n);
display(A);
display(b);

% etap 1
xExact = A \ b;
display(xExact);

x0 = zeros(n, 1);

disp("Solving with fminunc");
xFminunc = solve_fminunc(A, b, x0);

display(xFminunc);
disp(norm(xExact - xFminunc));

% etap 2
eps = 1e-6;

disp("Solving with NS");
[xNS, iterNS] = NS(@(x) fun(x, A, b), x0, eps, 10000);

display(iterNS);
display(xNS);
disp(norm(xExact - xNS));

% etap 3
[xBFGS, ~, iterBFGS, h] = BFGS(@(x) fun(x, A, b), x0, eps, "Anal", 10000);
display(iterBFGS);
display(xBFGS);
disp(norm(xExact - xBFGS));

[xBFGS, ~, iterBFGS] = BFGS(@(x) fun(x, A, b), x0, eps, "Gold", 10000);
display(iterBFGS);
display(xBFGS);
disp(norm(xExact - xBFGS));
disp(norm(inv(A) - h));

% etap 4
testy1(p1, p2, 100);