clc
clear
rng('shuffle');

n = 2;
m = 2*n;

% A = randi([-10, 10], m, n);
% b = randi([-10, 10], m, 1);
% c = 0.5;
A = [10 -4
    1 -9
    -5 -2
    -3 -9];
b = [-6 1 -3 -5]';
c = 0.2653;

x0 = zeros(n, 1);

opts = optimoptions(@fmincon,'Algorithm','interior-point', ...
    'SpecifyObjectiveGradient',true, ...
    'SpecifyConstraintGradient',true, ...
    'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-8);
lb = zeros(n, 1);
ub = Inf(n, 1);
[x, fval, flag, output] = fmincon(@(x) fun(x, A, b), x0, [], [], [], [], lb, ub, @(x) constraints(x, c), opts);
disp(x);
disp(fval);
disp(flag);
disp(output);