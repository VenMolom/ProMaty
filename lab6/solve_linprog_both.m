function solve_linprog_both(P, Q)

disp("Solving primary problem")
[x, lambda, flag] = solve_linprog(P, Q);

disp("Solving dual problem")
y = solve_linprog_dual(P, Q);

display(x)
display(lambda)
display(y)

point = [];
if flag == 1 
    disp("Collision found")
    point = P * x(1:4);
    display(point);
end

plot_result(P, Q, point);

end

