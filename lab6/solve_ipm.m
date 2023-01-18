function [x, lambda] = solve_ipm(P, Q)

f = (1:8)';
A = [P, -Q; ones(1, 4), zeros(1, 4); zeros(1, 4), ones(1, 4)];
b = [zeros(3, 1); ones(2, 1)];

eps = 1e-8;
M = 1e8;

disp("Solving with IPM")
[x, ~, flag, ~, lambda] = IPM(f, A, b, 1000, eps, M);

display(x)
display(flag)
display(lambda)

point = [];
if flag == 1 
    disp("Collision found")
    point = P * x(1:4);
    display(point);
end

plot_result(P, Q, point, 99);

end

