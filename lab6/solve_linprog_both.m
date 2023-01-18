function [x, lambda] = solve_linprog_both(P, Q)

disp("Solving primary problem")
[x, fp, xlambda, flag] = solve_linprog(P, Q);

disp("Solving dual problem")
[y, fd, ylambda] = solve_linprog_dual(P, Q);

display(x)
display(fp)
display(xlambda)
display(y)
display(fd)
display(ylambda)

lambda = xlambda;

point = [];
if flag == 1 
    disp("Collision found")
    point = P * x(1:4);
    display(point);
end

plot_result(P, Q, point, 98);

end

