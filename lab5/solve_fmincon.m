function [x, fval, flag, output] = solve_fmincon(A, b, c, x0, eps)

opts = optimoptions(@fmincon,'Algorithm','interior-point', ...
    'SpecifyObjectiveGradient',true, ...
    'SpecifyConstraintGradient',true, ...
    'OptimalityTolerance', eps, ...
    'StepTolerance', eps);
n = length(x0);
lb = zeros(n, 1);
ub = Inf(n, 1);
[x, fval, flag, output] = fmincon(@(x) fun(x, A, b), x0, [], [], [], [], ...
    lb, ub, @(x) constraints(x, c), opts);

end