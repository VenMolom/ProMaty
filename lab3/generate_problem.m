function [A, b, c, g] = generate_problem(m, n)

A = randi([-5, 5], m, n);
b = randi([-5, 5], m, 1);
c = randi([1, 5],  n, 1);
g = randi([1, 30], n, 1);

end

