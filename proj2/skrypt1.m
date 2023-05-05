clc
clear
rng('shuffle');

% etap 1.
disp("Solving using linprog");
m = 5;
n = 5;

[A, b, c, g] = generate_problem(m, n);

[x, fval, ~, ~, lambda] = solve_linprog(c, A, b, g);
display(x);
display(fval);
display(lambda);

% etap 2.
disp("Solving dual problem using linprog");
[y, fval, ~, ~, lambda] = solve_linprog_dual(c, A, b, g);
display(y);
display(fval);
display(lambda);

% etap 3.
disp("Solving dual problem using sympleks");
[ZPx, ZDy, val, ZDinfo, iter] = sympleks(c, A, b, g, SymplexOptions(true, 1e-10));

% etap 3. (testy)
disp("Testing 100 cases (with or without solution)");
test(100, false);
disp("Testing 100 cases (only with solution)");
test(100, true);